- [Setting Up pfSense as a Home Router/Firewall](#setting-up-pfsense-as-a-home-routerfirewall)
  - [Initial Setup](#initial-setup)
  - [Basic Firewall Setup](#basic-firewall-setup)
- [Backup Settings](#backup-settings)
- [Extras](#extras)


# Setting Up pfSense as a Home Router/Firewall
Assumes you are using a Netgate SG-1100


## Initial Setup
- Plug in power and cable between PC and LAN interface
- Wait ~5min
- Navigate to 192.168.1.1
  - Log in with admin:pfsense
  - Run through the setup wizard with all defaults
  - Primary DNS server suggestion - [OpenDNS](https://support.opendns.com/hc/en-us/articles/228006047-Generalized-Router-Configuration-Instructions)


## Basic Firewall Setup
The pfSense firewall blocks WAN traffic by default - any traffic that doesn't match any rules is dropped silently.


### Default-deny Outbound
This is basically hard-mode. You will have to create Pass rules above this rule to get anything working. We'll put in Pass rules for basic internet over TCP 80/443

- Navigate to Firewall > Rules > LAN
  - Add these rules
    - Pass tcp any 443
    - Pass tcp any 80
    - Pass any LAN net LAN net
    - Block IPv4+IPv6 protocol:any LAN Net any (enable logging)
  - Click Apply Changes
  - Review any blocks via Status > System Logs > Firewall


# Backup Settings
- Navigate to Diagnostics > Back and Restore
  - Click Download Configuration as XML

# VPN
## Generate a Certificate Authority (CA) Certificate
- System > Cert Manager
- Add
  - Descriptive Name: Something
  - Method: Create an Internal Certificate Authority
  - Key Type: RSA
  - Key Length: 4096
  - Digest Algorithm: SHA512
  - Common Name: internal-ca
  - Save

## Generate a Servedr Certificate for the VPN
- System > Cer. Manager > Certificates
- Add/Sign
  - Method: Create an Internal Certificate
  - Descriptive Name: VPN
  - Key Type: RSA
  - Key Length: 4096
  - Digest Algorithm: SHA512
  - Lifetime: 3650
  - Certificate Type: Server Certificate
  - Save

## Create a User to use with VPN
- System > User Manager
- Add
  - Username: something
  - Password: something

## Create a User Certificate
- System > User Manager
- Edit the created User you want to connect to the VPN with
- Under User Certificates, Add
  - Method: Create an Internal Certificate
  - Descriptive Name: User's VPN
  - Key Type: RSA
  - Key Length: 4096
  - Digest Algorithm: SHA512
  - Lifetime: 3650
  - Certificate Type: User Certificate
  - Save
- Save (again)

## Create the Actual OpenVPN Server
- VPN > OpenVPN
- Add
  - Server Mode: Remote Access (SSL/TLS + User Auth) (user, pass, and cert all required)
  - Local Port: 1194 or something else
  - Description: Something
  - Use a TLS Key: Checked
  - Automatically Generate a TLS Key: checked
  - Peer Certificate Authority: the CA Certificate made earlier
  - Server Certificate: The VPN Certificate made earlier
  - DH Parameter Length: 4096
  - Auth Digest Algorithm: SHA3-512 (512-bit)
  - IPv4 Tunnel Network: 192.168.2.0/24
  - Redirect IPv4 Gateway: Checked
  - UDP Fast I/O: Enabled
  - Gateway Creation: IPv4 Only
  - Save

## Verify
- Status > System Logs > OpenVPN
- If everything is set up correctly, you should see Initialization Sequence Completed in the logs.

## Allow VPN Pool to Reach Out of the Network
- Firewall > Rules > OpenVPN
- Add
  - Address Family: IPv4
  - Protocol: Any
  - Source: Network - 192.168.2.0/24
  - Description: VPN Client Pool Egress
  - Save
- Apply Changes

## Allow Connecting to VPN from Public
- Firewall > Rules > WAN
- Add
  - Address Family: IPv4
  - Protocol: UDP
  - Source: Any
  - Destination Port Range: 1194 to 1194
  - Description: Expose VPN Server
  - Save
- Apply

## Install OpenVPN Client Export Utility
- System > Package Manager > Available Packages
- Search for VPN and find "openvpn-client-export"
- Install it

### Export Client Configs
- VPN > OpenVPN > Client-Export
- Remote Access Server: yourserver
- Host Name Resolution: Interface IP Address

# Xbox Open NAT
- all Xboxes must be configured with a STATIC IP.
  - under the Xbox Settings, Network, Advanced settings, I use MANUAL IP address setting.
    - put a static IP inside the range of your network.
    - as an example:
      - IP: 192.168.1.20
      - Subnet: 255.255.255.0
      - Gateway: 192.168.100.1
      - DNS: Point it at your PFSENSE box.  192.168.1.1
      - Secondary DNS: Use Google:  8.8.8.8
    - Alternate PORT:  not needed // leave at default
    - clear any alternate MAC addresses.
  - Save these settings and SHUT DOWN your XBOX.
  - Pull the plug

- Inside PFSENSE, go to Services/ UPnP & NAT-PMP
  - Setup your settings like this (click image for larger version):
![xbox1-1024x932](https://user-images.githubusercontent.com/17801619/219172278-3daf371c-c775-4668-bba6-f8bd41d6cda6.jpg)

✔ Enable UPnP & NAT-PMP

✔ Allow UPnP Port Mapping

✔ Allow NAT-PMP Port Mapping

Set External Interface to yours

Set Interfaces to your LAN Name

✔ Log packets handled by UPnP & NAT-PMP rules.

✔ Deny access to UPnP & NAT-PMP by default

ACL Entries: ```allow 53-65535 192.168.1.20/32 53-65535``` (using your xbox static address)

Notes:
- under ACL ENTRIES, each XBOX’s STATIC IP address must be on it’s own line here.  If you have multiple XBOX’s, create one line entry for each XBOX and edit the IP ADDRESS
- HIT SAVE to save your settings here.

- Go to Firewall / NAT / Outbound
  - Make sure that the MODE is set to Hybrid Outbound NAT rule generation.
  - Add a mapping (see below, click for larger image)
![xbox2-1-1024x952](https://user-images.githubusercontent.com/17801619/219172973-6a077a1c-2cd4-416c-8a72-fa06cf688a0b.jpg)

NOTES:
- under SOURCE, you must put the IP address for your XBOX here.
- Repeat and add mappings for EACH XBOX (and IP ADDRESS) inside your LAN
- SAVE CHANGES

- Plug the power back into your Xbox
- Power it on
- Once it is booted, go to NETWORK / SETTINGS.
- RE-RUN NAT TYPE test
- RE-RUN MULTIPLAYER test
- you should now have "OPEN" NAT

# Extras
- Use your DD-WRT router as a switch
  - https://wiki.dd-wrt.com/wiki/index.php/Switch



