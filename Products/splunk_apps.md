# Creating an App
- see https://dev.splunk.com/enterprise/tutorials/quickstart_old/createyourfirstapp/

Essentially, make a folder with the app name, then add files. You really don't need much to get started, just a local folder and an inputs.conf file.

- $SPLUNK_HOME/etc/apps/appname/...
Structure
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

[monitor://C:\kiwi]
disabled = 0
index = kiwi
sourcetype = kiwi
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

# Field Extraction During Ingest
- ```...myapp/local/props.conf``` will apply your configuration settings to your data while being indexed ([syntax](http://docs.splunk.com/Documentation/Splunk/latest/Admin/Propsconf), [KB](https://docs.splunk.com/Documentation/Splunk/latest/Knowledge/Configurecalculatedfieldswithprops.conf))
- ```...myapp/local/transforms.conf``` contains settings and values that you can use to configure data transformations. ([syntax](https://docs.splunk.com/Documentation/Splunk/latest/Admin/Transformsconf), [KB](https://docs.splunk.com/Documentation/Splunk/latest/Knowledge/Configureadvancedextractionswithfieldtransforms))


# Troubleshooting
- If you're using a \[powershell:...\] stanza, the service kicks off the collection by first running splunk-powershell.ps1, which will be subject to any ScriptExecutionPolicy set.
