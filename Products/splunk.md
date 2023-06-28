# Splunk

## Discovery
List indices available
```
| eventcount summarize=false index=* | fields index | dedup index
```

List sourcetypes available
```
index=something | fields index,sourcetype | stats count by index,sourcetype
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
| Extract Fields via Rex (regex). Use of greedy wildcards (\*) starts and ends at newlines              | `\| rex field=fieldname "regex(?<newfieldname>regex)"`                                                                                             |
| Sort Results                                                                                          | `\| sort + PathLength`                                                                                                                             |
| Aggregate Results                                                                                     | `\| stats count by Path, CommandLine, PathLength, CommandLineLength`                                                                               |
| Exclude a list of items                                                                               | ` Type=Error NOT [ inputlookup safecodes.csv \| return 10000 EventCode ]`                                                                          |
| List contents of a lookup                                                                             | `\| inputlookup mylookup`                                                                                                                          |
| Determine if the contents of a field are in a lookup                                                  | `\| search ([\| inputlookup ioc_ip.csv \| fields IP \| rename IP as dest_ip]`                                                                      |
| Determine if the contents of one of two fields are in a lookup                                        | `\| search ([\| inputlookup ioc_ip.csv \| fields IP \| rename IP as dest_ip] OR [ \| inputlookup ioc_ip.csv \| fields IP \| rename IP as src_ip])` |
| Convert numbers to date                                                                               | `\| convert ctime(DateField)`                                                                                                                      |
| Search for a list of values in one field                                                              | `Logon_Type IN (2,10,11,12,13)`                                                                                                                    |
| Merge multiple column names into one                                                                  | `\| eval SerialNumber=coalesce(SerialNumber,EnclosureSerialNumber)`                                                                                |
| Replace one backslash with two                                                                        | `\| eval Path=replace(Path, "\\\\", "\\\\\\")`                                                                                                     |

## Rex
Test your regex on fake events
```
| makeresults
| eval _raw="your fake event"
| rex = "your rex"
```

## Search Use Cases

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

## Rex Magic

### Derive the Application Logs within Linux:Messages

<details>

```
index=ics-cpn-cbp-scada sourcetype="linux:messages"
| rex field=_raw "^(<\d+>\s)?[^\s]+\s+[^\s]+\s+[^\s]+\s+[^\s]+\s(?<application>[^\d][^\s]+?)[\s:|\(|\[]"
| chart count by application
```

</details>
