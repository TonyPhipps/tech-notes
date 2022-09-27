# Splunk

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

### fieldformat vs eval
- FieldFormat only modifies the display of the value. Useful to maintain sorting by numbers/currency

### Dedup
Removes duplicate fields

### geom
Creates choropleth map visualizations

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


## CIM
- Has to be installed on a vanilla install
- Use Aliases to map an original field to normalized CIM fields (e.g. src_ip)



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
