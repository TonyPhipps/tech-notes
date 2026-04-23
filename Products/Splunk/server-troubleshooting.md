Check who service is running as. Note that the service will NOT run properly without extra permissions beyond a simple "sudoers" group add.
```bash
ps -ef | grep splunk
```


# Ingestion
Review the settings for a conf file and see where the settings are merged from
```bash
splunk btool inputs list --debug
```


# Reload Inputs.conf
While in the Splunk dir (/opt/splunk/bin)
```bash
./splunk _internal call /services/data/inputs/monitor/_reload -auth
```


# Determine Cause of Input Issue
$SPLUNK_HOME defaults to /opt/splunk/
Replace [stanzaname] with your stanza's name.

```grep ERROR $SPLUNK_HOME/var/log/splunk/splunkd.log | grep [stanzaname]```


# Refresh Most Things
Like props.conf, transforms.conf, etc.
```
http://yourserver:8000/en-US/debug/refresh
```


# Power Failure Review

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


## Perform Splunk Searches

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


# Error-Based Troubleshooting


## splunkd.log

`$SPLUNK_HOME/var/log/splunk/splunkd.log`




### Error 161

For Example

`[0 MainThread] - Could not create path \\server\path appearing in indexes.conf: 161 `

The Splunk error code 161 is a system-level error provided by Windows (ERROR_BAD_PATHNAME). It indicates that the Splunk service is unable to locate or access the specific network path defined in an index.conf file.

- Cause: The path is no longer accessible for some reason. Server rename/replace/unavailable, NTFS or share permissions change, folder name or location change, or disk is now full, or something happened to the account Splunk is running as. This is a startup check, so the change may have occurred some time ago.
- Action 1: Search through your Splunk directory (typically $SPLUNK_HOME/etc/system/local/ or specific app directories) for the indexes.conf file. Ensure every homePath, coldPath, and thawedPath entry is updated to reflect the new UNC path.
- Action 2: Ensure the account running the Splunkd service has Full Control over the new network share and the NTFS folder permissions on the new file server.
- Action 3: Ensure there are no typos in the index.conf file, the share name, or the UNC path used.
- Action 4: While in the index.conf file, ensure the maxVolumeDataSizeMB property is set such that it won't allow Splunk to fill the hosting hard drive.
(`maxVolumeDataSizeMB = 200000` for 200 GB)