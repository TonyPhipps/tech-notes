# After Updating an App, Force reload of savedsearches.conf 
... without restarting the entire search Head
- ```https://<splunk_server>:<management_port>/servicesNS/<user>/<app>/saved/searches/_reload```
- ```http(s)://<splunk_server>:8000/debug/refresh```


# Generate Risk Rule Events in Original Index
Create a macro named something like 'risk-rule'. Add that macro to the end of a saved search
```sql
yoursearch
| `risk-rule("RR - The Alert Name", "the-alert-guid", "the-alert-severity-level")`
```
Arguments: risk_rule_title,risk_rule_guid,risk_rule_level
Definition:
```sql
fields - punct, cribl_*, date_hour, date_mday, date_minute, date_month, date_second, date_wday, date_year, date_zone, linecount, timeendpos, timestartpos, _bkt, _cd, _serial, _si, _pre_msg, _sourcetype, _subsecond, ForwardedRaw, snare_DataString, message, Message, body
| eval risk_info_time = _time
| fields - _time
| tojson include_internal=true output_field=risk_info auto(*) 
| eval risk_rule_title = "$risk_rule_title_arg$"
| eval risk_rule_guid = "$risk_rule_guid_arg$"
| eval risk_rule_level = "$risk_rule_level_arg$"
| eval risk_info_sourcetype = sourcetype
| eval risk_info_source = source
| eval risk_rule_source = "My:Risk"
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
| foreach src_user,dst_user,user,User,Account_Name,src_host,dst_host,host,ComputerName,dest,dvc,dvc_nt_host,src,src_ip
    [ eval <<FIELD>> = if (trim(<<FIELD>>) IN ("","-","NOT_TRANSLATED"), null(), <<FIELD>>) ]

``` IP or strip FQDN```
| foreach src_host,dst_host,host,ComputerName,dest,dvc,dvc_nt_host,src,src_ip
[ rex field=<<FIELD>> "^(?i)(?<<<FIELD>>>(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})|[^\.]+)"] 

| eval risk_rule_host= upper(coalesce(src_host,ComputerName,host))
| eval risk_object_string = mvappend(src_user,dst_user,user,User,Account_Name)

```Strip domains from each user field```
| eval risk_object_string = mvmap(risk_object_string, replace(risk_object_string,"(?:.+\\\)?([^@]+)(?:@[\w\.-]+)?","\1"))

```Append risk_object_type to each user field value. Computer account risk is added to host risk, so they are combined here as a single risk_object.```
| eval risk_object_string = mvmap(risk_object_string, case(
    risk_object_string IN ("SYSTEM", "NETWORK SERVICE", "LOCAL SERVICE"), lower(risk_object_string  . "@" . risk_rule_host . "|user"),
    match(risk_object_string,"(?i)(svc)|(service)|(msa)"), lower(risk_object_string  . "|user"),
    match(risk_object_string,"\$$"), (rtrim(upper(risk_object_string),"$") . "|host"),
    1==1, lower(risk_object_string . "|user")
    ) 
)

| eval host_risk_objects = mvappend(src_host, dst_host, host, ComputerName, dest, dvc, dvc_nt_host, src, src_ip)
| eval host_risk_objects = mvmap(host_risk_objects , host_risk_objects . "|host")
| eval risk_object_string = mvappend(risk_object_string, host_risk_objects )

| eval risk_object_string = mvdedup(risk_object_string)
| eval risk_object_string = if(isnull(risk_object_string), "-",risk_object_string)
| eval risk_object_string = mvjoin(risk_object_string,";")

| table _time, index, risk_rule_source, sourcetype, risk_rule_title, risk_rule_guid, risk_rule_level, risk_score, risk_rule_host, risk_object_string, risk_info_source, risk_info_sourcetype, risk_info_time, risk_info
| map maxsearches=5000 search=" | makeresults | eval _time=$_time$, risk_rule_title=\"$risk_rule_title$\", risk_rule_guid=\"$risk_rule_guid$\", risk_rule_level=\"$risk_rule_level$\", risk_score=\"$risk_score$\", risk_rule_host=\"$risk_rule_host$\", risk_object_string=\"$risk_object_string$\", risk_info_source=\"$risk_info_source$\", risk_info_sourcetype=\"$risk_info_sourcetype$\", risk_info_time=\"$risk_info_time$\", risk_info=\"$risk_info$\" | collect index=$index$ sourcetype=\"My:Risk\" source=\"$risk_rule_source$\" host=\"$risk_rule_host$\""
```

With arguments: ```risk_rule_title_arg,risk_rule_guid_arg,risk_rule_level_arg```


Parse the Risk Rule event generated from the previous macro. This allows building dashboards on it, investigating, etc.
```sql
| eval risk_rule_fire_time = _time
| eval risk_object_string = split(risk_object_string, ";")
| fieldformat risk_rule_fire_time = strftime(risk_rule_fire_time,"%Y-%m-%d %H:%M:%S %Z%:z")
| fromjson risk_info
| fields - risk_info, nLogName, nTaskCategory, nType, nOpCode
```
