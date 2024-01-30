#### Parameters Quick Refernce
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

#### Exclude an IP or range
```
-- exclude 192.168.1.2
-- exclude 10.10.1.0/24
-- excludefile outofscope.csv
```

#### Scan a website for use of weak ciphers
```
.\nmap -sV --script ssl-enum-ciphers target.domain.com
```

#### Fast ping Sweep
```
nmap -sn -R -T5 --min-hostgroup 256 --min-parallelism 64 --max-retries 1 --min-rate 9000 -iL hosts.txt -oA c:\temp\output_20%y-%m-%d_%H%Mhrs --webxml
```

#### Fast Service Scan, skip discovery
```
.\nmap -sS -sV -R -F -Pn -T5 --min-hostgroup 256 --min-parallelism 64 --version-intensity 2 --max-retries 1 --min-rate 7000 -iL c:\temp\2017-03-17.txt -oA c:\temp\output_20%y-%m-%d_%H%Mhrs --webxml
```

#### Fast Host OS Discovery (this one for monthly stage 2)
```
nmap -sS -sV -R -O --osscan-guess -T5 --min-hostgroup 256 --min-parallelism 64 --version-intensity 2 --max-os-tries 1 --max-retries 1 --min-rate 7000 -iL /home/myuser/nmap/hosts/subnets-all.txt -oA c:\temp\output_20%y-%m-%d_%H%Mhrs --webxml
```

#### Parse to CSV
```
dir *.xml | .\parse-nmap.ps1 | export-csv output.csv
```

#### Use on Linux via SSH
- Prepend with "nohup sudo " to avoid ssh closing and to run as admin.
- Append with " > /dev/null 2>&1 &" to see progress on screen.
- monitor via:
```
top -p `pgrep -d ',' "nmap"`
```
