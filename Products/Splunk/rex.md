# Trim off FQDN, Leaving Only Hostname
```
| rex field=fqdn "(?<HostName>[^\.]+)\."
```