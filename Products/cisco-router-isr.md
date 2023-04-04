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

### Show File System
```
dir /all
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


### Upgrade IOS
Upgrade a Cisco ISR Router, using a  1921 in this sample

<details>

- show version (get memory size)

```	
Router>show version
…
Cisco CISCO1921/K9 (revision 1.0) with 491520K/32768K bytes of memory.
Processor board ID FTX183784SA
2 Gigabit Ethernet interfaces
1 terminal line
1 Virtual Private Network (VPN) Module
DRAM configuration is 64 bits wide with parity disabled.
255K bytes of non-volatile configuration memory.
245744K bytes of USB Flash usbflash0 (Read/Write)
…
```
491520K + 32768 = 524288 / 1024 = 512 MB DRAM

- Check available space for the new ios.bin file

```
Router#dir
Directory of usbflash0:/

    1  -rw-          34   Apr 2 2023 01:17:48 +00:00  pnp-tech-time
    2  -rw-       99921   Apr 2 2023 01:18:00 +00:00  pnp-tech-discovery-summary
    3  -rw-    85054748  Oct 12 2021 04:34:44 +00:00  c1900-universalk9-mz.SPA.157-3.M9.bin
    4  -rw-    85053068  May 24 2021 05:44:30 +00:00  c1900-universalk9-mz.SPA.157-3.M8.bin

```
  - Ensure sufficient storage is available to hold incoming ios file
  - If space is needed, you can remove via ```delete [filename]```

- Set the appropriate interface to have an IP, or pull a DHCP addres

```
enable
configure terminal
int g0/0
ip address dhcp
```

- Start the tftp server, hosting the iso file
- Open the firewall or disable it temporarily
- Copy the file via 

```
copy tftp flash0
[ip address]
[filename]
[filename]
```

```
Router#copy tftp flash0
Address or name of remote host [192.168.1.123]?
Source filename [c1900-universalk9-mz.SPA.158-3.M7.bin]?
Destination filename [flash0]? c1900-universalk9-mz.SPA.158-3.M7.bin
Accessing tftp://192.168.1.123/c1900-universalk9-mz.SPA.158-3.M7.bin...
Loading c1900-universalk9-mz.SPA.158-3.M7.bin from 192.168.1.123 (via GigabitEthernet0/0): !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
[OK - 86844008 bytes]

86844008 bytes copied in 134.428 secs (646026 bytes/sec)
```
		
- Apply the new IOS.bin as startup image, with fallback to previous

```
Router#enable
Router#configure terminal
Router(config)#no boot system
Router(config)#boot system usbflash0:c1900-universalk9-mz.SPA.158-3.M7.bin
Router(config)#boot system usbflash0:c1900-universalk9-mz.SPA.157-3.M9.bin
Router(config)#exit
Router#copy run start
Destination filename [startup-config]?
Building configuration...
[OK]
Router#
```
		
- Cross your fingers and reboot

```
Router#reload
Proceed with reload? [confirm]

*Apr  3 17:57:30.996: %SYS-5-RELOAD: Reload requested by console. Reload Reason: Reload Command.
…
Router#show version
```

</details>
