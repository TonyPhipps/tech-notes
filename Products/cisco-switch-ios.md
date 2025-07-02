## Show basic device info
```
show version
```

### Show configuration
```
show running-config 
```

### Show logs and logging information
```
show logging
show logging onboard
```

### Log Configuration Commands
```
configure terminal
    archive
    log config
        logging enable
        hidekeys
        notify syslog
        exit
    exit
    logging buffered informational
    service timestamps log datetime
    logging host <syslog-server-IP>
exit
copy running-config startup-config
```


### SPAN one VLAN to one Port
```
enable
configuration terminal
monitor session 1 source vlan 100
monitor session 1 destination interface gigabitethernet 1/0/24
end
```

### Review current "monitors"
```
show monitor
```

### Clear SPAN / Monitoring
```
no monitor session 1
no monitor session all
```

### Save Config to NVRAM
```
copy running-config startup-config
```

### Show ARP Table
```
show arp
```

### Create Admin Account
```
username admin privilege 15 secret PASSWORD
```

### Setup Event Forwarding to Syslog Server
```
enable
configure terminal
service sequence-numbers
service timestamps log datetime localtime show-timezone msec
logging trap informational
logging 192.168.1.1
logging facility local2
logging source-interface loopback0
logging userinfo
logging on
end
show logging
copy running-config startup-config
```

### Shutdown One or More Switchports
```
interface gigabitethernet0/2
shutdown


interface range gigabitethernet0/2 - 24
shutdown
```

### Set Jumbo Frame Support to 9000 Bytes
(9000 bytes plus 14 byte header)
```
show system mtu
config t
system mtu jumbo bytes 9000
end
copy running-config startup-config
reload
```