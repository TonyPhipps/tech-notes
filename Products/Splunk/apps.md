# Creating an App
- See https://dev.splunk.com/enterprise/docs/developapps
- See https://dev.splunk.com/enterprise/tutorials/module_getstarted

Essentially, make a folder with the app name, then add files. You really don't need much to get started, just a local folder and an inputs.conf file.

To activate, copy/move to ```$SPLUNK_HOME/etc/apps/appname/...``` or on the server at ```.../splunk/etc/deployment-apps/```

Structure:
```
$SPLUNK_HOME/etc/apps/appname/
  /bin
    README
  /default and/or  /local
    app.conf
    inputs.conf
    props.conf
    transforms.conf
    indexes.conf (if you want to prestage indexes)
    macros.conf (if you want to prestage macros)
    savedsearches.conf (if you wanted to preconfigure saved searches)
    web.conf (if you want to set defaults for the web interface)
    /data
      /ui
        /nav
          default.xml
        /views
          README
  /metadata
    default.meta
    local.meta
```
- /bin contains supporting files (scripts, etc.)
- /local is where user-customized configurations, navigation components, and views are stored.
- /default/data/ui/nav and /local/data/ui/nav folders contain settings for the navigation bar at the top of your app in the default.xml file.
- /default/data/ui/views and /local/data/ui/views folders contain the .xml files that define dashboards in your app

## Splunk's Data Pipeline
- Splunk processes data in stages: input, parsing, indexing, and search.
- Index-time transformations (e.g., TRANSFORMS-<class>) are applied during the parsing or indexing phase.
- Search-time transformations (e.g., REPORT-<class> or LOOKUP-<class>) are applied when a search is executed.
- The loading and application of props.conf and transforms.conf depend on the pipeline stage (index-time vs. search-time).


