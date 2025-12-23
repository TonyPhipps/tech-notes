# Force reload of savedsearches.conf After Updating
... without restarting the entire search Head
- ```https://<splunk_server>:<management_port>/servicesNS/<user>/<app>/saved/searches/_reload```
- ```http(s)://<splunk_server>:8000/debug/refresh```


# Generate Risk Rule Events in Orignial Index
Create a macro named something like 'risk-rule'. Add that macro to the end of a saved search
```
yoursearch
| `risk-rule("RR - The Alert Name", "the-alert-guid", "the-alert-severity-level")`
```
Arguments: risk_rule_title,risk_rule_guid,risk_rule_level
Definition:
```
fields - punct, date_hour, date_mday, date_minute, date_month, date_second, date_wday, date_year, date_zone, linecount, timeendpos, timestartpos, _bkt, _cd, _serial, _si, _pre_msg, _sourcetype, _subsecond, ForwardedRaw, message, Message, body

| tojson include_internal=true output_field=risk_info auto(*) 
| eval risk_rule_title = "$risk_rule_title_arg$"
| eval risk_rule_guid = "$risk_rule_guid_arg$"
| eval risk_rule_level = "$risk_rule_level_arg$"
| eval risk_info_time = _time
| eval risk_info_sourcetype = sourcetype
| eval risk_info_source = source
| eval sourcetype="ORG:Risk"
| eval risk_rule_level = lower(risk_rule_level)
| eval risk_score = case(
    isnum(risk_score), risk_score,
    isnum(risk_rule_level), risk_rule_level,
    match(risk_rule_level, "informational"), 1,
    match(risk_rule_level, "low"), 2,
    match(risk_rule_level, "medium"), 4,
    match(risk_rule_level, "high"), 8,
    match(risk_rule_level, "critical"), 16,
    1==1, "-"
)

| eval host = coalesce(srcHostName, host)
| eval host_coalesce = coalesce(src_host,dst_host,host)
| rex field=host_coalesce "^(?i)(?<risk_rule_host>(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})|[^\.]+)"
| eval risk_rule_host = upper(risk_rule_host)

| eval User = if(User IN ("NOT_TRANSLATED", "-"), null(), User)
| eval user = if(user IN ("NOT_TRANSLATED", "-"), null(), user)
| eval Account_Name = if(like(Account_Name, "%$"), null(), Account_Name)
| eval user_coalesce = coalesce(src_user,dst_user,user,Account_Name)
| rex field=user_coalesce "(.+\\\)?(?<risk_rule_user>[^@]+)(@[\w\.-]+)?" 
| eval risk_rule_user=case(
    risk_rule_user="SYSTEM" OR risk_rule_user="NETWORK SERVICE", lower(risk_rule_host."$"),
    1==1, lower(risk_rule_user)
) 

| table _time, index, risk_rule_source, sourcetype, risk_rule_title, risk_rule_guid, risk_rule_level, risk_score, risk_rule_host, risk_rule_user, risk_info_source, risk_info_sourcetype, risk_info_time, risk_info
| map maxsearches=5000 search=" | makeresults | eval _time=$_time$, risk_rule_title=\"$risk_rule_title$\", risk_rule_guid=\"$risk_rule_guid$\", risk_rule_level=\"$risk_rule_level$\", risk_score=\"$risk_score$\", risk_rule_host=\"$risk_rule_host$\", risk_rule_user=\"$risk_rule_user$\", risk_info_source=\"$risk_info_source$\", risk_info_sourcetype=\"$risk_info_sourcetype$\", risk_info_time=\"$risk_info_time$\", risk_info=\"$risk_info$\" | collect index=$index$ sourcetype=\"$sourcetype$\" source=\"$risk_rule_source$\""
```

With arguments: ```risk_rule_title_arg,risk_rule_guid_arg,risk_rule_level_arg```


Parse the Risk Rule event generated from the previous macro. This allows building dashboards on it, investigating, etc.
```
| eval risk_rule_fire_time = _time
| fieldformat risk_rule_fire_time = strftime(risk_rule_fire_time,"%Y-%m-%d %H:%M:%S %Z%:z")
| fromjson risk_info
| fields - risk_info, nLogName, nTaskCategory, nType
| sort - _time
```



# Find Newly Observed Events
- This specific example basically says "show me hosts that were not observed in the last 7d."
- Most efficient in larger datasets using lookup tables
```sql
| inputlookup historical_hosts.csv 
| append [ search index=* earliest=-1d@d latest=now | stats count by host ] 
| stats count by host 
| where count=1 
| fields host
```


