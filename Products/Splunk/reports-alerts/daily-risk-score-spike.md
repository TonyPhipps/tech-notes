# Find Risk_Score Spikes from Daily Baseline (Single-Tenant Version)
1. The Baseline Generator (Scheduled Report) (consider also making one for the field 'user')
  - Schedule: Daily (e.g., 01:00 AM) Time Range: Last 30 days (-30d@d to -1d@d) Action: Save results to a CSV Lookup.
  - Schedule Window: Auto
  - This search handles the heavy JSON parsing and statistical crunching offline.

```sql
index IN ("myindex") source="My:Risk*" earliest=-30d@h latest=-1d@h
``` Parse fields before discarding _raw ```
| rex field=_raw "risk_score=(?<risk_score>\d+)"
| rex field=_raw "risk_rule_host=\"(?<host>[^,]+)\""

``` Pre-aggregate to save memory ```
| bin _time span=24h
| stats sum(risk_score) as raw_daily_risk by host _time

``` SEARCH HEAD PROCESSING: Zero-Filling Logic ```
| timechart span=24h fixedrange=t sum(raw_daily_risk) as daily_risk by host limit=0

``` ZERO-FILLING: Force empty buckets to 0 ```
| fillnull value=0

``` Calculate Median and MAD ```
| eventstats median(hourly_risk) as median by host
| eval abs_dev = abs(hourly_risk - median)
| stats values(median) as median median(abs_dev) as mad by host

``` Santize with a Safety Floor ```
| fillnull value=0 median mad
| eval mad = if(mad=0, 1, mad)
| outputlookup risk_baseline_hourly_host.csv
```

2. The Detection / Dashboard Widget
  - Schedule: Daily (e.g., */60 * * * * or specifically at minute 5) Time Range: Last 24 days
  - Schedule Window: Auto
  - This search is incredibly fast because it only processes 60 minutes of data.
  - Earliest = -24h

```sql
index IN ("myindex") source="My:Risk*" earliest=-1h@h latest=@h
``` MEMORY OPTIMIZATION: Keep only necessary fields first ```
| fields _raw
| rex field=_raw "risk_score=(?<risk_score>\d+)"
| rex field=_raw "risk_rule_host=\"(?<host>[^,]+)\""

``` Aggregate current risk, grouping by Host ```
| stats sum(risk_score) as current_daily_risk by host

``` Lookup baseline match on Host + Hour ```
| lookup risk_baseline_hourly_host.csv host hour_of_day OUTPUT median mad

``` Handle New Hosts or Silent Baselines ```
``` If lookup returns null (no history), default to 0 to force high sensitivity ```
| fillnull value=0 median mad

``` Calculate Z-Score Math with Safety Floors ```
``` percent_difference: (Current - Median) / Median ```
``` robust_z: (Current - Median) / (1.48 * MAD) ```
``` max(x, 1) ensures we NEVER divide by zero ```
| eval percent_difference = round((current_daily_risk - median) / max(median, 1) * 100, 2)
| eval abs_diff = current_daily_risk - median
| eval robust_z = round((current_daily_risk - median) / (1.4826 * max(mad, 1)), 2)

``` Threshold: Z > 3 (Statistical Outlier) AND Risk > 50 (Material Impact) ```
| where (robust_z > 3 AND current_daily_risk > 50) OR (abs_diff > 100)

``` Prettify ```
| table host current_daily_risk median mad percent_difference abs_diff robust_z
| sort - robust_z
```

1. Force a Trigger
Create a fake baseline entry
```sql
| makeresults 
| eval host="test-system-01"
| eval median=10, mad=2
| outputlookup append=t risk_baseline_daily_host.csv
```

Ensure it exists
```sql
|  inputlookup risk_baseline_daily_host.csv
| search host="test-system-01"
```

Create a fake, new high risk_score event
```sql
| makeresults 
| eval _time = relative_time(now(), "-3m")
| eval risk_rule_guid="TEST-REAL-TRIGGER-2025-12-23-1016", risk_rule_title="Simulated High Risk Alert", risk_rule_user="admin_test", risk_rule_host="test-system-01"
| eval _raw = "timestamp=" . _time . " risk_rule_guid=" . risk_rule_guid . " risk_rule_title=\"" . risk_rule_title . "\" risk_rule_user=" . risk_rule_user . " risk_rule_host=" . risk_rule_host . " name = \"RIR - Newly Observed Risk Rule\"" . " risk_score=1000"
| collect index="myindex" source="My:Risk" sourcetype="My:Risk"
```

Run the "The Detection / Dashboard Widget" search above to ensure a result exists.








