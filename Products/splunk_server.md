# Quick First Time Install Guide

## Ensure curl package is installed
```
apt install curl
```

## Install Splunk
```
dpkg -i splunk_package_name.deb
dpkg --status splunk
```

## Start
For the first time, best to run as root just to test things out.
```
su -
/opt/splunk/bin/splunk start
```

- Configuration is typically done via the web interface, but browsers are not allowed to run on servers with administrative accounts (ie, the accounts we always use on our server)
- Splunk uses port 8000 for it's web interface, so from your local workstation, browse to http://servername:8000 to interact with the web GUI
- The command Line Interface works from the server.
- Don't forget to register for a Splunk Developer license and apply it
  - https://dev.splunk.com/enterprise/dev_license/
  - Settings > System > Licensing
  - Then restart via ```/opt/splunk/bin/splunk restart```

## Configure Splunk to Run as a Service at Bootup
Run this
```/opt/splunk/bin/splunk enable boot-start```

Give the target account rights to the installation folder
```chown -R bob $SPLUNK_HOME```

edit ```/etc/init.d/splunk```
after ```RETVAL=0``` add ```USER=bob```




## Create Indexes
Consider creating an index for each log pipeline
- Settings > Indexes > New Index
Be mindful of  Max Size of Entire Index, as this will control rollover times. Lower dramatically for lab environment.

## Setup a Receiving Indexer
Set this up in order to receive logs, like from a Universal Forwarder.
- Settings > Forwarding and Receiving
- Receive Data > Configure Receiving
- New Receiving Port > 9997 > Save

## Setup a Deployment Server
Use this to manage apps of clients, like Universal Forwarder apps.
- Copy at least one app to \Splunk\etc\deployment-apps\
  - Ensure it's visible under Settings > Distributed Environment > Forwarder Management > Apps tab
  - Consider the need to "Restart Splunkd" in the App settings. This is likely necessary to check.
- Create a Server Class
  - Navigate to Settings > Distributed Environment > Forwarder Management > Apps tab
  - Find the app, and click Edit
  - Click Server Classes > \[+\] > New Server Class
  - Name it according to the group of clients, like "Unversal Forwarders"
  - Add the apps you wish to deploy/manage
  - Add clients - use "\*" to simply apply to any client that phones home.
- Updating an App
  - Simply editing the files in the app doesn't appear to push updates to clients. You may need to uninstall the App, then reinstall
    - Settings > Distributed Environment > Forwarder Management > Apps tab
    - Actions > Edit > Uninstall App
    - Wait for Apps Tab > Clients number to go down to where you need it (probably zero)
    - Actions > Edit > Edit > Server Classes > Add it back
  
# Automatically Ingest
Best done by managed systems.. heavy fowarders or UF's with apps. But you can edit the files under ```/opt/splunk/etc/system/local/``` and effectively treat the folder as an app running on the server.

Whether modifying inputs.conf or using commandline, restart the Splunk service OR reload the inputs config

```
./splunk _internal call /services/data/inputs/monitor/_reload -auth
```

# Manually Provide Logs
- Add an Uploader Role
- Navigate to Settings > Access Controls > Roles
- Add an "Uploader" role with the "input_file" capability.
- Leaving all other settings default, Save the role

# Field Extraction During Ingest
In ```$SPLUNK_HOME/etc/system/local/``` you can edit props.conf and transforms.conf, but it's usually best to manage this at the app level.
- ```props.conf``` will apply your configuration settings to your data while being indexed ([syntax](http://docs.splunk.com/Documentation/Splunk/latest/Admin/Propsconf), [KB](https://docs.splunk.com/Documentation/Splunk/latest/Knowledge/Configurecalculatedfieldswithprops.conf))
- ```transforms.conf``` contains settings and values that you can use to configure data transformations. ([syntax](https://docs.splunk.com/Documentation/Splunk/latest/Admin/Transformsconf), [KB](https://docs.splunk.com/Documentation/Splunk/latest/Knowledge/Configureadvancedextractionswithfieldtransforms))


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

# Troubleshoot
Check who service is running as. Note that the service will NOT run properly without extra permissions beyond a simple "sudoers" group add.
```
ps -ef | grep splunk
```

## Reload Inputs.conf
While in the Splunk dir (/opt/splunk/bin)
```
./splunk _internal call /services/data/inputs/monitor/_reload -auth
```
