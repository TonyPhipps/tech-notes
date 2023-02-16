# Windows

## Installation
- Best to check all the logs during installation rather than after installation.
  - The configuration file will be \etc\apps\SplunkUniversalFowarder\local\inputs.conf
- Set any user/password you like. This is to modify the configuration on the specific machine.
- Deployment Server - You should be able to confirm access to this port via web. e.g. http://server:8089 and get a response. 
  - The configuration file will be \etc\system\local\deploymentclient.conf
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

## Addons
- Copy app folders to \etc\apps\

References
- https://docs.splunk.com/Documentation/Forwarder/9.0.4/Forwarder/InstallaWindowsuniversalforwarderfromaninstaller
- https://docs.splunk.com/Documentation/Forwarder/9.0.4/Forwarder/Configuretheuniversalforwarder
 
