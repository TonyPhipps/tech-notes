# Capture packets with a filter on IP and port
```
tcpdump -i eth0 -n -vvv port 1024 and host 1.1.1.1 -w capture.pcap
```

# Live monitor packets without resolving names (passive)
```
tcpdump -i eth0 -n
```






