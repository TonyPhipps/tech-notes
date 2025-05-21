Note: windump uses the same commands.

### Capture packets with a filter on IP and port
```
tcpdump -i eth0 -n -vvv port 1024 and host 1.1.1.1 -w capture.pcap
```

### Live monitor packets without resolving names (passive)
```
tcpdump -i eth0 -n
```


### Capture to file
Run -D to see interfaces
Run a quick check to make sure you have the right interface.
Capture all traffic to capture.pcap, splitting into 10GB file sizes to allow later analysis (e.g. via Wireshark).
```
tcpdump -D
tcpdump -s 0 -i eth0
tcpdump -s 0 -i eth0 -w capture.pcap -C 10240
```


### Identify Non-Windows Pings
```
tcpdump -r capture.pcap -n -X 'icmp[0]=8 and not icmp[8:4]=0x61626364'
```

### Quick Check of Traffic on a Specific Port
tcpdump -vvv -i any port [####]