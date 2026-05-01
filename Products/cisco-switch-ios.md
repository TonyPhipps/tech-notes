- [Show basic device info](#show-basic-device-info)
  - [Show configuration](#show-configuration)
  - [Show logs and logging information](#show-logs-and-logging-information)
  - [Review current "monitors"](#review-current-monitors)
  - [Show ARP Table](#show-arp-table)
- [SPANning](#spanning)
  - [SPAN one VLAN to one Port](#span-one-vlan-to-one-port)
  - [Clear SPAN / Monitoring](#clear-span--monitoring)
- [Save Config to NVRAM](#save-config-to-nvram)
- [Create Admin Account](#create-admin-account)
- [Setup NTP](#setup-ntp)
- [Setup Logging and Event Forwarding to Syslog Server](#setup-logging-and-event-forwarding-to-syslog-server)
- [Shutdown One or More Switchports](#shutdown-one-or-more-switchports)
- [Set Jumbo Frame Support to 9000 Bytes](#set-jumbo-frame-support-to-9000-bytes)
- [MAC Security](#mac-security)
  - [Review Port Security Status](#review-port-security-status)
  - [Clear MAC Port Shutdown Error](#clear-mac-port-shutdown-error)
  - [Update MAC Port Security with New MAC](#update-mac-port-security-with-new-mac)
  - [Bump Up MACs for a Port to 2](#bump-up-macs-for-a-port-to-2)


# Show basic device info
```bash
show version
```

## Show configuration
```bash
show running-config 
```

## Show logs and logging information
```bash
show logging
show logging onboard
```

## Review current "monitors"
```bash
show monitor
```

## Show ARP Table
```bash
show arp
```

# SPANning

## SPAN one VLAN to one Port
```bash
enable
configuration terminal
monitor session 1 source vlan 100
monitor session 1 destination interface gigabitethernet 1/0/24
end
```

## Clear SPAN / Monitoring
```bash
no monitor session 1
no monitor session all
```

# Save Config to NVRAM
```bash
copy running-config startup-config
```

# Create Admin Account
```bash
username admin privilege 15 algorithm type scrypt secret PASSWORD
```

# Setup NTP
```bash
enable
configure terminal

# Set local offset
clock timezone EST -5 0
clock summer-time EDT recurring

# Define ntp sources
ntp server 192.168.1.50

# Stability and Hardware Sync
ntp source loopback 0
ntp update-calendar

# Security: Only allow satellite to sync time
ip access-list standard ACL-NTP
 permit 192.168.1.50
ntp access-group peer ACL-NTP

exit

# Verification
show ntp associations detail
show ntp status
show clock detail
```


# Setup Logging and Event Forwarding to Syslog Server
```bash
enable
configure terminal

! --- Configuration Archiving & Local Backups ---
archive
 log config
  logging enable
  hidekeys
  notify syslog
 exit
 path flash:/backup-config
 maximum 14
 write-memory
exit

! --- Interface Setup ---
interface Loopback0
 ip address 10.x.x.x 255.255.255.255
 no shutdown
exit

! --- Syslog Heartbeat (Hourly check) ---
kron policy-list SyslogHeartBeat
 cli send log 6 heartbeat
exit
kron occurrence SyslogHeartBeat in 1:0 recurring
 policy-list SyslogHeartBeat
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
logging host 192.168.1.1
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
show run | inc log
show logging
show archive
copy running-config startup-config
```

# Shutdown One or More Switchports
```bash
interface gigabitethernet0/2
shutdown


interface range gigabitethernet0/2 - 24
shutdown
```

# Set Jumbo Frame Support to 9000 Bytes
(9000 bytes plus 14 byte header)
```bash
show system mtu
config t
system mtu jumbo bytes 9000
end
copy running-config startup-config
reload
```

# MAC Security

## Review Port Security Status
```bash
show port-security interface <interface_id>
```

## Clear MAC Port Shutdown Error
For if MAC security is set to administratively disable
```bash
conf t
interface <interface_id>
 shutdown
 no shutdown
exit
```

## Update MAC Port Security with New MAC
`clear port-security dynamic`

OR

```bash
conf t
interface <interface_id>
 no switchport port-security
 no switchport port-security mac-address sticky
 switchport port-security mac-address sticky
exit
```

## Bump Up MACs for a Port to 2
```bash
conf t
interface <interface_id>
 switchport port-security maximum 2
exit
```