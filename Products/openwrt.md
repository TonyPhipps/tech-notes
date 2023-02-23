# Suggested Setup
- System > Administration > HTTP(S) Access
  - CHECK Redirect to HTTPS


# Use as a Dump AP
- Network > Interfaces > LAN Interface > Edit
  - Provide a static IP address
  - Save and reload by navigating to the new address from the last step
- Network > Interfaces > LAN Interface > Edit
  - Set the Default Gateway to the router (likely 192.168.1.1)
  - Advanced Tab
    - Set the DNS to the router (likely 192.168.1.1 or just CHECK "Use Default Gateway"
  - DHCP Server Tab
    - CHECK Ingore Interace
    - Advanced Tab
      - Uncheck/disable everything
    - IPV6 Tab
      - Uncheck/disable everything
- System > Startup
  - Disable firewall, dnsmasq, odhcpd
- System > Reboot

# Set WAN port as "Another Switchport"
- Network > Switch
- Set the WAN port to "untagged" for VLAN ID 1.
- Set the WAN port to "off" for VLAN ID 2.
- That port can now be used as an effective uplink, like the other ports.
