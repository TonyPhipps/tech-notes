- -O OS detection
- -n disables name resolution
- --reason shows nmap's reason for justifying its determinations on hosts/ports
- -sn skips port scanning after initial discovery
- -sT performs a full connect (others may hold up sensitive systems connections, like ICS/SCADA)
- -sV version detection
- -PS -send-ip tells Nmap to send IP level packets (rather than raw ethernet) even though it is a local network.

#### Basic Discovery on a sensitive network
```
nmap -PS -n -sn 1.2.3.0/24
```

#### Discover services and OS for IPs/networks in scope.csv and save in all formats to files named 'output'
- Ideal for an IT network where endpoints are unknown and need inventoried
```
nmap -iL scope.csv -O -T5 -sV -oA output
```

### Exclude an IP or range
-- exclude 192.168.1.2
-- exclude 10.10.1.0/24
-- excludefile outofscope.csv

