# The Jist
- Create a search that updates a lookup for each data source.
  - Fields should be cleaned up here as much as possible.
  - Rename fields here to match master inventory fields to ease management.
  - Trim fields here (for example, trim off FQDN) to ensure deduplication works as intended.
- Create a search that uses the generated lookups to merge into one master inventory.
  - Use coalesce to prioritize fields pulled into master inventory.



# Some Search Macros
| Name                     | Definition                                                                                                                                     | Arugments |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| assetdb_indexes          | ```"index1","index2","index3"```                                                                                                               | none      |
| input_adb_lookup(1)      | ```inputlookup append=true $lookup$```                                                                                                         | lookup    |
| normalize_mac_address(1) | ```eval $mac$=lower(case(match($mac$, "^\w{12}$"), rtrim(replace($mac$, "^(\w{2})", "\1:"), ":"), 1==1, replace($mac$, "\-\|\.\|\s", ":")))``` | mac       |


# A Saved Seach to Generate a Lookup Per Data Feed

Domain Computers
```sql
index IN (`assetdb_indexes`) source="*_DomainComputers.csv" sourcetype=REC:Output:CSV dataset=DomainComputers Enabled=True 
| eventstats max(_time) as latest by host,index
| where _time=latest 
| dedup CanonicalName 
| where strptime(LastLogonDate,"%m/%d/%Y %I:%M:%S %p") > relative_time(now(),"-180d@d") OR strptime(PasswordLastSet,"%m/%d/%Y %I:%M:%S %p") > relative_time(now(),"-180d@d") 
| rename IPv4Address as ip
| eval hostname = Name 
| rex field=hostname "(?<hosttrimmed>^[^\.]+)(\.)?" 
| eval hostname=if( match(host, "^(((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4})|((([0-9A-Fa-f]{1,4}:){1,6}:)|(([0-9A-Fa-f]{1,4}:){7}))([0-9A-Fa-f]{1,4})$"), hostname, hosttrimmed ) ``` If host is an IP address, don't trim off FQDN. ``` 
| eval hostname=lower(hostname)
| eval OperatingSystemFamily=case(
    match(OperatingSystem, ".*Windows.*"),"Microsoft Windows",
    1=1, null()
    )
| table _time, index, hostname, ip, OperatingSystemFamily, OperatingSystem, OperatingSystemVersion, Description, KerberosEncryptionType
```| outputlookup "assetdb_DomainComputers.csv" create_context=user ``` ``` Create initial lookup table in user context to allow permissions to be set  ```
| eval source_lookup=assetdb_DomainComputers.csv | outputlookup assetdb_DomainComputers.csv
```

Forescout
```sql
index IN (`assetdb_indexes`) sourcetype="forescout:OTSM:REST:hosts" 
| dedup index, id, host sortby -_time 
| rename main_name as hostname, host_mac_addresses{}.mac_address as "mac", firmware_version as "OperatingSystemVersion", os_version as "OperatingSystem", serial_number as "Serial", main_vendor_model as "Model", learnt_host as learned_host 
| eval main_role=if(main_role="unknown", "", main_role) 
| rex field=hostname "(?<hosttrimmed>^[^\.]+)(\.)?" 
| eval hostname=if( match(hostname, "^(((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4})|((([0-9A-Fa-f]{1,4}:){1,6}:)|(([0-9A-Fa-f]{1,4}:){7}))([0-9A-Fa-f]{1,4})$"), hostname, hosttrimmed ) ``` If host is an IP address, don't trim off FQDN. ``` 
| eval hostname=if (main_role="windows_pdc", "", hostname) ``` PDC hostnames in Forescout tend to be the domain name, not the DC hostname. Clearing the hostname field on DCs to prevent all DCs being merged together. ``` 
| eval hostname=lower(hostname)
| `normalize_mac(mac)`
| eventstats count as "MacCount" by mac
| eval mac = if(MacCount < 5, mac, null()) ``` Remove the MAC field if it is shared by too many records, usually indicating something like Palo Alto's MAC being assigned to hosts by Forescout ```
| eval Function=main_role
| eval OperatingSystemFamily=case(
    match(OperatingSystem, ".*Windows.*"),"Microsoft Windows",
    match(OperatingSystem, ".*Server 2016.*"),"Microsoft Windows",
    match(OperatingSystem, ".*vCenter.*"),"VMware",
    match(OperatingSystem, ".*ESXi.*"),"VMware",
    match(OperatingSystem, ".*Snap.Pac.*"),"Opto-22",
    match(OperatingSystem, ".*Ruggedcom.*"),"Ruggedcom",
    match(OperatingSystem, "^ROS.*"),"Ruggedcom",
    match(OperatingSystem, ".*Nexus.*"),"Electro Industries",
    match(OperatingSystem, ".*Protime 100.*"),"Monaghan Engr",
    match(OperatingSystem, ".*Printronix.*"),"Printronix",
    match(OperatingSystem, ".*Pfboot.*"),"Printronix",
    match(OperatingSystem, ".*IOS.*"),"Cisco",
    match(OperatingSystem, ".*BusyBox.*"),"SoftPLC",
    1=1, null()
    )
