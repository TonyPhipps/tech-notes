```sql
index=* sourcetype="WinEventLog" ((source="WinEventLog:Security" EventCode=1100) OR (source="WinEventLog:System" EventCode=1074))
| eval host=replace(host, "\..*", "")
| eval is_service_stop = if(EventCode==1100, 1, 0)
| eval is_sys_shutdown = if(EventCode==1074, 1, 0)
| bin _time span=5m
| stats 
    sum(is_service_stop) as StopCount, 
    sum(is_sys_shutdown) as ShutdownCount, 
    latest(_time) as LastSeen
    by host, _time
| where StopCount > 0 AND ShutdownCount == 0
```