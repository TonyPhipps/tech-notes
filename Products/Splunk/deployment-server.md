In Splunk, a deployment server determines which hosts (deployment clients) receive specific apps based on configurations defined in the serverclass.conf file. This file maps server classes to specific clients (hosts) and specifies which apps are deployed to those clients.

Apps intended to be deployed to clients should be stored under ```$SPLUNK_HOME/etc/deployment-apps```

To determine which hosts get which apps, you configure the ```serverclass.conf``` file (located in ```$SPLUNK_HOME/etc/system/local``` on the deployment server, although it could be stored in any app under ```$SPLUNK_HOME/etc/apps/appname/local/serverclass.conf```). 


The stanza's would look something like this:
```
[serverclass:ALL WINDOWS] 
machineTypeFilter = windows-x64 
whitelist.0 = *

[serverclass:ALL WINDOWS:app:Splunk_TA_windows]
restartSp2unkWeb = 0
restartSp2unkd = 1
stateOnClient = enabled
```

Restart the deployment server to acknowledge changes to stuff in deployment-apps (or wait the 30min check)
```
& "C:\Program Files\Splunk\bin\splunk.exe" reload deploy-server
```
If this fails, you can restart splunk via
```
& "C:\Program Files\Splunk\bin\splunk.exe" restart
```