
# Wireless Access Point and Switch
- https://wiki.dd-wrt.com/wiki/index.php/Wireless_access_point

Note: Some browsers won't let you navigate to older DD-WRT web admin pages due to lack of https. Use Microsoft Edge if this is the case.

Note: Some routers may not actually allow using the WAN port, and so you just lose that port. Insert uplink to router in a LAN port.

 ### Setup -> Basic Setup tab
- WAN Connection Type: Disabled
- Local IP Address: e.g. 192.168.1.2 (same subnet as primary router but outside the DHCP range)
- Subnet Mask: 255.255.255.0
- DHCP Server: Disable (do not use DHCP Forwarder)
- Uncheck DNSmasq options
- Gateway: IP address of primary router
- Local DNS: IP address of primary router / local DNS server
- Assign WAN Port to Switch (visible when WAN Connection Type is Disabled)
    Click Save 

### Setup -> Advanced Routing tab
- Change operating mode to: Router, then Save 
- Wireless -> Basic Settings tab
- Set the Wireless Network Name (SSID) as desired, then Save 

### Wireless -> Wireless Security tab
- Security Mode: WPA2
- WPA Algorithm: AES
- WPA Shared Key: =>8 characters, then Save 

### Services -> Services tab
- DNSMasq: Disable
- ttraff Daemon: Disable, then Save 

### Security -> Firewall tab
- Disable SPI firewall, then Save
- Check "Filter Multicast", then Save 

### Finalize
- Apply Settings and connect Ethernet cable to main router LAN port
  - If not working, reboot the router to be sure all settings have been applied
  - You may have to reboot the PC or "ipconfig /release" then "ipconfig /renew" in Windows 