| eval Manufacturer=case(
    match(Model, ".*Cisco.*"),"Cisco",
    match(Model, ".*VMware.*"),"VMware",
    match(Model, ".*Dell.*"),"Dell",
    match(Model, ".*Latitude.*"),"Dell",
    match(Model, ".*OptiPlex.*"),"Dell",
    match(Model, ".*Precision.*"),"Dell",
    match(Model, ".*PowerEdge.*"),"Dell",
    match(Model, ".*Schneider.*"),"Schneider",
    match(Model, ".*SEL.*"),"Schweitzer",
    match(Model, ".*Avigilon.*"),"Avigilon",
    match(Model, ".*NVR.*"),"Avigilon",
    match(Model, ".*SISCO.*"),"SISCO",
    match(Model, ".*Palo Alto.*"),"Palo Alto",
    match(Model, ".*Monaghan.*"),"Monaghan",
    match(Model, ".*Forescout.*"),"Forescout",
    match(Model, ".*Hewlett-Packard.*"),"HP",
    match(Model, ".*GE Automation.*"),"GE Automation",
    match(Model, ".*Milestone.*"),"Milestone",
    match(Model, ".*Opto.*"),"Opto-22",
    match(Model, ".*Logisys.*"),"Logisys",
    1=1, null()
    )
| table index, hostname, ip, mac, Manufacturer, Model, Serial, OperatingSystemFamily, OperatingSystem, OperatingSystemVersion, main_role, last_seen, first_seen, public_ip, learned_host, _time, Function, MacCount
| foreach *
    [| eval <<FIELD>>=mvjoin(<<FIELD>>,"|")] ``` After table to avoid errors related to the looping through all the JSON names ```
