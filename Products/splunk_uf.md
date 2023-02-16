# Windows

## Installation
- Best to check all the logs during installation rather than after installation.
  - The configuration file will be \etc\apps\SplunkUniversalFowarder\local\inputs.conf
- Set any user/password you like. This is to modify the configuration on the specific machine via splunk.exe in CLI.
- Deployment Server - You should be able to confirm access to this port via web. e.g. http://192.168.1.2:8089 and get a response. 
  - The configuration file will be \etc\system\local\deploymentclient.conf
    - you may need to add [deployment-client] at the top of the file to get it to properly handshake/phone home to the deployment server
  - Receiving indexer works with hostname but, for some reason, Deployment Server only worked with IP.
- Receiving Indexer - This one won't have a web frontend. 
  - The configuration file will be \etc\system\local\outputs.conf
  - NOTE: A server must be configured to receive on this port in order to actually receive the data sent by this client.

## Change Destination Index
- Create the index on the server
- Edit \etc\apps\SplunkUniversalFowarder\local\inputs.conf, adding a line similar to this to each [\[stanza\]](https://docs.splunk.com/Splexicon:Stanza)
  - index = wineventlog
  - index = perfmon
  - index = whatever
- Restart the SplunkForwarder service
- Note: you may not receive logs immediately depending on the stanza's checkpointInterval setting

## Addons
- Copy app folders to \etc\apps\
- Edit the settings in \etc\apps\yourapp\local\inputs.conf. If this file is not there, you will need to just copy the \yourapp\default folder and rename it to Local

References
- https://docs.splunk.com/Documentation/Forwarder/9.0.4/Forwarder/InstallaWindowsuniversalforwarderfromaninstaller
- https://docs.splunk.com/Documentation/Forwarder/9.0.4/Forwarder/Configuretheuniversalforwarder
 