## Load Order
- Splunk loads all .conf files, including props.conf and transforms.conf, during startup or when configurations are reloaded (e.g., via a Splunk restart or a | reload command).
- The files are processed in alphabetical order within a folder (e.g., props.conf before transforms.conf in an app's default or local folder), as discussed previously.
- Settings are merged based on the precedence hierarchy (system default, app default, system local, app local, user local).
- .conf files are processed in alphabetical order (inputs.conf > props.conf > transforms.conf)
- If multiple .conf files define the same stanza (e.g., [my_stanza]) or attribute, the file processed later in the alphabetical order takes precedence for that specific setting
- Stanzas within are loaded in order of appearance in the file, top to botom (NOT alphabetically)


## Prepare as a Splunk App Package
```
cd /path/to/addonName/
tar -zcf addonName.tgz addonName
```

# Config Files

## inputs.conf
For data inputs

Create/edit the file at ```.../myapp/local/inputs.conf``` and add a [\[stanza\]](https://docs.splunk.com/Splexicon:Stanza) for each input desired ([reference](https://docs.splunk.com/Documentation/Splunk/latest/Data/Monitorfilesanddirectorieswithinputs.conf))
- Editing this requires a restart the SplunkForwarder service
- Note: you may not receive logs immediately depending on the stanza's checkpointInterval setting

### Monitor Output of PowerShell Scripts
Put script in ```$SplunkHome\etc\apps\myapp\bin\something.ps1```
```
[powershell://Meerkat:Get-ARP]
index = meerkat
schedule = */5 * * * *
script = Import-Module "$SplunkHome\etc\apps\Meerkat\bin\Modules\Get-ARP.psm1"; Get-ARP
sourcetype = Meerkat:Get-ARP
```

### Monitor Files or Folders

```
[monitor:///var/log/kiwi]
disabled = 0
index = kiwi
sourcetype = kiwi
whitelist = *.txt

[monitor://C:\kiwi]
disabled = 0
index = kiwi
sourcetype = kiwi
whitelist = *.txt
```

To add a folder on the server to be monitored by Splunk via command line:
```
.\splunk add monitor "E:\temp\SplunkAdd"
```

To list all folders being monitored, run:
```
.\splunk list monitor
```

Always restart the Splunk Forwarder service when making changes to files.

See for more
- https://docs.splunk.com/Documentation/Splunk/latest/Data/Monitorfilesanddirectorieswithinputs.conf
- https://docs.splunk.com/Documentation/Splunk/latest/Data/Specifyinputpathswithwildcards

## indexes.conf
This optional file lets you prestage one or more indexes.

Add an index named NewIndexName. Note the $_index_name does not need to be changed, as it references the index name.

```
[newIndexName]
homePath=$SPLUNK_DB/$_index_name/db
coldPath=$SPLUNK_DB/$_index_name/colddb
thawedPath=$SPLUNK_DB/$_index_name/thaweddb
```

## macros.conf
This optional file lets you prestage one or more search macros.

```
[windows_log_search_base]
definition = index="evtx" OR index="wineventlog" earliest=1 AND latest=now()
iseval = 0
```

## props.conf
Defines properties for data parsing and processing, such as sourcetype configurations, field extractions, and references to transformations. It can include settings like TRANSFORMS-<class> or REPORT-<class> to invoke stanzas in transforms.conf.

n props.conf, stanzas for a sourcetype, source, or host (e.g., [my_sourcetype]) can include attributes like:
TRANSFORMS-<class> = <transform_stanza_name>: Used for index-time transformations (e.g., routing, filtering, or masking data before indexing).

REPORT-<class> = <transform_stanza_name>: Used for search-time field extractions (e.g., extracting fields using regex).

LOOKUP-<class> = <lookup_stanza_name>: Used for search-time lookups defined in transforms.conf.

These attributes point to specific stanzas in transforms.conf

### Map Splunk Classic to XML
```
[WinEventLog]
# Splunk UF Classic to XML
FIELDALIAS-RecordNumber = RecordNumber as EventRecordID
FIELDALIAS-EventCode = EventCode as EventID
FIELDALIAS-Severity = Severity as Level
FIELDALIAS-LogName = LogName as Channel
FIELDALIAS-ComputerName = ComputerName as Computer
FIELDALIAS-src_user = src_user as SubjectUserName
FIELDALIAS-Logon_ID = Logon_ID as TargetLogonID
FIELDALIAS-SessionID = SessionID as TargetLogonID
FIELDALIAS-user = user as TargetUserName
FIELDALIAS-dest_nt_domain = dest_nt_domain as TargetDomainName
FIELDALIAS-Logon_Type = Logon_Type as LogonType
FIELDALIAS-Creator_Process_Name = Creator_Process_Name as ParentProcessName
FIELDALIAS-Process_Command_Line = Process_Command_Line as CommandLine
FIELDALIAS-Sid = Sid as SubjectUserSid
FIELDALIAS-src_ip = src_ip as IpAddress
FIELDALIAS-event_id = event_id as EventRecordID
FIELDALIAS-id = id as EventRecordID
FIELDALIAS-Logon_Process = Logon_Process as LogonProcessName
FIELDALIAS-Authentication_Package = Authentication_Package as AuthenticationPackageName
FIELDALIAS-Source_Port = Source_Port as IpPort
FIELDALIAS-Logon_GUID = Logon_GUID as LogonGuid
FIELDALIAS-New_Process_Name = New_Process_Name as NewProcessName
FIELDALIAS-New_Process_ID = New_Process_ID as NewProcessID
FIELDALIAS-Workstation_Name = Workstation_Name as WorkstationName
```


## transforms.conf
Defines transformations, such as regex-based field extractions, lookups, or data routing, that are referenced by props.conf. Each transformation is defined in a stanza (e.g., [my_transform]).

```...myapp/local/props.conf```  ([syntax](http://docs.splunk.com/Documentation/Splunk/latest/Admin/Propsconf), [KB](https://docs.splunk.com/Documentation/Splunk/latest/Knowledge/Configurecalculatedfieldswithprops.conf))
Example
```
[syslog]
EXTRACT-syslogISOtab = ^(?<DateTime>.+?)\t(?<Priority>.+?)\t(?<Host>.+?)\t(?<Message>.+)
```

```...myapp/local/transforms.conf``` ([syntax](https://docs.splunk.com/Documentation/Splunk/latest/Admin/Transformsconf), [KB](https://docs.splunk.com/Documentation/Splunk/latest/Knowledge/Configureadvancedextractionswithfieldtransforms))

### Parse Fields that May or May Not be Present
Note that every "sub field" is optional under Subject, and that Subject captures the entire fieldset for review.

```
(Subject:(?<Subject>
    (\s+Security\sID:\s+(?<Subject_SecurityID>.+?)(?:\n|$))?
    (\s+Account\sName:\s+(?<Subject_AccountName>.+?)(?:\n|$))?
    (\s+Account\sDomain:\s+(?<Subject_AccountDomain>.+?)(?:\n|$))?
    (\s+Logon\sID:\s+(?<Subject_LogonID>.+?)(?:\n|$))?
    (\s+Logon\sType:\s+(?<Subject_LogonType>.+?)(?:\n|$))?
    )?
)?
```

That regular expression must be used without whitespace in Splunk transforms.conf, like this
```
[extract-security-xml]
REGEX = (Subject:(?<Subject>(\s+Security\sID:\s+(?<Subject_SecurityID>.+?)(?:\n|$))?(\s+Account\sName:\s+(?<Subject_AccountName>.+?)(?:\n|$))?(\s+Account\sDomain:\s+(?<Subject_AccountDomain>.+?)(?:\n|$))?(\s+Logon\sID:\s+(?<Subject_LogonID>.+?)(?:\n|$))?(\s+Logon\sType:\s+(?<Subject_LogonType>.+?)(?:\n|$))?)?)?
SOURCE_KEY = EventXML
```


## savedsearches.conf
Change default schedule for this app
```
[default]
cron_schedule = 0 12 * * *
dispatch.earliest_time = 0
dispatch.latest_time = now
```

## web.conf
Increase web timeout to allow exporting larger result sets
```
[settings]
export_timeout = 7200
```

## Monitor CSV Files

inputs.conf
```
[monitor://C:\Meerkat\*files.csv]
disabled = 0
initCrcLength = 512
index = my_csv_file
sourcetype = Stuff
```

props.conf
```
[Stuff]
disabled = false
INDEXED_EXTRACTIONS = CSV
HEADER_FIELD_LINE_NUMBER = 1
SHOULD_LINEMERGE = false
TIMESTAMP_FIELDS = DateColumnName
TIME_FORMAT = %Y-%m-%d %H:%M:%SZ
ALWAYSOPENFILE = 1
```

## Split One Input into Multiple Sourcetypes

This sample will walk through splitting an input log stream into multiple sourcetypes by triggering on keywords (via regex) within those logs that define their sourcetype. For example, most endpoints that record/forward logs in syslog format send multiple major groupings of event types.

Create/edit 3 files and add the following content to each.

### .../etc/apps/search/local/inputs.conf
```
[monitor:///ingest]
disabled = false
host = splunk
index = kiwi
sourcetype = kiwisyslog
whitelist = *.txt
```

### .../etc/apps/search/local/props.conf
```
[kiwisyslog]
NO_BINARY_CHECK = true
TRANSFORMS-sourcetye_routing = security-set-sourcetype, application-set-sourcetype, system-set-sourcetype, wmi-set-sourcetype, ps-operational-set-sourcetype
```


### .../etc/apps/search/local/transforms.conf
```
[security-set-sourcetype]
DEST_KEY = MetaData:Sourcetype
REGEX = (\sMicrosoft-Windows-Security-Auditing\s)
FORMAT = sourcetype::WinEventLog:Security

[application-set-sourcetype]
DEST_KEY = MetaData:Sourcetype
REGEX = (\sMSWinEventLog\s\d\sApplication\s)
FORMAT = sourcetype::WinEventLog:Application

[system-set-sourcetype]
DEST_KEY = MetaData:Sourcetype
REGEX = (\sMSWinEventLog\s\d\sSystem\s)
FORMAT = sourcetype::WinEventLog:System

[wmi-set-sourcetype]
DEST_KEY = MetaData:Sourcetype
REGEX = (\sMSWinEventLog\s\d\sMicrosoft-Windows-WMI-Activity/Operational\s)
FORMAT = sourcetype::WinEventLog:Microsoft-Windows-WMI-Activity/Operational

[ps-operational-set-sourcetype]
DEST_KEY = MetaData:Sourcetype
REGEX = (\sMSWinEventLog\s\d\sMicrosoft-Windows-PowerShell/Operational\s)
FORMAT = sourcetype::WinEventLog:Microsoft-Windows-PowerShell/Operational
```

## Analyze an App
Determine final names of all fields
- Look in props.conf and transforms.conf for ```EVAL-```, ```FIELDALIAS-```, ```EXTRACT-``` and ```LOOKUP-``` classes
- Look in datamodels.conf file as ```"fieldname"``` JSON attributes.
- Look in savedsearches.conf for ```| eval``` and ```| rex```

## See for more info
- https://docs.splunk.com/Documentation/SplunkCloud/latest/Data/Advancedsourcetypeoverrides
- https://docs.splunk.com/Documentation/Splunk/latest/Data/DataIngest
- https://docs.splunk.com/Documentation/Splunk/latest/Knowledge/Configureadvancedextractionswithfieldtransforms
- https://docs.splunk.com/Documentation/Splunk/latest/Knowledge/Exampleconfigurationsusingfieldtransforms
- https://docs.splunk.com/Documentation/Splunk/latest/Knowledge/Createandmaintainsearch-timefieldextractionsthroughconfigurationfiles



# Troubleshooting
- If you're using a ```[powershell:...]``` stanza, the service kicks off the collection by first running splunk-powershell.ps1, which will be subject to any ScriptExecutionPolicy set.


# Specific Apps

## PSTree
- https://splunkbase.splunk.com/app/5721

Modify to work with Windows Event ID 4688
```
index IN (evtx, wineventlog) (sourcetype=*WinEventLog:* OR source=*WinEventLog:* OR source="*.json") EventCode=4688 host IN (*testhost*)
| eval process_id = tonumber(process_id, 16)
| eval parent_process_id = tonumber(parent_process_id, 16)
| eval child=NewProcessName." (".process_id.")"
| eval parent=NewProcessName." (".parent_process_id.")"
| eval detail=strftime(_time, "%Y-%m-%d %H:%M:%S")." ".CommandLine
| pstree child=child parent=parent detail=detail spaces=50
| table tree
```

To work with Meerkat Processes
```
| tstats count
    WHERE index IN ("meerkat") sourcetype=Meerkat:Output:CSV dataset=Processes host="testhost"
    NOT ModuleErrorMessage IN ("Skipped", "No Results")
    BY DateScanned host CommandLine Id ParentId Path ParentPath UserName 
| eval DateScanned = strptime(DateScanned, "%Y-%m-%d %T%Z") 
| eventstats max(DateScanned) as latest by host 
| WHERE DateScanned=latest 
| foreach DateScanned host CommandLine Id ParentId Path ParentPath UserName 
    [ eval <<FIELD>> = if (isnull(<<FIELD>>) OR trim(<<FIELD>>)=="", "-", <<FIELD>>) ] 
| eval DateScanned=strftime(DateScanned, "%Y-%m-%dT%H:%M:%S%z") 
| eval process_id = tonumber(Id, 16) 
| eval parent_process_id = tonumber(ParentId, 16) 
| rex field=Path "\\\\(?<ChildName>[^\\\\]+)$"
| eval child=ChildName." (".process_id.")" 
| rex field=ParentPath "\\\\(?<ParentName>[^\\\\]+)$"
| eval parent=ParentName." (".parent_process_id.")" 
| eval detail=DateScanned." ".UserName." ".CommandLine 
| pstree child=child parent=parent detail=detail spaces=50 
| table tree
```

## AssetDB
AssetDB is a Splunk application that allows merging distinct data sources into an asset data base

- https://splunkbase.splunk.com/app/6115
- https://github.com/alatif113/assetdb