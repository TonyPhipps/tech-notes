# Splunk

## Discovery
List indices available
```
| eventcount summarize=false index=* | fields index | dedup index
```

List sourcetypes available
```
index=something | fields sourcetype | chart count by sourcetype
```

## Ingestion

Review the settings for a conf file and see where the settings are merged from
```
splunk btool inputs list --debug
```

## Search Quick Reference

### To Lower or Upper
To clean up some results, you may want to force lower (or upper) casing.
```
| eval hostL=lower(host)
```
or
```
| eval hostU=upper(host)
```

### Fill Null
For the current search results, fill all empty field values:

```
... | fillnull
```

For the current search results, fill all empty field values with the string "NULL":

```
... | fillnull value=NULL
```

Fill all empty field values in the "host" and "kbps" fields with the string "unknown" by adding the fillnull command to your search:

```
... | fillnull value=unknown host kbps
```
Note: sometimes specifying the fields is necessary (lack of field listing wont work on any null fields). Unknown if this is tied to a setting.

https://docs.splunk.com/Documentation/SplunkCloud/8.2.2105/SearchReference/Fillnull

### Find Events Without a Specific Field/Column

Use NOT fieldname=*

```
index="windows" sourcetype=WinEventLog:Security EventCode=4624 NOT Message=*
```

### fieldformat vs eval
- FieldFormat only modifies the display of the value. Useful to maintain sorting by numbers/currency

### Dedup
Removes duplicate fields

### geom
Creates choropleth map visualizations

### Determine String Length
```
| eval PathLength=len(Path)
```

### Sort Results
```
| sort + PathLength
```

### Aggregate Results
```
| stats count by Path, CommandLine, PathLength, CommandLineLength
```

### Make a LowerCase version of a Field
```
| eval CommandLineLower=lower(CommandLine)
```

### Exclude a list of items
```
Type=Error NOT [ inputlookup safecodes.csv | return 10000 EventCode ]
```

### Determine Standard Deviation
```	
index="processes"
	| eval cmdlen=len(CommandLine) 
	| eventstats stdev(cmdlen) as stdev,avg(cmdlen) as avg by Computer
	| stats max(cmdlen) as maxlen, values(stdev) as stdevperhost, values(avg) as avgperhost by Computer,CommandLine 
  | where maxlen>4*stdevperhost+avgperhost
```

### Identify High Entropy Occurrences
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

### Determine Levenshtein Scores
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

### List contents of a lookup
```
| inputlookup mylookup
```

### Update a Lookup
Lookup list files do not allow updating by default - manual recreation is required. Or... install Lookup List Editor
- https://apps.splunk.com/apps/id/lookup_editor
  - Navigate to Apps > Lookup Editor
  - Find and edit the lookup
  - Edit existing entries or...
  - Import a new or updated version to merge with the selected lookup list

### Use a Lookup to Compare More than One Field
```
index=*
| search ([| inputlookup ioc_ip.csv | fields IP | rename IP as dest_ip] OR [| inputlookup ioc_ip.csv | fields IP | rename IP as src_ip])
```

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


## Larger Search Examples
### For Each Source IP Show Statistics Per Destination IP

```
... 
| stats values(dest_ip) dc(dest_ip) as UniqueDestinations by src_ip
| where UniqueDestinations >= 10
 ```
 
 ###  Given one search, get additional fields from another search based on a matching field
 
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
