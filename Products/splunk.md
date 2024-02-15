# Splunk

## Saved Alert Guidance
- Use Alert Type: Scheduled whenever possible to preserve resources. Set time frame to the largest acceptable window.
- Set an Expires time that is 2-3 times how long the search should take for the given time frame (defined by schedule)
- The "Suppress results with field value" field accepts comma-delimited lists of multiple items.


## Discovery
List indices available
```
| eventcount summarize=false index=* | fields index | dedup index
```

List sourcetypes available
```
index=something | fields index,sourcetype | stats count by index,sourcetype
```

## Ingestion Stats
```
index=_internal source=*license_usage.log* type=Usage idx=yourindex
| eval GB=b/1024/1024/1024 
| stats sum(GB) by idx, st 
| rename idx as index, st as sourcetype
```

## Search Quick Reference

| Goal                                                                                                  | Example                                                                                                                                            |
| ----------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| To Lower                                                                                              | `\| eval hostL=lower(host)`                                                                                                                        |
| To Upper                                                                                              | `\| eval hostU=upper(host)`                                                                                                                        |
| Fill Null values with empty string                                                                    | `\| fillnull value=NULL`                                                                                                                           |
| Fill all empty field values in the "host" and "kbps" fields with the string "unknown"                 | `\| fillnull value=unknown host kbps`                                                                                                              |
| Include Events with or Without a Specific Field/Column (This may be needed if fillnull did not work.) | `\| eval field1=if(isnull(field1),"missing",field1))`                                                                                              |
| Find Events Without a Specific Field/Column                                                           | `... NOT Message=*`                                                                                                                                |
| Change the value as displayed, but not in data. Useful to maintain sorting by numbers/currency.       | `\| fieldformat "First Event"=strftime('First Event', "%c")`                                                                                       |
| Remove duplicate fields                                                                               | `... \| dedup host`                                                                                                                                |
| Createa choropleth map visualizations                                                                 | `geom`                                                                                                                                             |
| Determine String Length                                                                               | `\| eval PathLength=len(Path)`                                                                                                                     |
| Extract Fields via Rex (regex). Use of greedy wildcards (\*) starts and ends at newlines              | `\| rex field=sourcefieldname "(?<newfieldname>regex)"`                                                                                            |
| Extract Fields via Rex (regex) using a switch/case scenario                                           | `\| eval NewFileName = case(match(host, "192.168.1.1"), "Router", match(host, "192.168.1.2"), "Server", 1=1, "Other")`                             |
| Sort Results                                                                                          | `\| sort + PathLength`                                                                                                                             |
| Aggregate Results                                                                                     | `\| stats count by Path, CommandLine, PathLength, CommandLineLength`                                                                               |
| Aggregate Results by specific fields - show a list of values for those fields across events           | `\|  stats values(Share_Permissions) as Share_Permissions by host, Name, Path`                                                                     |
| Exclude a list of items                                                                               | ` Type=Error NOT [ inputlookup safecodes.csv \| return 10000 EventCode ]`                                                                          |
| List contents of a lookup                                                                             | `\| inputlookup mylookup`                                                                                                                          |
| Determine if the contents of a field are in a lookup                                                  | `\| search ([\| inputlookup ioc_ip.csv \| fields IP \| rename IP as dest_ip]`                                                                      |
| Determine if the contents of one of two fields are in a lookup                                        | `\| search ([\| inputlookup ioc_ip.csv \| fields IP \| rename IP as dest_ip] OR [ \| inputlookup ioc_ip.csv \| fields IP \| rename IP as src_ip])` |
| Convert numbers to date                                                                               | `\| convert ctime(DateField)`                                                                                                                      |
| Search for a list of values in one field                                                              | `Logon_Type IN (2,10,11,12,13)`                                                                                                                    |
| Merge multiple column names into one                                                                  | `\| eval SerialNumber=coalesce(SerialNumber,EnclosureSerialNumber)`                                                                                |
| Replace one backslash with two                                                                        | `\| eval Path=replace(Path, "\\\\", "\\\\\\")`                                                                                                     |
| Show first and last times                                                                             | `\| stats min(_time) as firstTime max(_time) as lastTime \| convert timeformat="%F %T %Z" ctime(firstTime), ctime(lastTime)`                       |
| Days since Date                                                                                       | `\| eval DateParsed=strptime('DateScanned', "%Y-%m-%d %H:%M:%SZ") \| eval DaysSince = round((now()-DateParsed)/86400)`                             |


