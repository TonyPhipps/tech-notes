# Create a Trusted Networks List to Filter Out Events
- Upload Lookup File
  - index, subnet, subnet_label, subnet_description
    - some-Index-name, 192.168.1.0/24, Some Label, Some Description
- Create Lookup Definition
  - Advanced Options > Match Type: "CIDR(subnet)"
- Add to search to find NON matches (assuming label is ALWAYS provided)
````
| lookup ics_trusted subnet AS IPAddress index as index
| where isnull(subnet_label)
````        
- To Update
  - Upload NEW Lookup Table File
  - Update permissions on new Lookup Table File
  - Update existing Lookup Definition to point to new file
- Delete/handle old Lookup Table File however