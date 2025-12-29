# Review a Lookup Table
```sql
| inputlookup mylookup
```


# Determine if the contents of a field are in a lookup
Note: I have found it more helpful to rename the fields from the INPUTLOOKUP rather than the search, as this approach avoids editing the active search fields with this exclusion is placed where it's needed in the larger saerch.

- Where the inputlookup has a field named dest_ip and the search has a field named IP

```sql
[| inputlookup ioc_ip.csv | fields IP | rename dest_ip as IP ]
```


# Save Output to a Lookup
Create initial lookup table in user context to allow permissions to be set
```sql
 | outputlookup "your_lookup.csv" create_context=user
```

A saved search can then be created with this at the end, which will overwrite the lookup when the search executes on a schedule.
```sql
| `output_adb_lookup("your_lookup.csv")`
```


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


# Create a Trusted Networks List to Filter Out Events
- Upload Lookup File
  - index, subnet, subnet_label, subnet_description
    - some-Index-name, 192.168.1.0/24, Some Label, Some Description
- Create Lookup Definition
  - Advanced Options > Match Type: "CIDR(subnet)"
- Add to search to find NON matches (assuming label is ALWAYS provided)
````sql
| lookup net_trusted subnet AS src_ip index AS index OUTPUT subnet_label AS subnet_label_src
| lookup net_trusted subnet AS dst_ip index AS index OUTPUT subnet_label AS subnet_label_dst
| eval Subnet = case(
  isnull(subnet_label_src), "Source Unrecognized",
  isnull(subnet_label_dst), "Destination Unrecognized"
)
| where like(Subnet, "%Unrecognized")
````        
- To Update
  - Upload NEW Lookup Table File
  - Update permissions on new Lookup Table File
  - Update existing Lookup Definition to point to new file
- Delete/handle old Lookup Table File however