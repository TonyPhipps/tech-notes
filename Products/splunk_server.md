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
