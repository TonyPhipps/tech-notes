# Baseline Search
- Build a lookup that stores the average logon times for each user.
- Ran every week
- NOTE: You may have to split the search into 4 different ones, one per week, to get the initial baseline established. If you do, here is an example of changes to likes 1 and an inserted line after line 4 (the first stats command). Worst case scenario, you may need to increment at a smaller window.
```sql
... earliest=-14d@d latest=-@7d
...
| inputlookup append=t user_logon_boundary_baselines.csv
```

```sql
index=indexes-* sourcetype=*WinEventLog Channel=Security EventCode=4624 Logon_Type=2 NOT (user IN ("*$", "dwm-*", "umfd-*")) earliest=-30d@d latest=@d 
| fields _time, user, index 
| eval 
    date = relative_time(_time, "@d"),
    total_mins = round((_time - date) / 60)
| stats min(total_mins) as first_logon_min, max(total_mins) as last_logon_min by user, index, date 
| stats avg(first_logon_min) as avg_first_logon_min, 
        avg(last_logon_min) as avg_last_logon_min, 
        dc(date) as days_worked by user, index 
| eval 
    avg_first_logon = substr(tostring(round(avg_first_logon_min * 60), "duration"), 1, 5),
    avg_last_logon = substr(tostring(round(avg_last_logon_min * 60), "duration"), 1, 5)
| fields user, index, avg_first_logon, avg_last_logon, days_worked
| outputlookup user_logon_boundary_baseline.csv ```create_context=user```
```


# Detection Search
- Every 30min, review all user logons and compare them to the lookup. Allow for logons to fall an hour before or after their average. Show anything outside the widened window.
- Earliest time: 0
- Latest Time: +1y
- Run on Schedule:
  - Cron Expression: */30 * * * *
  - Schedule Window: Auto
```sql
index=indexes-* sourcetype=*WinEventLog EventCode=4624 Logon_Type=2 (Logon_Process="User32" OR Logon_Process="Winlogon") _index_earliest=-32m@m _index_latest=-2m@m
| fields _time, user, index
| eval 
    logon_sec = _time - relative_time(_time, "@d"),
    logon_time = strftime(_time, "%Y-%m-%dT%H:%M:%SZ")
| lookup user_logon_boundary_baseline.csv user, index OUTPUT avg_first_logon, avg_last_logon
| where isnotnull(avg_first_logon)
| eval 
    first_hour = tonumber(substr(avg_first_logon, 1, 2)),
    first_min  = tonumber(substr(avg_first_logon, 4, 2)),
    last_hour = tonumber(substr(avg_last_logon, 1, 2)),
    last_min  = tonumber(substr(avg_last_logon, 4, 2)),
    avg_first_sec = (first_hour * 3600) + (first_min * 60),
    avg_last_sec = (last_hour * 3600) + (last_min * 60),
    earliest_sec = avg_first_sec - 3600, ```devation +/- 1hr```
    latest_sec = avg_last_sec + 3600 ```devation +/- 1hr```
| where (logon_sec < earliest_sec OR logon_sec > latest_sec)
| eval 
    win_start = substr(tostring(max(0, earliest_sec), "duration"), 1, 5),
    win_end = substr(tostring(min(86399, latest_sec), "duration"), 1, 5),
    normal_window = win_start . " to " . win_end
| stats list(logon_time) as logon_times count by index, user, normal_window
| fields index, user, normal_window, logon_times
```