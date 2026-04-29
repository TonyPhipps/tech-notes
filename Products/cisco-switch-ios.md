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

! --- Interface Setup ---
interface Loopback0
 ip address 192.168.1.x 255.255.255.255
 no shutdown
exit

! --- Resiliency & Auto-Recovery ---
errdisable recovery cause all
errdisable recovery interval 300

! --- Global Service Optimization ---
service sequence-numbers
service timestamps log datetime show-timezone msec

! --- Logging Core Configuration ---
logging origin-id hostname
logging trap informational
logging host 192.168.1.x
logging facility local7
logging source-interface loopback0
logging userinfo

! --- Performance & CPU Protection ---
logging buffered 512000
logging rate-limit console 10
logging rate-limit 100
no logging console
logging on

! --- Verification & Save ---
end
show logging
show ip interface brief | include Loopback0
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

# MAC Security

## Review Port Security Status
```
show port-security interface <interface_id>
```

## Clear MAC Port Shutdown Error
For if MAC security is set to administratively disable
```
conf t
interface <interface_id>
 shutdown
 no shutdown
exit
```

## Update MAC Port Security with New MAC
`clear port-security dynamic`

OR

```
conf t
interface <interface_id>
 no switchport port-security
 no switchport port-security mac-address sticky
 switchport port-security mac-address sticky
exit
```

## Bump Up MACs for a Port to 2
```
conf t
interface <interface_id>
 switchport port-security maximum 2
exit
```