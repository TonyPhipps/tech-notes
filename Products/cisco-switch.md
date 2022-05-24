## Show basic device info
```
show version
```

### Show configuration
```
show running-config 
```

### SPAN one VLAN to one Port
```
enable
configuration terminal
interface fastethernet 12/0/15

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
