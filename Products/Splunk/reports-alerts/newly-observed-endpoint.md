# Simple Approach
- This specific example basically says "show me hosts that were not observed in the last 7d."
- Most efficient in larger datasets using lookup tables
```sql
| inputlookup historical_hosts.csv 
| append [ search index=* earliest=-1d@d latest=now | stats count by host ] 
| stats count by host 
| where count=1 
| fields host
```

# Lookup-Based Approach
Run this once to bootstrap/create the lookup
- Ensure the time range is something far back, like -90d
```sql
| tstats min(_time) as first_seen, latest(_time) as last_seen where index=ics-* BY index, host
| eval host=if(match(host, "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$"), host, upper(replace(host, "\..*$", "")))
| stats min(first_seen) as first_seen, max(last_seen) as last_seen by index, host
| outputlookup ics_last_seen_inventory.csv create_context=user
```

Run this as a daily search to update the lookup list
```sql
| tstats min(_time) as first_seen, latest(_time) as last_seen where index=ics-* earliest=-24h BY index, host 
| inputlookup append=t last_seen_inventory.csv 
| eval host=if(match(host, "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$"), host, upper(replace(host, "\..*$", "")))
| stats min(first_seen) as first_seen, max(last_seen) as last_seen by index, host
| where last_seen > relative_time(now(), "-90d")
| outputlookup last_seen_inventory.csv
```

Run this as a daily search to produce a detection

```sql
| inputlookup last_seen_inventory.csv
| eval status = case( 
    first_seen >= relative_time(now(), "-24h"), "NEW_ENDPOINT", 
    last_seen <= relative_time(now(), "-4d"), "SILENT_ENDPOINT", 
    1=1, "ACTIVE") 
| where status = "NEW_ENDPOINT"
| eval last_seen_date = strftime(last_seen, "%Y-%m-%d %H:%M:%S") 
| table status, index, host, last_seen_date 
| sort - status 
| eval source="last_seen_inventory.csv", sourcetype="-", _time=last_seen_date
```

