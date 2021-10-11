# Splunk

## Search

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

