This use case stores a log of last observed event for all hosts and alerts on those that haven't been "seen" for 4 days. Hosts expire after 90d.

Run once:
```sql
| tstats latest(_time) as last_seen where index=* BY index, host
| outputlookup last_seen_inventory.csv create_context=user
```

Run this detection/maintenance search daily:
``sql
| tstats latest(_time) as latest_seen where index=* earliest=-24h BY index, host
| inputlookup append=t last_seen_inventory.csv
| stats max(latest_seen) as last_seen by index, host
| where last_seen > relative_time(now(), "-90d")
| outputlookup last_seen_inventory.csv
| eval days_since_seen = (now() - last_seen) / 86400
| where days_since_seen >= 4
| eval last_seen_date = strftime(last_seen, "%Y-%m-%d %H:%M:%S")
| table index, host, last_seen_date, days_since_seen
| sort - days_since_seen
```