```| outputlookup "assetdb_Forescout.csv" create_context=user ``` ``` Create initial lookup table in user context to allow permissions to be set  ```
| eval source_lookup=assetdb_Forescout.csv | outputlookup assetdb_Forescout.csv
```

REC NetAdapters
```sql
index IN (`assetdb_indexes`) source="*_NetAdapters.csv" sourcetype=REC:Output:CSV dataset=NetAdapters IPAddress=* 
| eventstats max(_time) as latest by host,index 
| where _time=latest 
| eval hostname = SystemName 
| rex field=hostname "(?<hosttrimmed>^[^\.]+)(\.)?" 
| eval hostname=if( match(hostname, "^(((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4})|((([0-9A-Fa-f]{1,4}:){1,6}:)|(([0-9A-Fa-f]{1,4}:){7}))([0-9A-Fa-f]{1,4})$"), hostname, hosttrimmed ) ``` If host is an IP address, don't trim off FQDN. ```
| eval hostname=lower(hostname)
| rename MacAddress as mac
| `normalize_mac(mac)`
| eval mac=lower(mac)
| makemv delim=", " IPAddress
| mvexpand IPAddress
| rename IPAddress as ip
| where ip!="127.0.0.1"
| table index, hostname, ip, mac, MediaConnectionState, InterfaceDescription, NetworkCategory, _time
``` | outputlookup "assetdb_NetAdapters.csv" create_context=user ``` ``` Create initial lookup table in user context to allow permissions to be set  ```
| eval source_lookup=assetdb_NetAdapters.csv | outputlookup assetdb_NetAdapters.csv
```

REC (tstats)
```sql
| tstats count where index IN (`assetdb_indexes`) sourcetype=REC:Output:CSV by _time,index,host span=d@d ``` _time is required for assetdb to merge using "latest" method ```
| dedup index, host sortby -_time 
| rename host as hostname 
| rex field=hostname "(?<hosttrimmed>^[^\.]+)(\.)?" 
| eval hostname=if( match(hostname, "^(((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4})|((([0-9A-Fa-f]{1,4}:){1,6}:)|(([0-9A-Fa-f]{1,4}:){7}))([0-9A-Fa-f]{1,4})$"), hostname, hosttrimmed ) ``` If host is an IP address, don't trim off FQDN. ``` 
| eval hostname=lower(hostname) 
| table index, hostname, _time
```| outputlookup "assetdb_RecTstats.csv" create_context=user``` ``` Create initial lookup table in user context to allow permissions to be set  ```
| eval source_lookup=assetdb_RecTstats.csv | outputlookup assetdb_RecTstats.csv
```

Syslog
```sql
| tstats count WHERE index IN (`assetdb_indexes`) sourcetype IN ("syslog","vmw-syslog","pan_log","pan:traffic","linux:*","cisco:ios","PAN_XML")  by _time,index,host span=d@d ``` _time is required for assetdb to merge using "latest" method ```
| where host!="127.0.0.1"
| dedup index, host sortby -_time 
| rename host as hostname 
| rex field=hostname "(?<hosttrimmed>^[^\.]+)(\.)?" 
| eval ip=if( match(hostname, "^(((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4})|((([0-9A-Fa-f]{1,4}:){1,6}:)|(([0-9A-Fa-f]{1,4}:){7}))([0-9A-Fa-f]{1,4})$"), hostname, null() ) ``` If host is an IP address, assign to the ip field. ``` 
| eval hostname=if( match(hostname, "^(((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4})|((([0-9A-Fa-f]{1,4}:){1,6}:)|(([0-9A-Fa-f]{1,4}:){7}))([0-9A-Fa-f]{1,4})$"), null(), hosttrimmed ) ``` If host is an IP address, remove from the hostname field. ``` 
| eval hostname=lower(hostname) 
| table index, hostname, ip, _time
``` | outputlookup "assetdb_Syslog.csv" create_context=user ``` ``` Create initial lookup table in user context to allow permissions to be set  ```
| eval source_lookup=assetdb_Syslog.csv | outputlookup assetdb_Syslog.csv
```



# A Include Manual Entries (To override all)

```sql
| inputlookup assetdb_-ManualEntries.csv
| table index, _time, Hostname, OS_family, OS_Name, OS_Version, Ip_address, Mac_Address, Equipment_Class, Manufacturer, Model, Serial_No, Visual_ID, Description, Function, Physical_Location
| rename Hostname as hostname, OS_family as OperatingSystemFamily, OS_Name as OperatingSystem, OS_Version as OperatingSystemVersion, Ip_address as ip, Mac_Address as mac, Serial_No as Serial
| eval _time = now()
| rex field=hostname "(?<hosttrimmed>^[^\.]+)(\.)?" 
| eval hostname=if( match(hostname, "^(((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4})|((([0-9A-Fa-f]{1,4}:){1,6}:)|(([0-9A-Fa-f]{1,4}:){7}))([0-9A-Fa-f]{1,4})$"), hostname, hosttrimmed ) ``` If host is an IP address, don't trim off FQDN. ``` 
| eval hostname=lower(hostname) 
| `normalize_mac(mac)`
| eval mac=lower(mac)
| foreach ip [eval <<FIELD>>=split(<<FIELD>>, " ")] ``` Multiple IPs represented as ; delimited in the input ip field```
| foreach ip [eval <<FIELD>>=split(<<FIELD>>, ";")] ``` Multiple IPs represented as space delimited in the input ip field```
| mvexpand ip ``` join with | so assetdb search can handle it properly```
| table index, _time, hostname, OperatingSystemFamily, OperatingSystem, OperatingSystemVersion, ip, mac, Equipment_Class, Manufacturer, Model, Serial, Visual_ID, Description, Function, Physical_Location
```| outputlookup "assetdb_ManualEntries.csv" create_context=user ``` ``` Create initial lookup table in user context to allow permissions to be set  ```
| eval source_lookup=assetdb_ManualEntries.csv | outputlookup assetdb_ManualEntries.csv
```


# A Saved Search To Pull All Inventories into one Lookup

LOOKUPGEN - assetdb
```sql
| eventcount summarize=false index=* 
| stats sum(count) as IndexEventCount by index 
| search index IN (`assetdb_indexes`)
| map [
| `input_adb_lookup(assetdb_DomainComputers.csv)`
| `input_adb_lookup(assetdb_Forescout.csv)`
| `input_adb_lookup(assetdb_NetAdapters.csv)`
| `input_adb_lookup(assetdb_RecTstats.csv)`
| `input_adb_lookup(assetdb_ManualEntries.csv)`
| `input_adb_lookup(assetdb_Syslog.csv)`

``` Filter the lookup data to only the current iteration index```
| where index=$index$

```### Split multivalue fields ###```
| foreach Description, index, InterfaceDescription, ip, mac
    [eval <<FIELD>>=split(<<FIELD>>, "|")]

```### Convert case insensitive fields to lowercase ###```
| foreach hostname, IgnoreEntry, index, ip, learned_host, mac, main_role, Physical_Location, public_ip, Visual_ID
    [eval <<FIELD>>=lower(<<FIELD>>)]

```### Validate field values ###```
| eval hostname=mvfilter(match(hostname, "^[a-zA-Z0-9\-\.]+$")), ip=mvfilter(match(ip, ".+"))

``` Replace an empty string with literal null to ensure merges properly ignore them ```
| foreach * [| eval <<FIELD>>=if('<<FIELD>>'=="" OR match('<<FIELD>>', "^\s*$"),null(),'<<FIELD>>')]

```### Map source lookup to source name ###```
| eval source=case(source_lookup="assetdb_DomainComputers.csv", "DomainComputers", source_lookup="assetdb_Forescout.csv", "Forescout", source_lookup="assetdb_NetAdapters.csv", "NetAdapters", source_lookup="assetdb_RecTstats.csv", "RecTstats", source_lookup="assetdb_ManualEntries.csv", "ManualEntries", source_lookup="assetdb_HostsFile.csv", "HostsFile", source_lookup="assetdb_Syslog.csv", "Syslog")

```### Create lookup specific fields for priority based coalesce ###```
| eval {source}_Equipment_Class = Equipment_Class, {source}_Function = Function, {source}_hostname = hostname, {source}_Manufacturer = Manufacturer, {source}_OperatingSystem = OperatingSystem, {source}_OperatingSystemFamily = OperatingSystemFamily, {source}_OperatingSystemVersion = OperatingSystemVersion, {source}_Serial = Serial

```### Shallow merge assets with matching key fields (using basic stats) ###```
| eval _key = mvjoin(mvdedup(mvappend(hostname, ip, mac)), "::")
| search _key=*
| stats values(source) as source, values(source_lookup) as source_lookup, latest(_time) as _time, values(Description) as Description, latest(ManualEntries_Equipment_Class) as ManualEntries_Equipment_Class, latest(DomainComputers_Equipment_Class) as DomainComputers_Equipment_Class, latest(Forescout_Equipment_Class) as Forescout_Equipment_Class, latest(Firmware) as Firmware, latest(first_seen) as first_seen, latest(ManualEntries_Function) as ManualEntries_Function, latest(Forescout_Function) as Forescout_Function, latest(DomainComputers_Function) as DomainComputers_Function, latest(ManualEntries_hostname) as ManualEntries_hostname, latest(NetAdapters_hostname) as NetAdapters_hostname, latest(DomainComputers_hostname) as DomainComputers_hostname, latest(HostsFile_hostname) as HostsFile_hostname, latest(RecTstats_hostname) as RecTstats_hostname, latest(Forescout_hostname) as Forescout_hostname, latest(Syslog_hostname) as Syslog_hostname, latest(IgnoreEntry) as IgnoreEntry, values(index) as index, values(InterfaceDescription) as InterfaceDescription, values(ip) as ip, latest(KerberosEncryptionType) as KerberosEncryptionType, latest(last_seen) as last_seen, latest(learned_host) as learned_host, values(mac) as mac, latest(main_role) as main_role, latest(ManualEntries_Manufacturer) as ManualEntries_Manufacturer, latest(Forescout_Manufacturer) as Forescout_Manufacturer, latest(DomainComputers_Manufacturer) as DomainComputers_Manufacturer, latest(MediaConnectionState) as MediaConnectionState, latest(Model) as Model, latest(NetworkCategory) as NetworkCategory, latest(ManualEntries_OperatingSystem) as ManualEntries_OperatingSystem, latest(DomainComputers_OperatingSystem) as DomainComputers_OperatingSystem, latest(Forescout_OperatingSystem) as Forescout_OperatingSystem, latest(ManualEntries_OperatingSystemFamily) as ManualEntries_OperatingSystemFamily, latest(DomainComputers_OperatingSystemFamily) as DomainComputers_OperatingSystemFamily, latest(Forescout_OperatingSystemFamily) as Forescout_OperatingSystemFamily, latest(ManualEntries_OperatingSystemVersion) as ManualEntries_OperatingSystemVersion, latest(DomainComputers_OperatingSystemVersion) as DomainComputers_OperatingSystemVersion, latest(Forescout_OperatingSystemVersion) as Forescout_OperatingSystemVersion, latest(Physical_Location) as Physical_Location, latest(public_ip) as public_ip, latest(ManualEntries_Serial) as ManualEntries_Serial, latest(Forescout_Serial) as Forescout_Serial, latest(Visual_ID) as Visual_ID, values(hostname) as hostname by _key

```### Deep merge assets with matching key fields (using custom command) ###```
``` Manually coalesce here to ensure key fields are persisted through the shallow merge. Only key fields need to be coalesced, but entire coalesce stage is duplicated for convenience ```
| eval Equipment_Class = coalesce('ManualEntries_Equipment_Class', 'DomainComputers_Equipment_Class', 'Forescout_Equipment_Class'), Function = coalesce('ManualEntries_Function', 'Forescout_Function', 'DomainComputers_Function'), Manufacturer = coalesce('ManualEntries_Manufacturer', 'Forescout_Manufacturer', 'DomainComputers_Manufacturer'), OperatingSystem = coalesce('ManualEntries_OperatingSystem', 'DomainComputers_OperatingSystem', 'Forescout_OperatingSystem'), OperatingSystemFamily = coalesce('ManualEntries_OperatingSystemFamily', 'DomainComputers_OperatingSystemFamily', 'Forescout_OperatingSystemFamily'), OperatingSystemVersion = coalesce('ManualEntries_OperatingSystemVersion', 'DomainComputers_OperatingSystemVersion', 'Forescout_OperatingSystemVersion'), Serial = coalesce('ManualEntries_Serial', 'Forescout_Serial')
| eval _key = mvappend(hostname, ip, mac)
| adbmerge max_keys=300
| eval _key = md5(mvjoin(asset, "::"))
| stats values(asset) as asset, values(source) as source, values(source_lookup) as source_lookup, latest(_time) as _time, values(Description) as Description, latest(ManualEntries_Equipment_Class) as ManualEntries_Equipment_Class, latest(DomainComputers_Equipment_Class) as DomainComputers_Equipment_Class, latest(Forescout_Equipment_Class) as Forescout_Equipment_Class, latest(Firmware) as Firmware, latest(first_seen) as first_seen, latest(ManualEntries_Function) as ManualEntries_Function, latest(Forescout_Function) as Forescout_Function, latest(DomainComputers_Function) as DomainComputers_Function, latest(ManualEntries_hostname) as ManualEntries_hostname, latest(NetAdapters_hostname) as NetAdapters_hostname, latest(DomainComputers_hostname) as DomainComputers_hostname, latest(HostsFile_hostname) as HostsFile_hostname, latest(RecTstats_hostname) as RecTstats_hostname, latest(Forescout_hostname) as Forescout_hostname, latest(Syslog_hostname) as Syslog_hostname, latest(IgnoreEntry) as IgnoreEntry, values(index) as index, values(InterfaceDescription) as InterfaceDescription, values(ip) as ip, latest(KerberosEncryptionType) as KerberosEncryptionType, latest(last_seen) as last_seen, latest(learned_host) as learned_host, values(mac) as mac, latest(main_role) as main_role, latest(ManualEntries_Manufacturer) as ManualEntries_Manufacturer, latest(Forescout_Manufacturer) as Forescout_Manufacturer, latest(DomainComputers_Manufacturer) as DomainComputers_Manufacturer, latest(MediaConnectionState) as MediaConnectionState, latest(Model) as Model, latest(NetworkCategory) as NetworkCategory, latest(ManualEntries_OperatingSystem) as ManualEntries_OperatingSystem, latest(DomainComputers_OperatingSystem) as DomainComputers_OperatingSystem, latest(Forescout_OperatingSystem) as Forescout_OperatingSystem, latest(ManualEntries_OperatingSystemFamily) as ManualEntries_OperatingSystemFamily, latest(DomainComputers_OperatingSystemFamily) as DomainComputers_OperatingSystemFamily, latest(Forescout_OperatingSystemFamily) as Forescout_OperatingSystemFamily, latest(ManualEntries_OperatingSystemVersion) as ManualEntries_OperatingSystemVersion, latest(DomainComputers_OperatingSystemVersion) as DomainComputers_OperatingSystemVersion, latest(Forescout_OperatingSystemVersion) as Forescout_OperatingSystemVersion, latest(Physical_Location) as Physical_Location, latest(public_ip) as public_ip, latest(ManualEntries_Serial) as ManualEntries_Serial, latest(Forescout_Serial) as Forescout_Serial, latest(Visual_ID) as Visual_ID, values(hostname) as hostname by _key

```### Trim multivalue fields ###```
| eval Description = mvindex(Description,0,9), index = mvindex(index,0,9), InterfaceDescription = mvindex(InterfaceDescription,0,9)

```### Define coalesce fields based on lookup priority ###```
| eval Equipment_Class = coalesce('ManualEntries_Equipment_Class', 'DomainComputers_Equipment_Class', 'Forescout_Equipment_Class'), Function = coalesce('ManualEntries_Function', 'Forescout_Function', 'DomainComputers_Function'), Manufacturer = coalesce('ManualEntries_Manufacturer', 'Forescout_Manufacturer', 'DomainComputers_Manufacturer'), OperatingSystem = coalesce('ManualEntries_OperatingSystem', 'DomainComputers_OperatingSystem', 'Forescout_OperatingSystem'), OperatingSystemFamily = coalesce('ManualEntries_OperatingSystemFamily', 'DomainComputers_OperatingSystemFamily', 'Forescout_OperatingSystemFamily'), OperatingSystemVersion = coalesce('ManualEntries_OperatingSystemVersion', 'DomainComputers_OperatingSystemVersion', 'Forescout_OperatingSystemVersion'), Serial = coalesce('ManualEntries_Serial', 'Forescout_Serial')

```### Output to KV store ###```
| table _key, asset, source, source_lookup, _time, Description, Equipment_Class, Firmware, first_seen, Function, hostname, IgnoreEntry, index, InterfaceDescription, ip, KerberosEncryptionType, last_seen, learned_host, mac, main_role, Manufacturer, MediaConnectionState, Model, NetworkCategory, OperatingSystem, OperatingSystemFamily, OperatingSystemVersion, Physical_Location, public_ip, Serial, Visual_ID
]
| search NOT main_role IN ("multicast","broadcast","root_dns_server")
| eval SourceCount = mvcount(source)
| eval KeyFieldCount = if(asset=="MAX_KEYS_REACHED", 100, mvcount(asset)) ``` Number of IPs/MACs/Hostnames assigned to an asset. Can indicate bad data causing overmerging. Generally anything over 7 (2 IPv4 + IPv6 interfaces) is suspect ```
| lookup mac_address_vendor_lookup MacPrefix as mac  OUTPUT VendorName
| eval Manufacturer=coalesce(Manufacturer, VendorName)
| sort index, hostname, ip
| rename hostname as Hostname, OperatingSystemFamily as OS_family, OperatingSystem as OS_Name, OperatingSystemVersion as OS_Version, ip as Ip_address, mac as Mac_Address, Serial as Serial_No
| table Hostname, OS_family, OS_Name, OS_Version, Ip_address, Mac_Address, Equipment_Class, Manufacturer, Model, Serial_No, Visual_ID, Description, Function, Physical_Location, source, SourceCount, KeyFieldCount, asset
| eval Hostname = upper(Hostname)
``` | outputlookup assetdb ``` ``` KV Store lookup throwing "not-visible" error. Either fix permissions, or use assetdb ```
| sort Hostname
| foreach Hostname, Ip_address, Mac_Address, Description, source, asset
[eval <<FIELD>>=mvjoin(<<FIELD>>, "
")] ``` Do not change the line break - this is joining the mvfields with a newline so they display cleanly in excel.```
```


Base Search
```sql
|inputlookup assetdb.csv
| foreach Hostname, Ip_address, Mac_Address, Description, source, asset
[eval &lt;&lt;FIELD&gt;&gt;=split(&lt;&lt;FIELD&gt;&gt;, "|")]
| table Hostname, OS_family, OS_Name, OS_Version, Ip_address, Mac_Address, Equipment_Class, Manufacturer, Model, Serial_No, Visual_ID, Description, Function, Physical_Location, source, SourceCount, KeyFieldCount, asset
```

System Inventory
<search base="Inventory">
```sql
| sort -KeyFieldCount, -SourceCount, Hostname
```