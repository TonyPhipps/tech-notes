# Quick First Time Install Guide
Recommended **Lab** Specs
- Splunk Server - 1 CPU, 2GB RAM, 30GB hard drive


## Ensure curl package is installed
```bash
apt install curl
```


## Install Splunk
```bash
dpkg -i splunk_package_name.deb
dpkg --status splunk
```


## Start
For the first time, best to run as root just to test things out.
```bash
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
```bash
chown -R bob $SPLUNK_HOME
chmod -R 700 $SPLUNK_HOME
```

edit ```/etc/init.d/splunk```
after ```RETVAL=0``` add ```USER=bob```


## Create Indexes
Consider creating an index for each log pipeline
- Settings > Indexes > New Index
Be mindful of  Max Size of Entire Index, as this will control rollover times. Lower dramatically for lab environment.

NOTE: Ensure any indexes created have the appropriate permissions assigned the user running the service. e.g. ```chown -R bob /media/data/logs/pfsense/db```


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
  

# Ingest Logs
Best done by managed systems.. heavy fowarders or UF's with apps. But you can edit the files under ```/opt/splunk/etc/system/local/``` and effectively treat the folder as an app running on the server.

Whether modifying inputs.conf or using commandline, restart the Splunk service OR reload the inputs config

```
$SPLUNK_HOME/bin/splunk _internal call /services/data/inputs/monitor/_reload -auth
```

Verify edits made it in to live inputs via
```
$SPLUNK_HOME/bin/splunk btool inputs list --debug
```


## Receive Linux Logs
- Apps > Manage Apps > Browse More Apps
- Search for "linux"
- Splunk Add-on for Unix and Linux


## Syslog (UDP)
Conf approach
Edit ```$SPLUNK_HOME/etc/system/local/inputs.conf``` and add your input. After your inputs are added, Splunk will need to be restarted (or forced to reload inputs) to recognize these changes.
Sample inputs.conf:
```
[udp://515]
connection_host = ip
host = pfsense
index = pfsense
sourcetype = pfsense
no_appending_timestamp = true
```

Web GUI approach
Not recommended, but here's how...
- Settings > Data > Data Inputs
- UDP > Add New
- Provide Port, Source Name Override (optional), Only Accept Connection From (optional)
- Next
- Source Type: New (pfsense)
- Source Type Category: Custom
- Source Type Description: blank
- App Context: Search & Reporting (search) (this will add the input to ```$SPLUNK_HOME/etc/apps/search/local/inputs.conf```)
- Method: IP
- Index: set as needed
- Review > Submit
- Edit ```$SPLUNK_HOME/etc/apps/search/local/inputs.conf```
  - Add a line ```no_appending_timestamp = true``` to the udp stanza matching the one just created.
  - Reload inputs via ```./splunk _internal call /services/data/inputs/monitor/_reload -auth```


## Monitor a Folder
inputs.conf snippet depicting ingestion from the server itself at path /ingest
```
[monitor:///ingest]
disabled = false
host = splunk
index = kiwi
sourcetype = kiwisyslog
whitelist = .*\.txt
```

See https://docs.splunk.com/Documentation/Splunk/latest/Data/Monitorfilesanddirectorieswithinputs.conf


## Manually Provide Logs
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


# Recommended Apps
- Config Explorer
  - https://splunkbase.splunk.com/app/4353
  - https://github.com/ChrisYounger/config_explorer
 


# Troubleshoot
Check who service is running as. Note that the service will NOT run properly without extra permissions beyond a simple "sudoers" group add.
```bash
ps -ef | grep splunk
```


## Ingestion
Review the settings for a conf file and see where the settings are merged from
```bash
splunk btool inputs list --debug
```


## Reload Inputs.conf
While in the Splunk dir (/opt/splunk/bin)
```bash
./splunk _internal call /services/data/inputs/monitor/_reload -auth
```


## Determine Cause of Input Issue
$SPLUNK_HOME defaults to /opt/splunk/
Replace [stanzaname] with your stanza's name.

```grep ERROR $SPLUNK_HOME/var/log/splunk/splunkd.log | grep [stanzaname]```


## Refresh Most Things
Like props.conf, transforms.conf, etc.
```
http://yourserver:8000/en-US/debug/refresh
```

## Power Failure Review

Search ```$SPLUNK_HOME/var/log/splunk/splunkd.log``` for 
- "unclean shutdown detected" (Confirms Splunk knows it crashed).
- "fsck" (File System Consistency Check – Splunk might be silently repairing buckets in the background).
- "Corrupt bucket" or "bucket header is corrupted".
- "rebuild failed" (This is critical; it means a bucket is dead and needs manual intervention).

Search ```$SPLUNK_HOME/var/log/splunk/mongod.log``` for
- "WiredTiger metadata corruption detected" (This usually requires a manual wipe and resync of the KVStore).
- "mongod exited abnormally" (Look for exit code 14, which often means a lock file issue).
- "Detected unclean shutdown" (MongoDB will attempt recovery; watch this log to see if it succeeds).

Search ```$SPLUNK_HOME/var/log/splunk/metrics.log``` for
- "blocked=true" (Queues are filling up).
- "evt_misc_pipe::write_errors" (Pipeline errors).

Search ```$SPLUNK_HOME/var/log/splunk/web_service.log``` for
- "CherryPy" errors.
- "500 Internal Server Error" immediately upon login.

### Perform Splunk Searches

To find bucket corruption:
```sql
index=_internal source="*splunkd.log" log_level=ERROR (component=IndexProcessor OR component=BucketBuilder)
| stats count by host, message, component
```

To check if queues are blocked post-reboot:
```sql
index=_internal source="*metrics.log" group=queue blocked=true
| timechart span=10min max(max_size_kb) by name
```


# Apps
## Install App from File
- Apps > Manage Apps
- Install App From File

## Recommended Apps
- Config Explorer - https://apps.splunk.com/apps/id/config_explorer
  - Especially useful in a dev environment as you can access config files directly from the browser, rather than remoting in to the server.

