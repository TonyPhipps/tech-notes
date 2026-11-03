This use case stores a log of last observed event for all hosts and alerts on those that haven't been "seen" for 4 days. Hosts expire after 90d.

Run this once to bootstrap/create the lookup
- Ensure the time range is something far back, like -90d
```sql
| tstats min(_time) as first_seen, latest(_time) as last_seen where index=ics-* BY index, host
| eval host=if(match(host, "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$"), host, upper(replace(host, "\..*$", "")))
| stats min(first_seen) as first_seen, max(last_seen) as last_seen by index, host
| eval first_seen_date = strftime(first_seen, "%Y-%m-%dT%H:%M:%S"),
       last_seen_date = strftime(last_seen, "%Y-%m-%dT%H:%M:%S")
| outputlookup ics_last_seen_inventory.csv create_context=user
```

Run this as a daily search to update the lookup list
```sql
| tstats min(_time) as first_seen, latest(_time) as last_seen where index=ics-* earliest=-24h BY index, host 
| inputlookup append=t last_seen_inventory.csv 
| eval host=if(match(host, "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$"), host, upper(replace(host, "\..*$", "")))
| stats min(first_seen) as first_seen, max(last_seen) as last_seen by index, host
| where last_seen > relative_time(now(), "-90d")
| eval first_seen_date = strftime(first_seen, "%Y-%m-%dT%H:%M:%S"),
       last_seen_date = strftime(last_seen, "%Y-%m-%dT%H:%M:%S")
| outputlookup last_seen_inventory.csv
```

Run this detection search daily:
```sql
| inputlookup last_seen_inventory.csv
| eval days_since_seen = round((now() - last_seen) / 86400, 2)
| where days_since_seen >= 4
| eval first_seen_date = strftime(first_seen, "%Y-%m-%dT%H:%M:%S"),
       last_seen_date = strftime(last_seen, "%Y-%m-%dT%H:%M:%S")
| table index, host, first_seen_date, last_seen_date, days_since_seen
| sort - days_since_seen
| eval source="last_seen_inventory.csv", sourcetype="-", _time=last_seen_date
```