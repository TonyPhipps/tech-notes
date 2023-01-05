# Console Commands

## Show System Info

To see the Management Interface's IP address, netmask, default gateway settings:

```show system info```

example output
```
hostname: anuragFW
ip-address: 10.21.56.125
netmask: 255.255.255.0
default-gateway: 10.21.56.1
ip-assignment: static
ipv6-address: unknown
ipv6-link-local-address: fe80::20c:0000:0000:0000/64
ipv6-default-gateway:
mac-address: 00:0c:29:00:00:00
time: Wed Aug 2 17:45:41 2017
uptime: 0 days, 14:07:01
family: vm
model: PA-VM
serial: 0070000000001
vm-mac-base: 00:1B:17:00:00:00
vm-mac-count: 256
vm-uuid: 00000000-0000-0000-0000-000000000000
vm-cpuid: 000000000000000
vm-license: VM-100
vm-mode: VMWare ESXi
sw-version: 8.0.4
global-protect-client-package-version: 4.0.2
app-version: 718-4138
app-release-date: 2017/07/25 14:09:19
av-version: 2322-2813
av-release-date: 2017/08/01 04:02:33
threat-version: 718-4138
threat-release-date: 2017/07/25 14:09:19
wf-private-version: 0
wf-private-release-date: unknown
url-db: paloaltonetworks
wildfire-version: 162343-164248
wildfire-release-date: 2017/08/02 04:27:02
url-filtering-version: 20170801.40146
global-protect-datafile-version: 1501612802
global-protect-datafile-release-date: 2017/08/02 00:10:02
global-protect-clientless-vpn-version: 64-85
global-protect-clientless-vpn-release-date: 2017/07/05 09:23:38
logdb-version: 8.0.16
platform-family: vm
vpn-disable-mode: off
multi-vsys: off
operational-mode: normal
```

## Show Interface Info

To see the interface level details such as speed, duplex, etc.:

```
show interface management
```

Sample Output:

```
-------------------------------------------------------------------------------
Name: Management Interface
Link status:
 Runtime link speed/duplex/state: unknown/unknown/up
 Configured link speed/duplex/state: auto/auto/auto
MAC address:
 Port MAC address 00:0c:29:00:00:00

Ip address: 10.21.56.125
Netmask: 255.255.255.0
Default gateway: 10.21.56.1
Ipv6 address: unknown
Ipv6 link local address: fe80::20c:0000:0000:0000/64
Ipv6 default gateway:
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
Logical interface counters:
-------------------------------------------------------------------------------
bytes received                   250891661
bytes transmitted                56986084
packets received                 855754
packets transmitted              218444
receive errors                   0
transmit errors                  0
receive packets dropped          55276
transmit packets dropped         0
multicast packets received       56
-------------------------------------------------------------------------------
```

## Show ARP Management

To check the ARP information on the Management Interface:

```
show arp management
```

Example output

```
Address         HWtype     HWaddress           Flags Mask   Iface
10.21.56.59     ether      01:00:00:00:00:00   C            eth0
10.21.57.125    ether      02:00:00:00:00:00   C            eth0
10.21.56.1      ether      03:00:00:00:00:00   C            eth0
10.21.56.143    ether      04:00:00:00:00:00   C            eth0
10.21.56.14     ether      05:00:00:00:00:00   C            eth0
```
