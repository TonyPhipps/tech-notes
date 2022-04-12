- -O OS detection
- -sV version detection
- -n disables name resolution
- --reason shows nmap's reason for justifying its determinations on hosts/ports
- -sT performs a full connect (others may hold up sensitive systems connections, like ICS/SCADA)

#### Discover services and OS for IPs/networks in scope.csv and save in all formats to files named 'output'
```nmap -iL scope.csv -O -T5 -sV -oA output```

### Exclude an IP or range
-- exclude 192.168.1.2
-- exclude 10.10.1.0/24
-- excludefile outofscope.csv

