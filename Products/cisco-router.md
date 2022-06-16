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

### Create a user with encrypted password
```
username john privilege 15 secret GoodPassword
```

### Remove a user
```
no username john
```

### ACL
- Each inbound and outbound ACL should end in ```deny any any log```

Show ARP Table
```
show arp
```