System Searches
| Goal                      | Example                                                                                                                                                                                                                                                                                                                                                                                                                           |
| ------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Review Triggered Alerts   | `index=_audit action="alert_fired"`                                                                                                                                                                                                                                                                                                                                                                                               |
| Review Notables           | `index=notable`                                                                                                                                                                                                                                                                                                                                                                                                                   |
| Export all Saved Searches | `\| rest /servicesNS/-/-/saved/searches \| search eai:acl.app="*" \| table title description disabled is_scheduled search cron_schedule actions action.email action.email.to action.email.message.alert alert.expires alert.severity alert.suppress alert.suppress.period alert_comparator alert_condition alert_threshold alert_type allow_skew display.events.fields eai:acl.sharing eai:acl.perms.read eai:acl.perms.write id` |
| Investigate Parse Issues  | `index=_internal log_level="ERROR" source="*keyword*"`                                                                                                                                                                                                                                                                                                                                                                            |





















## Lookups

### Upload a Lookup
- Navigate to the App that will use the lookup
- Navigate to Settings > Lookups
- Lookup Table Files > + Add New
  - Select Destination App
  - Locate the File
  - Provide a CSV and name (with file extension .csv)
- Navigate to Settings > Lookups
- Lookup Definitions > + Add New
  - Select Destination App
  - Provide a name (typically matches the csv name without extension .csv)
  - Save


### Update a Lookup
Lookup list files do not allow updating by default - manual recreation is required. Or... install Lookup List Editor
- https://apps.splunk.com/apps/id/lookup_editor
  - Navigate to Apps > Lookup Editor
  - Find and edit the lookup
  - Edit existing entries or...
  - Import a new or updated version to merge with the selected lookup list


















## Macro
Settings > Advanced Search > Search Macros > Add New
- Allows storing a search string that can be referenced later using the macro name.
- Can add arguments, which allows passing data into the macro search.
  - Can use validation checks on arguments
- Called using `macroname`


## Workflow Actions
Settings > Fields > Workflow Actions > Add New
- Get/Post to pass information to external sources, or back to Splunk to perform secondary search
- For example, a link that opens a browser to a WHOIS page, automatically looking up a given IP Address based on the src_ip field content via $src_ip$.


## Data Models
Settings > Data Models > New Data Model
- Events, Searchs, Transactions
- Allows mass normalization and subsequent correlation searches/reports/alerts
- Allows more efficient reporting when used with Pivots
- Root event/object > child object > childobject****
- Root Search should be avoided, as they do not benefit from search speedup


## Key Data Feed Alert

Check the latest 7 days for logs, then review the last one day. If a log source has missing logs for an entire day, recent will equal zero and is worth firing an alert to the administrator.
```
| tstats latest(_time) as latest where index=* earliest=-7d by sourcetype, index
| eval recent = if(latest > relative_time(now(),"-1d"),1,0)
| eval latest = strftime(latest,"%c")
| where recent = 0
| table index sourcetype latest recent
```

## List All Saved Searches
```
| rest /servicesNS/-/-/saved/searches 
| search eai:acl.app="*yourapp*"
| table title description disabled is_scheduled search cron_schedule actions action.email action.email.to action.email.message.alert alert.expires alert.severity alert.suppress alert.suppress.period alert_comparator alert_condition alert_threshold alert_type allow_skew display.events.fields eai:acl.sharing eai:acl.perms.read eai:acl.perms.write id
```

## Rex Magic

### Derive the Application Logs within Linux:Messages

<details>

```
index=ics-cpn-cbp-scada sourcetype="linux:messages"
| rex field=_raw "^(<\d+>\s)?[^\s]+\s+[^\s]+\s+[^\s]+\s+[^\s]+\s(?<application>[^\d][^\s]+?)[\s:|\(|\[]"
| chart count by application
```

</details>

### Rex
Test your regex on fake events
```
| makeresults
| eval _raw="your fake event"
| rex = "your rex"
```

































## Search Use Cases

