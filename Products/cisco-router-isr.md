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

### Show File System contents
```
dir /all /recursive
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


### Upgrade IOS
Upgrade a Cisco ISR Router, using a  1921 in this sample

<details>

- show version (get memory size)

```	
Router> show version
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
Router# dir

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
Router# copy tftp flash0

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
Router# enable
Router# configure terminal
Router(config)# no boot system
Router(config)# boot system usbflash0:c1900-universalk9-mz.SPA.158-3.M7.bin
Router(config)# boot system usbflash0:c1900-universalk9-mz.SPA.157-3.M9.bin
Router(config)# exit
Router# copy run start

Destination filename [startup-config]?

Building configuration...
[OK]
```
		
- Cross your fingers and reboot

```
Router# reload

Proceed with reload? [confirm]

*Apr  3 17:57:30.996: %SYS-5-RELOAD: Reload requested by console. Reload Reason: Reload Command.
…

Router# show version
```

</details>

### Install and Configure Anyconnect/Secure Client

<details>

- Get Cisco Secure Client
https://software.cisco.com/download/home/286330811/type/282364313/release/5.0.01242?i=!pp

- Setup a tftp server and host the file
https://www.solarwinds.com/free-tools/free-tftp-server

- Pull the file via copy command

```
Router# mkdir webvpn
Router# copy tftp: usbflash0:/webvpn/

Address or name of remote host [192.168.1.123]?
Source filename [cisco-secure-client-win-5.0.01242-webdeploy-k9.pkg]?
Destination filename [/webvpn/cisco-secure-client-win-5.0.01242-webdeploy-k9.pkg]?

Accessing tftp://192.168.1.123/cisco-secure-client-win-5.0.01242-webdeploy-k9.pkg...
Loading cisco-secure-client-win-5.0.01242-webdeploy-k9.pkg from 192.168.1.123 (via GigabitEthernet0/0): !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
[OK - 95816631 bytes]
		
95816631 bytes copied in 148.748 secs (644154 bytes/sec)
```

- Enable the package

```
Router# config t

Enter configuration commands, one per line.  End with CNTL/Z.

Router(config)# crypto vpn anyconnect usbflash0:/webvpn/cisco-secure-client-win-5.0.01242-webdeploy-k9.pkg sequence 1

(be patient, this can take several minutes)
SSLVPN Package SSL-VPN-Client (seq:1): installed successfully
```

- Generate RSA Keypair and Self-Signed Certificate

```
Router# conf t

Enter configuration commands, one per line.  End with CNTL/Z.

Router(config)# crypto key generate rsa label SSLVPN_KEYPAIR modulus 2048

The name for the keys will be: SSLVPN_KEYPAIR

% The key modulus size is 2048 bits
% Generating 2048 bit RSA keys, keys will be non-exportable...
[OK] (elapsed time was 14 seconds)

Router(config)# end
Router# show crypto key mypubkey rsa SSLVPN_KEYPAIR

% Key pair was generated at: 21:37:53 UTC Apr 3 2023
Key name: SSLVPN_KEYPAIR
Key type: RSA KEYS
  Storage Device: not specified
  Usage: General Purpose Key
  Key is not exportable.
  Key Data:
  ........ 300D0609 2A864886 F70D0101 01050003 82010F00 3082010A 02820101
  00D78E95 31B39C4B B018AF94 2116FFCB 34B807DE 6829278C 53A5C3D9 AD4E514B
  80963E3E CC663B42 2F08D766 A4E0883E AAB9C7BA B31865EE BC670F35 B2A1A307
  6CF42B40 63A64019 7439E368 06430CC8 61DFD16A D58235DB E207B8F8 4FC0931B
  E1D48852 EB588923 349AF5C2 ........ B3BEF2B5 D0A39091 AC8E94A6 909FD55A
  C94E3250 0C7D4DFB C6EF03C0 1B3112D4 208DA2C2 0628B7E9 61999F1A 4B13C143
  599B414A 94BA19A9 0D40FF13 636507D6 9E3E8C66 22C06107 22D23AE9 74E6035A
  E0026BF8 07357F3C 9BE5B73C F52BDA70 016BD8CB B30584F3 26054FC9 95020FD9
  6889258C 6F52DF39 EE0C7203 30377434 CBF11EFE A094C9C4 D01A62EF ........
