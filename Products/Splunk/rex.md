# Trim off FQDN, Leaving Only Hostname
```sql
| rex field=fqdn "(?<HostName>[^\.]+)\."
```