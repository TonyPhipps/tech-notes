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


# Extras
- Use your DD-WRT router as a switch
  - https://wiki.dd-wrt.com/wiki/index.php/Switch