77020301 0001
```

- Configure a PKI Trustpoint

```
Router# config t

Enter configuration commands, one per line.  End with CNTL/Z.

Router(config)# crypto pki trustpoint SSLVPN_CERT
Router(ca-trustpoint)# enrollment selfsigned
Router(ca-trustpoint)# subject-name CN=myvpn
Router(ca-trustpoint)# rsakeypair  SSLVPN_KEYPAIR
```

- Generate the Certificate

```
Router(config)#crypto pki enroll SSLVPN_CERT
% Include the router serial number in the subject name? [yes/no]: no
% Include an IP address in the subject name? [no]: yes
(give the IP Address)
Generate Self Signed Router Certificate? [yes/no]: yes

Router Self Signed Certificate successfully created
```	

- Validate Certificate Creation

```
Router# show crypto pki certificates SSLVPN_CERT

Router Self-Signed Certificate
  Status: Available
  Certificate Serial Number (hex): 02
  Certificate Usage: General Purpose
  Issuer:
    hostname=Router.domain
    cn=myvpn
  Subject:
    Name: Router.domain
    hostname=Router.domain
    cn=myvpn
  Validity Date:
    start date: 21:44:06 UTC Apr 3 2023
    end   date: 00:00:00 UTC Jan 1 2030
Associated Trustpoints: SSLVPN_CERT
```

- Enable HTTPS Server

```
Router# conf t

Enter configuration commands, one per line.  End with CNTL/Z.

Router(config)# ip http secure-server

CRYPTO_PKI: setting trustpoint policy TP-self-signed-806861376 to use keypair TP-self-signed-806861376% Generating 1024 bit RSA keys, keys will be non-exportable...
[OK] (elapsed time was 2 seconds)

*Apr  3 20:46:30.247: %SSH-5-ENABLED: SSH 1.99 has been enabled
*Apr  3 20:46:30.367: %PKI-4-NOCONFIGAUTOSAVE: Configuration was modified.  Issue "write memory" to save new IOS PKI configuration

Router(config)# ip http authentication local
```

- Setup AAA Local and add a user

```
Router(config)# aaa new-model
Router(config)# aaa auth
Router(config)# aaa authentication login SSLVPN_AAA local
Router(config)# username admin privilege 15 secret aGoodPassword
```

- Define VPN Address Pool and an Access List to associate with it later in the webvpn context policy.

```
ip local pool SSLVPN_POOL 192.168.10.1 192.168.10.10
access-list 1 permit 192.168.0.0 0.0.255.255
```

- Configure Loopback 0 and a Virtual-Template Interface (VTI)

```
Router(config)# int loopback 0
*Apr  3 22:01:07.795: %LINEPROTO-5-UPDOWN: Line protocol on Interface Loopback0, changed state to up
Router(config-if)# ip add 192.168.1.1 255.255.255.255

Router(config)# int Virtual-template 1
Router(config-if)# ip unnumbered Loopback 0
```

- Configure WebVPN Gateway

The IP set here will be what the Secure Client will be given to connect to.

```
Router(config)# webvpn gateway SSLVPN_GATEWAY
Router(config-webvpn-gateway)# ip address 123.123.123.123 port 443
Router(config-webvpn-gateway)# http-redirect port 80
Router(config-webvpn-gateway)# ssl trustpoint SSLVPN_CERT
Router(config-webvpn-gateway)# inservice
```

- Configure WebVPN Gateway, Context, and Group Policy

```
Router(config)# webvpn context SSL_Context
Router(config-webvpn-context)# gateway SSLVPN_Gateway
Router(config-webvpn-context)# virtual-template 1
Router(config-webvpn-context)# inservice
Router(config-webvpn-context)# aaa authentication list SSLVPN_AAA
Router(config-webvpn-context)# policy group SSL_Policy
Router(config-webvpn-group)# functions svc-enabled
Router(config-webvpn-group)# svc address-pool "SSLVPN_POOL" netmask 255.255.255.0
Router(config-webvpn-group)# svc split include acl 1
Router(config-webvpn-group)# svc dns-server primary 8.8.8.8
Router(config-webvpn-group)# exit
Router(config-webvpn-context)# default-group-policy SSL_Policy
```

</details>