# Find Risk_Score Spikes from Daily Baseline (Multi-Tenant Version)
1. The Baseline Generator (Scheduled Report) (consider also making one for the field 'user')
  - Schedule: Daily (e.g., 01:00 AM) Time Range: Last 30 days (-30d@d to -1d@d) Action: Save results to a CSV Lookup.
  - Schedule Window: Auto
  - This search handles the heavy JSON parsing and statistical crunching offline.

```sql
index IN ("indexes-*") sourcetype="my:Risk" earliest=-30d@h latest=-1d@h
``` EXTRACTION FIRST: Parse fields before discarding _raw ```
| eval host=risk_rule_host

``` COMPOSITE KEY: Combine Index and Host for Multi-Tenancy ```
| eval composite_key = index . "::" . host

``` COMPRESS ON INDEXERS: Pre-aggregate to save memory ```
``` Group by the composite key and time immediately ```
| bin _time span=24h
| stats sum(risk_score) as raw_daily_risk by composite_key _time

``` SEARCH HEAD PROCESSING: Zero-Filling Logic ```
| timechart span=24h fixedrange=t sum(raw_daily_risk) as daily_risk by composite_key limit=0

``` ZERO-FILLING: Force empty buckets to 0 ```
| fillnull value=0

``` FLATTEN: Convert matrix back to rows ```
| untable _time composite_key daily_risk

``` RESTORE KEYS: Split Index and Host back apart ```
| rex field=composite_key "(?<index>.*?)::(?<host>.*)"

``` STATISTICS: Calculate Median and MAD ```
| eventstats median(daily_risk) as median by index host
| eval abs_dev = abs(daily_risk - median)
| stats values(median) as median median(abs_dev) as mad by index host

``` SANITIZE: Safety Floor ```
| fillnull value=0 median mad
| eval mad = if(mad=0, 1, mad)
| outputlookup risk_baseline_daily_host.csv ```create_context=user```
```

2. The Detection / Dashboard Widget
  - Schedule: Daily (e.g., */60 * * * * or specifically at minute 5) Time Range: Last 24 days
  - Schedule Window: Auto
  - This search is incredibly fast because it only processes 60 minutes of data.
  - Earliest = -24h

```sql
index IN ("indexes-*") sourcetype="my:Risk" earliest=-1d@d latest=@d 
| fromjson risk_info 
| eval host=risk_rule_host 
| fields index host risk_rule_host sourcetype _time risk_score
    ``` Aggregate current risk for the past 24-hour period ```
| stats sum(risk_score) as current_daily_risk by index host risk_rule_host

``` Enrich with the Daily Baseline Stats ```
| lookup risk_baseline_daily_host.csv index host OUTPUT median mad

``` Calculate Statistics ```
| fillnull value=0 median mad
| eval percent_difference = round((current_daily_risk - median) / max(median, 1) * 100, 2)
| eval abs_diff = current_daily_risk - median
| eval robust_z = round((current_daily_risk - median) / (1.4826 * max(mad, 1)), 2)

``` Alert Logic (Outliers) ```
| where (robust_z > 3 AND current_daily_risk > 100) OR (abs_diff > 100)

| table index host risk_rule_host current_daily_risk median mad abs_diff percent_difference robust_z
| sort - robust_z

``` MAKE EVENT ```
``` Stash to remove headers ```
| map maxsearches=500 search="| makeresults
| eval _time=now(), name=\"RIR - Daily Host Risk Score Spike\", index=\"$index$\", risk_rule_host=\"$risk_rule_host$\", current_daily_risk=\"$current_daily_risk$\", median=\"$median$\", mad=\"$mad$\", abs_diff=\"$abs_diff$\", percent_difference=\"$percent_difference$\", robust_z=\"$robust_z$\"
| collect index=\"$index$\" source=\"my:Risk:Alert\" sourcetype=\"stash\""
```

3. Force a Trigger
Create a fake baseline entry
```sql
| makeresults 
| eval index="index-test"
| eval host="test-system-01"
| eval median=10, mad=2
| outputlookup append=t risk_baseline_daily_host.csv
```

Ensure it exists
```sql
|  inputlookup risk_baseline_daily_host.csv
| search host="test-system-01"
```

Create a fake, new high risk_score event
```sql
| makeresults 
| eval _time = relative_time(now(), "-3m")
| eval risk_rule_guid="TEST-REAL-TRIGGER-2025-12-23-1016", risk_rule_title="Simulated High Risk Alert", risk_rule_user="admin_test", risk_rule_host="test-system-01"
| eval _raw = "timestamp=" . _time . " risk_rule_guid=" . risk_rule_guid . " risk_rule_title=\"" . risk_rule_title . "\" risk_rule_user=" . risk_rule_user . " risk_rule_host=" . risk_rule_host . " name = \"RIR - Newly Observed Risk Rule\"" . " risk_score=1000"
| collect index="index-test" source="My:Risk" sourcetype="My:Risk"
```

Run the "The Detection / Dashboard Widget" search above to ensure a result exists.