# Find Newly Observed Risk Rule Events, Split Approach
1. Generate the lookup list
    - a lookup of 30d of events, including first seen, last seen dates, etc.
```sql
index IN ("indexes-*") source="My:Risk" earliest=-30d@d latest=-1d@d
| stats count min(_time) as first_seen max(_time) as last_seen values(risk_rule_title) as risk_rule_title by risk_rule_guid
| outputlookup observed_risk_rules.csv
```


2. Create the Lookup Maintenance Task 
   - A saved search daily job to merge each day's stats with the historical csv
   - Gets stats for the last 24 hours.
   - Appends the existing CSV rows to the search results.
   - The final stats command combines the old rows with the new rows (summing the counts and updating the max timestamp).
   - Overwrites the CSV with the updated, merged data.
   - Schedule daily at 00:30 (30 0 * * *)
```sql
index IN ("indexes-*") source="My:Risk" earliest=-1d@d latest=@d
| stats count as hits min(_time) as first_seen max(_time) as last_seen values(risk_rule_title) as risk_rule_title by risk_rule_guid
| inputlookup append=t observed_risk_rules.csv
| stats sum(hits) as hits min(first_seen) as first_seen max(last_seen) as last_seen values(risk_rule_title) as risk_rule_title by risk_rule_guid
| where last_seen > relative_time(now(), "-30d")
| outputlookup observed_risk_rules.csv
```


