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
index IN ("indexes-*") source="index:Risk" earliest=-30d@d latest=-1d@d
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
index IN ("indexes-*") source="index:Risk" earliest=-1d@d latest=@d
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
```sql
index IN ("indexes-*") source="index:Risk" _index_earliest=-62m@m _index_latest=-2m@m
| stats count as hits_new min(_time) as first_seen_new max(_time) as last_seen_new values(risk_rule_title) as risk_rule_title by risk_rule_guid, user, host, index

``` HISTORY CHECK ```
| lookup observed_risk_rules.csv risk_rule_guid OUTPUT first_seen as historic_first_seen
| where isnull(historic_first_seen)

``` THROTTLE ```
| search NOT 
    [ search index IN ("indexes-*") source="index:Risk:Alert" earliest=-24h
    | fields risk_rule_guid, index
    | dedup risk_rule_guid, index ]

``` MAKE EVENT ```
``` Stash to remove headers```
| map maxsearches=50 search="| makeresults 
    | eval _time=now(), index=\"$index$\", risk_rule_title=\"$risk_rule_title$\", risk_rule_guid=\"$risk_rule_guid$\", user=\"$user$\", host=\"$host$\", first_seen_time=\"$first_seen_new$\"
    | collect index=\"$index$\" source=\"index:Risk:Alert\" sourcetype=\"stash\""
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
     - Event: ```timestamp=now() original_index="$index$" risk_rule_title="$result.risk_rule_title$" risk_rule_guid="$result.risk_rule_guid$" user="$result.user$" host="$result.host$" first_seen_time="$result.first_seen_new$"```
     - Source: index:Risk:Alert
     - Sourcetype: index:Risk:Alert
     - Host: $result.host$
     - Index: MyIndex
```sql
index IN ("indexes-*") source="index:Risk" _index_earliest=-62m@m _index_latest=-2m@m
| stats count as hits_new min(_time) as first_seen_new max(_time) as last_seen_new values(risk_rule_title) as risk_rule_title by risk_rule_guid, user, host, index
| lookup observed_risk_rules.csv risk_rule_guid OUTPUT first_seen as historic_first_seen
| where isnull(historic_first_seen)
```


5. Force the Alert to Fire
    - Backdates the risk by 1h to show that the next alert would trigger
```sql
| makeresults 
| eval _time = relative_time(now(), "-1h")
| eval risk_rule_guid="TEST-REAL-TRIGGER-001", risk_rule_title="Test Alert Trigger", user="admin_test", host="workstation_test"
| eval _raw = "timestamp=" . _time . " risk_rule_guid=" . risk_rule_guid . " risk_rule_title=\"" . risk_rule_title . "\" user=" . user . " host=" . host
| collect index="index-1" source="index:Risk" sourcetype="risk:test"
```