###
Change a field's value based on its own contents
```
| eval sourcetype=case(
  match(sourcetype, ".*Win.*"),"Windows", 
  match(sourcetype, ".*mongod.*"),"mongod", 
  match(sourcetype, ".*cisco.*"),"Cisco",
  match(sourcetype, ".*pan\:.*"),"Panorama",
  match(sourcetype, ".*linux\:.*"),"Linux",
  match(sourcetype, ".*syslog.*"),"syslog",
  match(sourcetype, "Perfmon.*"),"perfmon",
  match(sourcetype, "Watchguard:.*"),"Watchguard",
  match(sourcetype, "forescout.*"),"ForeScout",
  match(sourcetype, ".*splunk.*"),"Splunk",
  1=1, sourcetype
)
```

### Determine Standard Deviation
<details>
	
```	
index="processes"
	| eval cmdlen=len(CommandLine) 
	| eventstats stdev(cmdlen) as stdev,avg(cmdlen) as avg by Computer
	| stats max(cmdlen) as maxlen, values(stdev) as stdevperhost, values(avg) as avgperhost by Computer,CommandLine 
  | where maxlen>4*stdevperhost+avgperhost
```
</details>	

### Identify High Entropy Occurrences
<details>

```
index="processes" Computer=$asset$ UserName=$user$ (ProcessName=$keyword$ OR Path=$keyword$ OR CommandLine=$keyword$ OR MainModule=$keyword$) 
	| eval PathL= lower(Path)
	| rex field=PathL "^(?<filepath>.*\\\)(?<filename>[^\\\]+)"
	| search filepath!=*windowsapps*
	| lookup ut_shannon_lookup word as PathL
	| eval entropy=round(ut_shannon,6)
	| stats count by entropy, filepath, filename
	| where entropy > 4.5
  | sort - entropy
```
</details>	
	
### Determine Levenshtein Scores
<details>

```
index="processes" Path=*\System\* 
	| rex field=Path "(?<filename>[^\\\\/]*$)" 
	| stats values(Computer) as hosts dc(Computer) as num_hosts values(Path) as Images by filename 
	| eval levenshtein_scores="" 
	| eval comparisonterm="svchost.exe" | lookup ut_levenshtein_lookup word1 as filename, word2 as comparisonterm | eval levenshtein_scores=mvappend(levenshtein_scores, ut_levenshtein) | eval score{ut_levenshtein} = comparisonterm 
	| eval comparisonterm="iexplore.exe" | lookup ut_levenshtein_lookup word1 as filename, word2 as comparisonterm | eval levenshtein_scores=mvappend(levenshtein_scores, ut_levenshtein) | eval score{ut_levenshtein} = comparisonterm 
	| eval comparisonterm="ipconfig.exe" | lookup ut_levenshtein_lookup word1 as filename, word2 as comparisonterm | eval levenshtein_scores=mvappend(levenshtein_scores, ut_levenshtein) | eval score{ut_levenshtein} = comparisonterm 
	| eval comparisonterm="explorer.exe" | lookup ut_levenshtein_lookup word1 as filename, word2 as comparisonterm | eval levenshtein_scores=mvappend(levenshtein_scores, ut_levenshtein)  | eval score{ut_levenshtein} = comparisonterm 
	| eventstats max(num_hosts) as max_num_hosts | where isnull(mvfilter(levenshtein_scores="0")) AND min(levenshtein_scores) <3 | eval lowest_levenshtein_score=min(levenshtein_scores) 
	| eval suspect_files = "" | foreach score* [eval temp = "<<FIELD>>" 
	| rex field=temp "(?<num>\d*)$" 
	| eval suspect_files=if(num<3,mvappend('<<FIELD>>', suspect_files),suspect_files) 
	| fields - temp "<<FIELD>>"] 
	| eval percentage_of_hosts_affected = round(100*num_hosts/max_num_hosts,2) 
  | fields filename lowest_levenshtein_score suspect_files Images num_hosts percentage_of_hosts_affected
```
</details>
	
### For Each Source IP Show Statistics Per Destination IP
<details>

```
... 
| stats values(dest_ip) dc(dest_ip) as UniqueDestinations by src_ip
| where UniqueDestinations >= 10
 ```
 </details>

 ###  Given one search, get additional fields from another search based on a matching field
