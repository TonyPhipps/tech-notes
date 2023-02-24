# Creating an App
- see https://dev.splunk.com/enterprise/tutorials/quickstart_old/createyourfirstapp/

- $SPLUNK_HOME/etc/apps/appname/...
Structure
```
$SPLUNK_HOME/etc/apps/appname/
  /bin
    README
  /default
    app.conf
    /data
      /ui
        /nav
          default.xml
        /views
          README
  /local
    app.conf
  /metadata
    default.meta
    local.meta
```
- /bin contains supporting files (scripts, etc.)
- /local is where user-customized configurations, navigation components, and views are stored.
- /default/data/ui/nav and /local/data/ui/nav folders contain settings for the navigation bar at the top of your app in the default.xml file.
- /default/data/ui/views and /local/data/ui/views folders contain the .xml files that define dashboards in your app


# Change Destination Index
- Create the index on the server
- Edit \etc\apps\SplunkUniversalFowarder\local\inputs.conf, adding a line similar to this to each [\[stanza\]](https://docs.splunk.com/Splexicon:Stanza)
  - index = wineventlog
  - index = perfmon
  - index = whatever
- Restart the SplunkForwarder service
- Note: you may not receive logs immediately depending on the stanza's checkpointInterval setting

## Monitor Files or Folders
This can be done on other forwarders, but you may simply want to monitor directly on the server (like a shared folder or another /var/log)

- If needed, make the file /opt/splunk/etc/system/local/inputs.conf
- Edit /opt/splunk/etc/system/local/inputs.conf

Add your typical monitoring stanzas ([reference](https://docs.splunk.com/Documentation/Splunk/latest/Data/Monitorfilesanddirectorieswithinputs.conf))
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
\Splunk\bin> .\splunk add monitor "E:\temp\SplunkAdd"
```

To list all folders being monitored, run:
```
./splunk list monitor
```
Whether modifying inputs.conf or using commandline, restart the Splunk service OR reload the inputs config

```
./splunk _internal call /services/data/inputs/monitor/_reload -auth
```

# Field Extraction During Ingest
- ```props.conf``` will apply your configuration settings to your data while being indexed ([syntax](http://docs.splunk.com/Documentation/Splunk/latest/Admin/Propsconf), [KB](https://docs.splunk.com/Documentation/Splunk/latest/Knowledge/Configurecalculatedfieldswithprops.conf))
- ```transforms.conf``` contains settings and values that you can use to configure data transformations. ([syntax](https://docs.splunk.com/Documentation/Splunk/latest/Admin/Transformsconf), [KB](https://docs.splunk.com/Documentation/Splunk/latest/Knowledge/Configureadvancedextractionswithfieldtransforms))
- Both should be placed in a custom app in the folder ```$SPLUNK_HOME/etc/apps/myapp/local/```


# Troubleshooting
- If you're using a \[powershell:...\] stanza, the service kicks off the collection by first running splunk-powershell.ps1, which will be subject to any ScriptExecutionPolicy set.
