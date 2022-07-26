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

