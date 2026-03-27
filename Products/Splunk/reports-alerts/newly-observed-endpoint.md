Run this once to create the lookup
NOTE: It is recommended to reuse the lookup list in [endpoint-logs-lost.md](endpoint-logs-lost.md) as a base.
```sql
| tstats min(_time) as first_seen, max(_time) as last_seen where index=* BY index, host
| outputlookup last_seen_inventory.csv create_context=user
```

Detection
NOTE: If also running the detection in [endpoint-logs-lost.md](endpoint-logs-lost.md), ensure this one runs BEFORE that one.
```sql
| tstats min(_time) as first_seen, latest(_time) as latest_seen where index=* earliest=-24h BY index, host
| inputlookup append=t last_seen_inventory.csv
| stats min(first_seen) as first_seen, max(latest_seen) as last_seen by index, host
| outputlookup last_seen_inventory.csv
| eval status = case(
    first_seen >= relative_time(now(), "-24h"), "NEW_ENDPOINT",
    last_seen <= relative_time(now(), "-4d"), "SILENT_ENDPOINT",
    1=1, "ACTIVE")
| where status != "ACTIVE"
| eval last_seen_date = strftime(last_seen, "%Y-%m-%d %H:%M:%S")
| table status, index, host, last_seen_date
| sort - status
```
