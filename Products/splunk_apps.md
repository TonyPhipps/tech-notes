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


# Inputs.conf

Create/edit the file at ```.../myapp/local/inputs.conf``` and add a [\[stanza\]](https://docs.splunk.com/Splexicon:Stanza) for each input desired ([reference](https://docs.splunk.com/Documentation/Splunk/latest/Data/Monitorfilesanddirectorieswithinputs.conf))
- Editing this requires a restart the SplunkForwarder service
- Note: you may not receive logs immediately depending on the stanza's checkpointInterval setting

## Monitor Output of PowerShell Scripts
Put script in ```$SplunkHome\etc\apps\myapp\bin\something.ps1```
```
[powershell://Meerkat:Get-ARP]
index = meerkat
schedule = */5 * * * *
script = Import-Module "$SplunkHome\etc\apps\Meerkat\bin\Modules\Get-ARP.psm1"; Get-ARP
sourcetype = Meerkat:Get-ARP
```

## Monitor Files or Folders

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

### Monitor CSV Files

inputs.conf
```
[monitor://C:\REC\*files.csv]
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

# Field Extraction During Ingest
Use transforms.conf for reusable field extraction, or props.conf for one-time field extraction.

```...myapp/local/props.conf```  ([syntax](http://docs.splunk.com/Documentation/Splunk/latest/Admin/Propsconf), [KB](https://docs.splunk.com/Documentation/Splunk/latest/Knowledge/Configurecalculatedfieldswithprops.conf))
Example
```
[syslog]
EXTRACT-syslogISOtab = ^(?<DateTime>.+?)\t(?<Priority>.+?)\t(?<Host>.+?)\t(?<Message>.+)
```

```...myapp/local/transforms.conf``` ([syntax](https://docs.splunk.com/Documentation/Splunk/latest/Admin/Transformsconf), [KB](https://docs.splunk.com/Documentation/Splunk/latest/Knowledge/Configureadvancedextractionswithfieldtransforms))

# Split One Input into Multiple Sourcetypes
This sample will walk through splitting an input log stream into multiple sourcetypes by triggering on keywords (via regex) within those logs that define their sourcetype. For example, most endpoints that record/forward logs in syslog format send multiple major groupings of event types.

Create/edit 3 files and add the following content to each.

##### .../etc/apps/search/local/inputs.conf
```
[monitor:///ingest]
disabled = false
host = splunk
index = kiwi
sourcetype = kiwisyslog
whitelist = *.txt
```

##### .../etc/apps/search/local/props.conf
```
[kiwisyslog]
NO_BINARY_CHECK = true
TRANSFORMS-sourcetye_routing = security-set-sourcetype, application-set-sourcetype, system-set-sourcetype, wmi-set-sourcetype, ps-operational-set-sourcetype
```


##### .../etc/apps/search/local/transforms.conf
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


# Parse Fields that May or May Not be Present
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
````

## See for more info
- https://docs.splunk.com/Documentation/SplunkCloud/latest/Data/Advancedsourcetypeoverrides
- https://docs.splunk.com/Documentation/Splunk/latest/Data/DataIngest
- https://docs.splunk.com/Documentation/Splunk/latest/Knowledge/Configureadvancedextractionswithfieldtransforms
- https://docs.splunk.com/Documentation/Splunk/latest/Knowledge/Exampleconfigurationsusingfieldtransforms
- https://docs.splunk.com/Documentation/Splunk/latest/Knowledge/Createandmaintainsearch-timefieldextractionsthroughconfigurationfiles



# Troubleshooting
- If you're using a ```[powershell:...]``` stanza, the service kicks off the collection by first running splunk-powershell.ps1, which will be subject to any ScriptExecutionPolicy set.
