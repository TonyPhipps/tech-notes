# Investigate Crashs
Errors and fatals in the lead-up to a crash
```sql
index=_internal source=*splunkd.log (log_level=ERROR OR log_level=FATAL OR log_level=WARN)
| sort 0 - _time
| table _time host log_level component event_message
```

Find crash events / restarts
```sql
index=_internal source=*splunkd.log ("Interrupt signal received" OR "Died" OR "Shutting down" OR "splunkd started" OR "SIGSEGV" OR "assertion" OR "terminate")
| sort 0 _time
| table _time host component event_message
```

 Out-of-memory / process kills (very common "unexpected crash" cause)
 ```sql
index=_internal source=*splunkd.log ("out of memory" OR "oom" OR "cannot allocate" OR "bad_alloc" OR "workload" OR "memory limit")
| table _time host component event_message
 ```

Memory usage trend around the crash (_introspection)
```sql
index=_introspection component=PerProcess data.process=splunkd
| eval mem_MB = round('data.mem_used', 2)
| timechart span=1m max(mem_MB) as MaxMem_MB by host
```

Host-wide resource usage, incl. the I/O the health panel flagged
```sql
index=_introspection component=Hostwide
| timechart span=1m avg(data.cpu_system_pct) as sys_cpu avg(data.cpu_user_pct) as user_cpu avg(data.mem_used) as mem_used
```

Per-CPU IOWait specifically (ties back to your original warning)
```sql
index=_introspection component=Hostwide
| timechart span=1m avg(data.cpu_idle_pct) as idle max(data.cpu_iowait_pct) as max_iowait avg(data.cpu_iowait_pct) as avg_iowait
```

Disk space / IO stats per partition
```sql
index=_introspection component=IOStats
| timechart span=1m avg(data.reads_ps) as reads avg(data.writes_ps) as writes avg(data.avg_service_ms) as svc_ms by data.mount_point
```

Confirm the crash gaps visually (uptime heartbeat)
 ```sql
 index=_internal source=*metrics.log group=pipeline
| timechart span=1m count by host
 ```

Bucket / index corruption or fsck errors (I/O crashes often corrupt buckets)
```sql
index=_internal source=*splunkd.log (component=DatabaseDirectoryManager OR component=BucketMover OR "fsck" OR "corrupt" OR "rawdata" OR "journal")
| table _time host component event_message
```

Config or startup errors (if it crashes at/after restart specifically)
```sql
index=_internal source=*splunkd.log (component=UiHttpListener OR component=loader OR "Cannot bind" OR "port" OR "license" OR "TcpInputProc")
| table _time host component event_message
```

Biggest memory-consuming search processes 
```sql
index=_introspection component=PerProcess host=yoursearchhead data.process=splunkd data.search_props.sid=*
| eval mem_MB=round('data.mem_used',1)
| stats max(mem_MB) as peak_MB values(data.search_props.type) as type values(data.search_props.app) as app values(data.search_props.user) as user by data.search_props.sid
| sort - peak_MB
| head 30
```

What searches were actually running 
```sql
index=_audit host=yoursearchhead action=search (info=granted OR info=completed)
| eval sid=coalesce(search_id, sid)
| table _time user app search_id savedsearch_name total_run_time scan_count event_count search
| sort - total_run_time
```

Search concurrency over time
```sql
index=_internal source=*metrics.log host=yoursearchhead group=search_concurrency
| timechart span=1m max(active_hist_searches) as historical max(active_realtime_searches) as realtime
```

Accelerated data model rebuilds/summarization running at crash time
```sql
index=_internal source=*scheduler.log host=IBRSACLXSRH310.bor.doi.net savedsearch_name="_ACCELERATE_*"
| eval run_min=round(run_time/60,1)
| table _time savedsearch_name status run_min result_count
| sort - _time
```



# Check who service is running as
Note that the service will NOT run properly without extra permissions beyond a simple "sudoers" group add.
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

# Duplicate Data
Determine if a source has duplicate events
```sql
index=theindex sourcetype=thesource
| eval delay = _indextime - _time 
| eval indextime=strftime(_indextime,"%Y-%m-%d %H:%M:%S") 
| stats count, values(source) as sources, values(sourcetype) as sourcetypes values(delay) as delays values(indextime) as indextimes by _raw _time 
| table sources, sourcetypes, count, delays, _time indextimes _raw 
| sort -count
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