# After Updating an App, Force reload of savedsearches.conf 
... without restarting the entire search Head
- ```https://<splunk_server>:<management_port>/servicesNS/<user>/<app>/saved/searches/_reload```
- ```http(s)://<splunk_server>:8000/debug/refresh```


# Generate Risk Rule Events in Orignial Index
Create a macro named something like 'risk-rule'. Add that macro to the end of a saved search
```sql
yoursearch
| `risk-rule("RR - The Alert Name", "the-alert-guid", "the-alert-severity-level")`
```
Arguments: risk_rule_title,risk_rule_guid,risk_rule_level
Definition:
```sql
fields - punct, cribl_*, date_hour, date_mday, date_minute, date_month, date_second, date_wday, date_year, date_zone, linecount, timeendpos, timestartpos, _bkt, _cd, _serial, _si, _pre_msg, _sourcetype, _subsecond, ForwardedRaw, snare_DataString, message, Message, body

| tojson include_internal=true output_field=risk_info auto(*) 
| eval risk_rule_title = "$risk_rule_title_arg$"
| eval risk_rule_guid = "$risk_rule_guid_arg$"
| eval risk_rule_level = "$risk_rule_level_arg$"
| eval risk_info_time = _time
| eval risk_info_sourcetype = sourcetype
| eval risk_info_source = source
| eval sourcetype="My:Risk"
| eval risk_rule_source= case( 
    match(risk_rule_title,"^RR -"), "My:Risk:Internal",
    match(risk_rule_title,"^RR -"), "My:Risk:Sigma",
    1==1, "My:Risk"
)
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

| eval host = if(risk_info_sourcetype="forescout*", coalesce(srcHostName, host), host)
| eval host_coalesce = coalesce(src_host,dst_host,host)
| rex field=host_coalesce "^(?i)(?<risk_rule_host>(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})|[^\.]+)" 
| eval risk_rule_host = upper(risk_rule_host) 

| eval User = if(User IN ("NOT_TRANSLATED","-"), null(), User)
| eval user = if(user IN ("NOT_TRANSLATED","-"), null(), user)
| eval Account_Name = if(like(Account_Name, "%$"), null(), Account_Name)
| eval user_coalesce = coalesce(src_user,dst_user,user,User,Account_Name, "-")
| rex field=user_coalesce "(.+\\\)?(?<risk_rule_user>[^@]+)(@[\w\.-]+)?" 
| eval risk_rule_user=case(
    risk_rule_user="SYSTEM" OR risk_rule_user="NETWORK SERVICE", lower(risk_rule_host."$"),
    1==1, lower(risk_rule_user)
) 

| table _time, index, risk_rule_source, sourcetype, risk_rule_title, risk_rule_guid, risk_rule_level, risk_score, risk_rule_host, risk_rule_user, risk_info_source, risk_info_sourcetype, risk_info_time, risk_info
| map maxsearches=5000 search=" | makeresults | eval _time=$_time$, risk_rule_title=\"$risk_rule_title$\", risk_rule_guid=\"$risk_rule_guid$\",  risk_rule_level=\"$risk_rule_level$\", risk_score=\"$risk_score$\", risk_rule_host=\"$risk_rule_host$\", risk_rule_user=\"$risk_rule_user$\", risk_info_source=\"$risk_info_source$\", risk_info_sourcetype=\"$risk_info_sourcetype$\", risk_info_time=\"$risk_info_time$\", risk_info=\"$risk_info$\" | collect index=$index$ sourcetype=\"$sourcetype$\" source=\"$risk_rule_source$\""
```

With arguments: ```risk_rule_title_arg,risk_rule_guid_arg,risk_rule_level_arg```


Parse the Risk Rule event generated from the previous macro. This allows building dashboards on it, investigating, etc.
```sql
| eval risk_rule_fire_time = _time
| fieldformat risk_rule_fire_time = strftime(risk_rule_fire_time,"%Y-%m-%d %H:%M:%S %Z%:z")
| fromjson risk_info
| fields - risk_info, nLogName, nTaskCategory, nType
| sort - _time
```
