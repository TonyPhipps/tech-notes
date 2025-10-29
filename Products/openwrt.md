# Setup HTTP
(If available)
- System > Administration > HTTP(S) Access
  - CHECK Redirect to HTTPS

# Setup as a Dumb Switch
Network > Interfaces
- Delete all except LAN
Network > Interfaces > LAN > Edit 
- General Settings
  - Protocol: Static
  - Set the static IP address settings
- Advanced Settings
  - Uncheck all
- Physical Settings
  - Check Bridge Interfaces
  - Interface: (Select all interfaces)
- DHCP Server > General Setup
  - Check Ignore Interace


# Setup as a Dumb Wireless AP
Network > Wireless > General Setup
- Select existing wireless or check only Custom and add "wireless"
- Change ESSID
- Wireless Security
  - Encryption: WPA2-PSK (strong security)
  - Set a Key
  - Click Enable
- Save and Apply
Network > Interfaces > LAN > Edit
- General Settings
- Protocol: Unmanaged
- Advanced Seting
  - Uncheck All
- Physical Settings
  - Check Bridge Interfaces
  - Interface: (Select all interfaces)