3. REPORT VERSION - Create the alert
    - A saved search to alert on newly observed risk rules
    - Aggregates the live data from the last 24 hours. We grab the user and host here so you have context for who triggered the new rule.
    - Checks the CSV. If the GUID exists, it pulls the historic_first_seen timestamp. If the GUID does not exist, this field remains null.
    - Keeps only the rows where the lookup failed to find a match (meaning it's a new rule).
    - "Triggers" for each result
    - "Throttles" and "Suppresses" to ensure it didnt already fire this day.
    - Schedule hourly at minute 5 (5 * * * *)
    - Search Earliest Time = -24h
```sql
index IN ("index-*") source="My:Risk" _index_earliest=-62m@m _index_latest=-2m@m
| stats count as hits_new min(_time) as first_seen_new max(_time) as last_seen_new values(risk_rule_title) as risk_rule_title by risk_rule_guid, risk_rule_user, risk_rule_host, index

``` HISTORY CHECK ```
| lookup index_observed_risk_rules.csv risk_rule_guid OUTPUT first_seen as historic_first_seen
| where isnull(historic_first_seen)

``` THROTTLE ```
| search NOT 
    [ search index IN ("index-*") source="My:Risk:Alert" earliest=-24h
    | fields risk_rule_guid, index
    | dedup risk_rule_guid, index ]

``` MAKE EVENT ```
``` Stash to remove headers```
| map maxsearches=500 search="| makeresults 
    | eval _time=now(), index=\"$index$\", name=\"RIR - Newly Observed Risk Rule\", risk_rule_title=\"$risk_rule_title$\", risk_rule_guid=\"$risk_rule_guid$\", risk_rule_user=\"$risk_rule_user$\", risk_rule_host=\"$risk_rule_host$\", first_seen_time=\"$first_seen_new$\"
    | collect index=\"$index$\" source=\"My:Risk:Alert\" sourcetype=\"stash\""
```


4. ALERT VERSION - Create the Alert
   - IMPORATNT NOTE: You can't specify an index dynamically this way.
   - A saved search to alert on newly observed risk rules
   - Aggregates the live data from the last 24 hours. We grab the user and host here so you have context for who triggered the new rule.
   - Checks the CSV. If the GUID exists, it pulls the historic_first_seen timestamp. If the GUID does not exist, this field remains null.
   - Keeps only the rows where the lookup failed to find a match (meaning it's a new rule).
   - Schedule hourly at minute 5 (5 * * * *)
   - "Triggers" for each result
   - Throttle checked
   - Suppress results containing field value risk_rule_guid
   - Suppress triggering for 24 hours
   - Trigger Action: Log Event
     - Event: ```timestamp=now() original_index="$index$" risk_rule_title="$result.risk_rule_title$" risk_rule_guid="$result.risk_rule_guid$" risk_rule_user="$result.risk_rule_user$" risk_rule_host="$result.risk_rule_host$" first_seen_time="$result.first_seen_new$"```
     - Source: My:Risk:Alert
     - Sourcetype: My:Risk:Alert
     - Host: $result.host$
     - Index: MyIndex
```sql
index IN ("indexes-*") source="My:Risk" _index_earliest=-62m@m _index_latest=-2m@m
| stats count as hits_new min(_time) as first_seen_new max(_time) as last_seen_new values(risk_rule_title) as risk_rule_title by risk_rule_guid, user, host, index
| lookup observed_risk_rules.csv risk_rule_guid OUTPUT first_seen as historic_first_seen
| where isnull(historic_first_seen)
```


5. Force the Alert to Fire
    - Backdates the risk by 3m to get an immedate alert search to trigger
```sql
| makeresults 
| eval _time = relative_time(now(), "-3m")
| eval risk_rule_guid="TEST-REAL-TRIGGER-1555", risk_rule_title="Test Alert Trigger", risk_rule_user="admin_test", risk_rule_host="workstation_test"
| eval _raw = "timestamp=" . _time . " risk_rule_guid=" . risk_rule_guid . " risk_rule_title=\"" . risk_rule_title . "\" risk_rule_user=" . risk_rule_user . " risk_rule_host=" . risk_rule_host
| collect index="index-test" source="My:Risk" sourcetype="My:Risk"
```



# Find Risk_Score Spikes from Hourly Baseline (Single-Tenant Version)
1. The Baseline Generator (Scheduled Report) (consider also making one for the field 'user')
  - Schedule: Daily (e.g., 01:00 AM) Time Range: Last 30 days (-30d@d to -1d@d) Action: Save results to a CSV Lookup.
  - This search handles the heavy JSON parsing and statistical crunching offline.

```sql
index IN ("myindex") source="My:Risk*" earliest=-30d@h latest=-1d@h
``` Parse fields before discarding _raw ```
| rex field=_raw "risk_score=(?<risk_score>\d+)"
| rex field=_raw "risk_rule_host=\"(?<host>[^,]+)\""

``` Pre-aggregate to save memory ```
| bin _time span=1h
| stats sum(risk_score) as raw_hourly_risk by host _time

``` Zero-Filling Logic ```
| timechart span=1h fixedrange=t sum(raw_hourly_risk) as hourly_risk by host limit=0

``` Force empty buckets to 0 ```
``` This ensures quiet hours are counted as '0' rather than 'null' ```
| fillnull value=0

``` Convert matrix back to rows ```
| untable _time host hourly_risk

``` Calculate Median and MAD ```
| eval hour_of_day = strftime(_time, "%H")
| eventstats median(hourly_risk) as median by host hour_of_day
| eval abs_dev = abs(hourly_risk - median)
| stats values(median) as median median(abs_dev) as mad by host hour_of_day

``` Santize with a Safety Floor ```
| fillnull value=0 median mad
| eval mad = if(mad=0, 1, mad)
| outputlookup risk_baseline_hourly_host.csv
```

2. The Detection / Dashboard Widget
  - Schedule: Hourly (e.g., */60 * * * * or specifically at minute 5) Time Range: Last 24 hours
  - This search is incredibly fast because it only processes 60 minutes of data.
  - Earliest = -24h
```sql
index IN ("indexes-*") source="My:Risk*" earliest=-1h@h latest=@h
``` MEMORY OPTIMIZATION: Keep only necessary fields first ```
| fields _raw
| rex field=_raw "risk_score=(?<risk_score>\d+)"
| rex field=_raw "risk_rule_host=\"(?<host>[^,]+)\""

``` Aggregate current risk, grouping by Host ```
| stats sum(risk_score) as current_hourly_risk by host

``` Determine which hour are we looking at? ```
| eval hour_of_day = strftime(relative_time(now(), "-1h@h"), "%H")

``` Lookup baseline match on Host + Hour ```
| lookup risk_baseline_hourly_host.csv host hour_of_day OUTPUT median mad

``` Handle New Hosts or Silent Baselines ```
``` If lookup returns null (no history), default to 0 to force high sensitivity ```
| fillnull value=0 median mad

``` Calculate Z-Score Math with Safety Floors ```
``` percent_difference: (Current - Median) / Median ```
``` robust_z: (Current - Median) / (1.48 * MAD) ```
``` max(x, 1) ensures we NEVER divide by zero ```
| eval percent_difference = round((current_hourly_risk - median) / max(median, 1) * 100, 2)
| eval robust_z = round((current_hourly_risk - median) / (1.4826 * max(mad, 1)), 2)

``` Threshold: Z > 3 (Statistical Outlier) AND Risk > 50 (Material Impact) ```
| where robust_z > 3 AND current_hourly_risk > 50

``` Prettify ```
| table host hour_of_day current_hourly_risk median mad robust_z percent_difference
| sort - robust_z
```

3. Force a Trigger
Create a fake baseline entry
```sql
| makeresults 
| eval host="test-system-01"
| eval hour_of_day=strftime(now(), "%H")
| eval median=10, mad=2
| outputlookup append=t risk_baseline_hourly_host.csv
```

Ensure it exists
```sql
|  inputlookup risk_baseline_hourly_host.csv
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








# Find Risk_Score Spikes from Hourly Baseline (Multi-Tenant Version)
1. The Baseline Generator (Scheduled Report) (consider also making one for the field 'user')
  - Schedule: Daily (e.g., 01:00 AM) Time Range: Last 30 days (-30d@d to -1d@d) Action: Save results to a CSV Lookup.
  - This search handles the heavy JSON parsing and statistical crunching offline.

```sql
index IN ("indexes-*") source="My:Risk*" earliest=-30d@h latest=-1d@h
``` Parse fields before discarding _raw ```
| rex field=_raw "risk_score=(?<risk_score>\d+)"
| rex field=_raw "risk_rule_host=\"(?<host>[^,]+)\""

``` Combine Index and Host as a composite key for Multi-Tenancy ```
``` This ensures Client A's 'HMI-01' is treated differently than Client B's 'HMI-01' ```
| eval composite_key = index . "::" . host

``` Pre-aggregate to save memory ```
``` Group by the composite key and time immediately ```
| bin _time span=1h
| stats sum(risk_score) as raw_hourly_risk by composite_key _time

``` Zero-Filling Logic ```
``` timechart now handles the composite key correctly ```
| timechart span=1h fixedrange=t sum(raw_hourly_risk) as hourly_risk by composite_key limit=0

``` Force empty buckets to 0 ```
| fillnull value=0

``` Convert matrix back to rows ```
| untable _time composite_key hourly_risk

``` Split Index and Host back apart ```
| rex field=composite_key "(?<index>.*?)::(?<host>.*)"

``` Calculate Median and MAD ```
| eval hour_of_day = strftime(_time, "%H")
| eventstats median(hourly_risk) as median by index host hour_of_day
| eval abs_dev = abs(hourly_risk - median)
| stats values(median) as median median(abs_dev) as mad by index host hour_of_day

``` Sanitize with a Safety Floor ```
| fillnull value=0 median mad
| eval mad = if(mad=0, 1, mad)
| outputlookup risk_baseline_hourly_host.csv
```

2. The Detection / Dashboard Widget
  - Schedule: Hourly (e.g., */60 * * * * or specifically at minute 5) Time Range: Last 24 hours
  - This search is incredibly fast because it only processes 60 minutes of data.
  - Earliest = -24h

```sql
index IN ("indexes-*") source="My:Risk*" earliest=-1h@h latest=@h
| fields _raw index
| rex field=_raw "risk_score=(?<risk_score>\d+)"
| rex field=_raw "risk_rule_host=\"(?<host>[^,]+)\""

``` Aggregate current risk, separated by tenant (index) ```
| stats sum(risk_score) as current_hourly_risk by index host

``` Determine CONTEXT: Look at previous full hour of day ```
| eval hour_of_day = strftime(relative_time(now(), "-1h@h"), "%H")

``` Baseline lookup match on index + host + hour to find the correct baseline row ```
| lookup risk_baseline_hourly_host.csv index host hour_of_day OUTPUT median mad

``` Safety net handling new hosts or silent baselines ```
``` If lookup returns null (no history), default to 0 to force high sensitivity ```
| fillnull value=0 median mad

``` Calculate Z-Score Math with Safety Floors ```
``` percent_difference: (Current - Median) / Median ```
``` robust_z: (Current - Median) / (1.48 * MAD) ```
``` max(x, 1) ensures we NEVER divide by zero, preventing calculation errors ```
| eval percent_difference = round((current_hourly_risk - median) / max(median, 1) * 100, 2)
| eval robust_z = round((current_hourly_risk - median) / (1.4826 * max(mad, 1)), 2)

``` Define the Thresholds ```
``` robust_z > 3: The statistical outlier (approx 3 standard deviations) ```
``` risk > 50: The operational noise floor (ignore tiny blips) ```
| where robust_z > 3 AND current_hourly_risk > 50

``` Prettify ```
| table index host hour_of_day current_hourly_risk median mad robust_z percent_difference
| sort - robust_z
```

3. Force a Trigger
Create a fake baseline entry
```sql
| makeresults 
| eval index="index-test"
| eval host="test-system-01"
| eval hour_of_day=strftime(now(), "%H")
| eval median=10, mad=2
| outputlookup append=t risk_baseline_hourly_host.csv
```

Ensure it exists
```sql
|  inputlookup risk_baseline_hourly_host.csv
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