<details>
 
 ```
 index="windows" host="*" ip="*" 
| stats count by host, ip
| join type=inner left=L right=R where L.ip = R.src_ip
    [ search index="switch"
    | fields src_ip, mac]
```

OR do the same, but with multiple expected matches/results
```
index="windows" d_host="*" ip="*" 
| stats count by d_host, ip
| join type=inner left=L right=R where L.ip = R.src_ip
[ search index"firewall" | stats values(dest_ip) by src_ip]
```
</details>

### List Only Last Occurring Events by Another_Field

<details>

```
index="windows" cribl=yes sourcetype=WinEventLog:Security EventCode=4624 Logon_Type IN (2,10,11,12,13)
| stats max(_time) AS Last_Login BY Account_Name
| search NOT Account_Name IN ("*$", DWM-*, UMFD-*)
| convert ctime(Last_Login)	
```	
</details>


### Using Foreach for Evals
If you have multiple eval statements, it may be worth using a foreach to apply the same formula to multiple fields. This can signficantly reduce code repetition in your search string.

The exmaple below will check if a list of fields exist, and if not, make the field with the value "missing"

```
| foreach field1 field2 field3 field4 [ eval <<FIELD>> = if (isnull(trim(<<FIELD>>)) OR trim(<<FIELD>>)="", "Missing", <<FIELD>>) ]

```


### Get the Latest Only
Some data, like from a vulnerability scanner, polls for the same data, but you may only want to see the latest results.

```
| stats latest(_time) as _time, values(field1) as field1, values(field2) as field2, by host
```

Version 2
```
| eventstats max(_time) as latest by host
| where _time=latest
```

### Find Newly Observed Events
This specific example basically says "show me EventCodes that were not observed in the last 6h.
```
source=WinEventLog:System NOT ([| search source=WinEventLog:System earliest=-6h | table EventCode]) | stats count by EventCode
```

or with tstats (when only dealing with indexed fields or data models)

```
| tstats latest(_time) as latest where earliest=-1d index=something sourcetype=this NOT ( 
    [| tstats latest(_time) where index=something sourcetype=this earliest=-7d latest=-1d by index, host 
    | table index, host]) by index, host 
| eval latest_str = strftime(latest,"%c")
| table host, index, latest, latest_str
```

### Find Results Not in a Subsearch of Older Events
This example looks for all instances across many systems, but shows the host info on outliers. Also ensures "new systems" found don't false positive.

```
index="something" therestofyoursearch
| stats count by _time, host, field1, field2
| fields - count 
| search 
    [ search index="something" therestofyoursearch earliest=-7d latest=-1d 
    | stats count by host
    | fields - count
        ]
| search NOT
    [ search index="something" therestofyoursearch earliest=-7d latest=-1d 
    | stats count by 'field1'
    | fields - count
        ]
```


### Find Unique Events
```
index="something"
| eventstats max(_time) as last_seen min(_time) as first_seen by host, ProcessName
| convert timeformat="%F %T %Z" ctime(first_seen), ctime(last_seen)
|  where last_seen == first_seen
```

### Find Latest Logon Date Among Accounts Appearing on Multiple DC's

- Two date fields are lastLogon and LastLogonDate
- The same account may have different values for these two fields, and may different from DC to DC.

```
| eval strlastLogon = strptime(lastLogon, "%m/%d/%Y %H:%M:%S %P")
| eval strLastLogonDate = strptime(LastLogonDate, "%m/%d/%Y %H:%M:%S %P")
| eval LatestLogonDate = case(strlastLogon >= strLastLogonDate, lastLogon, strlastLogon < strLastLogonDate, LastLogonDate)
| eval DaysSince= ""
| eval strLatestLogonDate = strptime(LatestLogonDate, "%m/%d/%Y %H:%M:%S %P")
| stats max(LatestLogonDate) as LatestLogonDate values(host) as DomainControllers count by Name, Enabled, DaysSince
| eval DaysSince=round((now()-strptime(LatestLogonDate, "%m/%d/%Y %H:%M:%S %P"))/86400,0)
| where DaysSince >= 30
| fields - count, DomainControllers
| sort - DaysSince
```

## Multivalue Fields
Some fields are loaded with multiple values. For example, a Members field may contain a list of members, separated by a delimeter of ";" (semicolon).

Jim; Sally; Bob

```
| makemv delim=; Members
```