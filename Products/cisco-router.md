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
