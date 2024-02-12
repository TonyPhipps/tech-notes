# Installation
- Best to check all the logs during installation rather than after installation.
  - The configuration file will be in one of these
    - \etc\system\local\inputs.conf
    - \etc\apps\SplunkUniversalFowarder\local\inputs.conf
- Set any user/password you like. This is to modify the configuration on the specific machine via splunk.exe in CLI.
- Deployment Server - You should be able to confirm access to this port via web. e.g. http://192.168.1.2:8089 and get a response. 
  - The configuration file will be \etc\system\local\deploymentclient.conf
  - Receiving indexer works with hostname but, for some reason, Deployment Server only worked with IP.
- Receiving Indexer - This one won't have a web frontend. 
  - The configuration file will be \etc\system\local\outputs.conf
  - NOTE: A server must be configured to receive on this port in order to actually receive the data sent by this client.

# Linux Installation
Download: https://www.splunk.com/en_us/download/universal-forwarder.html
```
sudo $SPLUNK_HOME/bin/splunk start --accept-license
```
Then provide a local user/pass.

```
/opt/splunkforwarder/bin/splunk set deploy-poll localhost:8089
```
Supply the user/pass made earlier.

Restart Splunk
```
/opt/splunkforwarder/bin/splunk restart
```

Setup data to forward to Splunk
```
/opt/splunkforwarder/bin/splunk add forward-server localhost:9997
/opt/splunkforwarder/bin/splunk add monitor /var/log
/opt/splunkforwarder/bin/splunk restart
```

Ref:
- https://docs.splunk.com/Documentation/Forwarder/latest/Forwarder/Installanixuniversalforwarder
- https://docs.splunk.com/Documentation/Forwarder/latest/Forwarder/Enableareceiver
- https://docs.splunk.com/Documentation/Forwarder/9.2.0/Forwarder/Configuretheuniversalforwarder

# Input Status Page
localhost:8089/services/admin/inputstatus

# Apps
NOTE: It's best to manage these via the server's Distributed Environment Forwarder Management interface
- Copy app folders to \etc\apps\
- Edit the settings in \etc\apps\yourapp\local\inputs.conf. If this file is not there, you will need to just copy the \yourapp\default folder and rename it to Local


Don't forget to restart the Splunk Forwarder service when making changes!


# Listen for Syslog
- Edit ```\etc\apps\SplunkUniversalForwarder\local\```
- use this format to listen to just one IP ```[tcp://192.168.1.10:514]```
```
[tcp://514]
sourcetype = syslog
```
- Edit ```\etc\apps\system\outputs.conf```
```
[tcpout-server://192.168.1.20:9997]
```


# Troubleshooting

### Verify service is running
```
.\bin\splunk.exe status
```

### Verify expected inputs config
```
$SPLUNK_HOME = "C:\Program Files\SplunkUniversalForwarder"
cd $SPLUNK_HOME
.\bin\splunk.exe btool inputs list --debug
```

### Verify Splunk Forwarder ports open
```
netstat -abno | findstr 9997
```

### Verify contact with Splunk Server
```
ping 192.168.0.xxx
```

### Check for errors related to the stanza
Any of these commands may be helpful.

Nix
```
Get-Content ./var/log/splunk/splunkd.log | Select-Object -Last 1000 | Select-String "stanzaname"
Get-Content ./var/log/splunk/splunkd.log -Tail 5 -Wait
Get-Content ./var/log/splunk/splunkd.log -Tail 5 -Wait | Select-String "stanzaname"
```

Win
```
Get-Content "C:\Program Files\SplunkUniversalForwarder\var\log\splunk\splunkd.log" | Select-Object -Last 1000 | Select-String "stanzaname"
Get-Content "C:\Program Files\SplunkUniversalForwarder\var\log\splunk\splunkd.log" -Tail 5 -Wait
Get-Content "C:\Program Files\SplunkUniversalForwarder\var\log\splunk\splunkd.log" -Tail 5 -Wait | Select-String "stanzaname"
```

## Updating Apps
When an app is updated, whether locally installed or via a Deployment Server, is very likely some or all updates won't take affect until the service is restarted.

Below is an example of logs from a setup with a Deployment server where the app was updated on the server, but no affect took place beyond updating the raw files until after SplunkForwarder service was restarted manually.
```
04-14-2023 12:06:36.274 -0600 INFO  DeployedApplication [8464 HttpClientPollingThread_562CE57F-481D-4C4D-87A0-9C347577E8AD] - Checksum mismatch 0 <> 8097892441118415882 for 
app=Meerkat. Will reload from='192.168.1.2:8089/services/streams/deployment?name=default:everyone:Meerkat'
04-14-2023 12:06:36.289 -0600 INFO  DeployedApplication [8464 HttpClientPollingThread_562CE57F-481D-4C4D-87A0-9C347577E8AD] - Downloaded 
url=192.168.1.2:8089/services/streams/deployment?name=default:everyone:Meerkat to file='C:\Program Files\SplunkUniversalForwarder\var\run\everyone\Meerkat-1681495492.bundle' sizeKB=390
04-14-2023 12:06:36.305 -0600 INFO  DeployedApplication [8464 HttpClientPollingThread_562CE57F-481D-4C4D-87A0-9C347577E8AD] - Installing app=Meerkat to='C:\Program 
Files\SplunkUniversalForwarder\etc\apps\Meerkat'
04-14-2023 12:06:36.367 -0600 INFO  ApplicationManager [8464 HttpClientPollingThread_562CE57F-481D-4C4D-87A0-9C347577E8AD] - Detected app creation: Meerkat
```

## Deployment Server (*client-side*)
- Deploymentclient.conf basic example
```
[deployment-client]

[target-broker:deploymentServer]
targetUri = 192.168.1.2:8089
```

- Check ```\SplunkUniversalForwarder\var\log\splunk\splunkd.log``` for entries with "DC:" and surrounding entries with "HTTPPubSubCommection"

# References
- https://docs.splunk.com/Documentation/Forwarder/9.0.4/Forwarder/InstallaWindowsuniversalforwarderfromaninstaller
- https://docs.splunk.com/Documentation/Forwarder/9.0.4/Forwarder/Configuretheuniversalforwarder
- https://docs.splunk.com/Documentation/Splunk/9.1.2/Admin/Inputsconf