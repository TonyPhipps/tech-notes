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

### SPAN one VLAN to one Port
```
enable
configuration terminal
monitor session 1 source vlan 100
monitor session 1 destination interface gigabitethernet1/0/23
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

### Create Admin Account
```
username admin privilege 15 secret PASSWORD
```

### Remove a user
```
no username admin
```

### ACL
- Each inbound and outbound ACL should end in ```deny any any log```

### Show ARP Table
```
show arp
```

### Disable Commonly Unused Services 
[STIG V-216557](https://www.stigviewer.com/stig/cisco_ios_router_rtr/2020-09-23/finding/V-216557)
```
no boot network
no ip boot server
no ip bootp server
no ip classless
no ip dns server
no ip identd
no ip finger
no ip http server
no ip rcmd rcp-enable
no ip rcmd rsh-enable
no service config
no service finger
no service tcp-small-servers
no service udp-small-servers
no service pad
```

### Disable VPN Aggressive Mode
Aggressive mode does not set up the initial encrypted connection used to protect the peer authentication. Negotiation is quicker, and the initiator and responder ID pass in the clear.
```
crypto isakmp aggressive-mode disable
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

### Record Console Commands to Syslog
```
event manager applet CLIaccounting
event cli pattern ".*" sync no skip no
action 1.0 syslog priority informational msg "$_cli_msg"
set 2.0 _exit_status 1
```
