# Syslog

## System
This feed houses DHCP logs.

```
FUTURE_USE, receive_time, serial, type, subtype, FUTURE_USE, time_generated, vsys, eventid, object, FUTURE_USE, FUTURE_USE, module, severity, opaque, seqno, actionflags, dg_hier_level_1, dg_hier_level_2, dg_hier_level_3, dg_hier_level_4, vsys_name, device_name
```

## Traffic
```
FUTURE_USE, receive_time, serial, type, subtype, FUTURE_USE, time_generated, src, dst, natsrc, natdst, rule, srcuser, dstuser, app, vsys, from, to, inbound_if, outbound_if, logset, FUTURE_USE, sessionid, repeatcnt, sport, dport, natsport, natdport, flags, proto, action, bytes, bytes_sent, bytes_received, packets, start, elapsed, category, FUTURE_USE, seqno, actionflags, srcloc, dstloc, FUTURE_USE, pkts_sent, pkts_received, session_end_reason, dg_hier_level_1 to dg_hier_level_4, vsys_name, device_name, action_source, src_uuid, dst_uuid, tunnelid/imsi, monitortag/imei, parent_session_id, parent_start_time, tunnel, assoc_id, chunks, chunks_sent, chunks_received, rule_uuid, HTTP/2 Connection, link_change_count, policy_id, link_switches, sdwan_cluster, sdwan_device_type, sdwan_cluster_type, sdwan_site, dynusergroup_name
```
- https://docs.paloaltonetworks.com/pan-os/9-1/pan-os-admin/monitoring/use-syslog-for-monitoring/syslog-field-descriptions/traffic-log-fields

# Misc
- Name the Logging Profile "default" to have it added to all future firewall rules by default


# GUI Interface

## Restrict Access to Management Interface
- Device > Setup > Interfaces > Management Interface > Set Permitted IP Address ranges

## Enable Logging of Admin Activity
- Device > Setup > Management > Logging and Reporting Settings > Gear Icon > Log Export and Reporting > Log Admin Activity > Debug and Operational Commands + UI Actions

## Import & Export Config Files
- Device > Setup > Operations > Import named configuration snapshot
  - find xml
- Device > Setup > Operations > Load Named configuration snapshot
- The uploaded config is now the "candidate config"
Commit > Commit all changes

## Generate a New Self-Signed Root Certificate Authority Certificate
Generate a self-signed certificate on a new device to avoid using the default signature to manage the firewall.
- Device > Certificate Management > Certificates
  - Click Generate at the bottom edge of the screen
  - Provide a Certificate Name, Common Name
  - Check Certificate Authortiy
  - Change other options as needed
  - Click Generate
  - Perform a Commit
- Device > Setup > Management > General Settings
  - SSL/TLS Service Profile > New
    - Provide a Name and select the Certificate generated earlier
    - Set Min Version to TLSv1.2
    - OK
  - Select the SSL/TLS Service Profile just created
  - OK
- Perform a Commit

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
