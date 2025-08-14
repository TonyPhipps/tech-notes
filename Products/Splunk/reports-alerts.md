# Force reload of savedsearches.conf After Updating
... without restarting the entire search Head
- ```https://<splunk_server>:<management_port>/servicesNS/<user>/<app>/saved/searches/_reload```
- ```http(s)://<splunk_server>:8000/debug/refresh```


# Generate Alert Events in Orignial Index
Create a macro named something like 'risk-rule'. Add that macro to the end of a saved search
```
yoursearch
| `risk-rule("RR - The Alert Name", "the-alert-guid", "the-alert-severity")`
```
Arguments: risk_rule_title,risk_rule_guid,risk_rule_level
Definition:
```
fields - punct, cribl_*, date_hour, date_mday, date_minute, date_month, date_second, date_wday, date_year, date_zone, linecount, timeendpos, timestartpos, _bkt, _cd, _serial, _si, _pre_msg, _sourcetype, _subsecond 
| tojson include_internal=true output_field=risk_info auto(*) 
| eval risk_rule_title = $arg1$
| eval risk_rule_guid = $arg2$ 
| eval risk_rule_level = $arg3$
| eval sourcetype="Risk"
| eval risk_rule_source="Risk"
| table _time, index, risk_rule_source, sourcetype, risk_rule_title, risk_rule_guid, risk_rule_level, risk_info
| map search=" | makeresults | eval _time=$_time$, risk_rule_title=\"$risk_rule_title$\", risk_rule_guid=\"$risk_rule_guid$\", risk_rule_level=\"$risk_rule_level$\", risk_info=\"$risk_info$\" | collect index=$index$ sourcetype=\"$sourcetype$\" source=\"$risk_rule_source$\""
```

Read the Risk event generated from the previous macro:
```
fromjson risk_info
| fields - risk_info, nLogName, nTaskCategory, nType
```