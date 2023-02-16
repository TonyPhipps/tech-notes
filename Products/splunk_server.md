# Install Splunk
```
dpkg -i splunk_package_name.deb
dpkg --status splunk
```

# Start
For the first time, best to run as root just to test things out.
```
su -
/opt/splunk/bin/splunk start
```

Don't forget to register for a Splunk Developer license and apply it
- https://dev.splunk.com/enterprise/dev_license/
- Settings > System > Licensing
- ```/opt/splunk/bin/splunk restart```

Accept EULA
provide username/password to configure splunk with

# Troubleshoot
Check who service is running as. Note that the service will NOT run properly without extra permissions beyond a simple "sudoers" group add.
```
ps -ef | grep splunk
```

## Configuration
- Configuration is typically done via the web interface, but browsers are not allowed to run on servers with administrative accounts (ie, the accounts we always use on our server)
- Splunk uses port 8000 for it's web interface, so from your local workstation, browse to http://servername:8000 to interact with the web GUI
- The command Line Interface works from the server.

# Apps
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

# Splunk Universal Forwarder
- Install it
- Go to C:\Program Files\SplunkUniversalForwarder\etc\system\local\
- Make inputs.conf:
```
[WinEventLog://Application]
disabled = 0

[WinEventLog://Security]
disabled = 0

[WinEventLog://System]
disabled = 0
```

# Folder Monitoring
To add a folder on the server to be monitored by Splunk, run:
```
\Splunk\bin> .\splunk add monitor "E:\temp\SplunkAdd"
```
To list all folders being monitored, run:
```
\Splunk\bin> .\splunk list monitor
```

## Reload Inputs.confg
```
./splunk _internal call /services/data/inputs/monitor/_reload -auth
```


# Uploading Data

## Add an Uploader Role
- Navigate to Settings > Access Controls > Roles
- Add an "Uploader" role with the "input_file" capability.
- Leaving all other settings default, Save the role


# Lookups
## Lookup Table Config Files
Typical lookup table settings in %splunk%\etc\apps\search\local\transforms.conf
```
[lookup_trusted_environmentvariable]
	batch_index_query = 0
	case_sensitive_match = 0
	filename = lookup_trusted_environmentvariable.csv
 match_type = WILDCARD(VariableL)
```
