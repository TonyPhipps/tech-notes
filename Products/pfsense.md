- [Setting Up pfSense as a Home Router/Firewall](#setting-up-pfsense-as-a-home-routerfirewall)
  - [Initial Setup](#initial-setup)
  - [Basic Firewall Setup](#basic-firewall-setup)
  - [DNS Blocking](#dns-blocking)
  - [Web Proxy Category Blocking with SquidGuard](#web-proxy-category-blocking-with-squidguard)
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


## DNS Blocking


### Firewall DNS Setup
- Navigate to Firewall > Rules > LAN
  - Traffic is parsed through firewall rules top-to-bottom. We will make two rules here. One to allow DNS to the pfSense system, and one UNDER it to block all DNS.
  - Add a rule:
    - Action: Pass
    - Protocol: UDP
    - Source: Any
    - Destination LAN Net / DNS (53)
    - Description: Allow DNS to pfSense
  - Add another rule:
    - Action: Block
    - Protocol: UDP
    - Source: Any
    - Destination Any / DNS (53)
  - Description: Block DNS traffic


### pfBlocker
- Navigate to System > Package Manager > Available Packages
  - Search for pfBlockerNG and install the non-development package
  - Firewall > pfBlockerNG
  - Check Enable pfBlockerNG and click Save at the bottom
  - Firewall > pfBlockerNG > DNSBL
  - Check Enable DNSBL and click Save at the bottom


#### DNSBL EasyList
- Navigate to Firewall > pfBlockerNG > DNSBL EasyList
  - In DNS GROUP Name type "EasyList"
  - In EasyList Feeds, click Add and set up the two lists
    - ON | Easylist w/o Elements | EasyList
    - ON | EasyPrivacy | EasyPrivacy
  - Select all entries in Categories
  - Change List Action to Unbound
  - Change Update Frequency to Once a day


#### DNSBL Feeds
- Navigate to Firewall > pfBlockerNG > DNSBL Feeds
  - Set DNS GROUP Name to StevenBlack List
  - Set Description to https://github.com/StevenBlack/hosts
  - Click Add and set up the two lists
      - Auto | ON | https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts | porn
      - Auto | ON | https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts | adware_malware
  - Set List Action to Unbound
  - Set Update Frequency to Once a day
  - Click Save


#### Update the DNSBL Lists
- Navigate to Firewall > pfBlockerNG > Update
  - Click Run


#### DNSBL Whitelisting
- Navigate to Firewall > pfBlockerNG > DNSBL
  - Scroll to the bottom and expand Custom Domain Whitelist
  - Add entries - one per line
- Navigate to Firewall > pfBlockerNG > Update
  - Select 'Force' option Reload
  - Click Run
  
#### Disable Logging
Logging has caused me issues with some sites that use HSTS
- Navigate to Firewall > pfBlockerNG > IP > GeoIP
- Set Logging for all items to Disabled


#### Troubleshooting & Log Review
- Navigate to Firewall > pfBlockerNG > Logs
  - Select Log/File selection > dnsbl.log
  - Review Rejects in the log file
- Or open an SSH connection and monitor live with  ```tail -f /var/log/pfblockerng/dnsbl.log```


## Web Proxy Category Blocking with SquidGuard
- Navigate to System > Package Manager
  - Search for and install Squid
  - Search for and install SquidGuard


### Setup Firewall
- Navigate to Firewall > NAT
  - Add a rule to the top
    - Interface: LAN
    - Protocol: TCP/UDP
    - Destination: Any
    - Destination Port Range: DNS (53)
    - Redirect Target IP: 127.0.0.1
    - Redirect Target Port: DNS (53)
    - Description: NAT Squid Redirect
- Navigate to Firewall > Rules > LAN
  - Drag NAT Squid Redirect to the top


### Setup Squid
- Navigate to Services > Squid Proxy Server > Local Cache
  - Click Save
- Navigate to System > Certificate Manager
  - Click Add
    - Descriptive Name: pfSense
- Navigate to Services > Squid Proxy Server
  - Check Enable Squid Proxy
  - Check Transparent HTTP Proxy
  - Check Bypass Proxy for Private Address Destination 
  - Check HTTPS/SSL Interception
    - NOTE: Using HTTPS/SSL interception may cause SSL_ERROR_RX_RECORD_TOO_LONG errors
    - NOTE: If you choose not to use this, consider making SquidGuard's default Target Rule List 'deny' to block non-categorized HTTP sites.
  - Set SSL/MITM Mode to Splice All
  - Set CA to pfSense
  - Check Enable Access Logging
  - Set Rotate Logs to 1


### Setup SquidGuard
- Navigate to Services > SquidGuard Proxy filter > General
  - Click Enable, Enable Log, Clean Advertising, and Enable Log Rotation
  - Under Blacklist Options, check Blacklist
  - Click Save


#### Bug Workaround
- Navigate to Services > SquidGuard Proxy filter > Target Categories
  - Click Add
    - Name: Dummy
    - Description: Dummy custom target category (fix: squid & squid guard not auto starting after reboot). 
    - (remaining parameters blank)
    - Click Save
- Navigate to Services > SquidGuard Proxy filter > Common ACL
  - Click Target Rules List [+]
    - Click the dropdown next to the Dummy list and select deny
  - Click Save
- Navigate to Services > SquidGuard Proxy filter > General Settings
  - Click Apply


#### Setup Blacklist
- Navigate to Services > SquidGuard Proxy filter > Blacklist
  - Paste the URL below in the text box
    - http://www.shallalist.de/Downloads/shallalist.tar.gz
  - Click Download
- Navigate to Services > SquidGuard Proxy filter > Common ACL
  - Click Target Rule List [+]
    - Set up categories
      - Select —, to ignore a category.
      - Select allow, to allow this category for clients.
      - Select deny, to deny this category for clients.
      - Select white, to allow this category without any restrictions. This option is used for exceptions to prohibited categories.
    - Check Do not allow IP-Addresses in URL
    - Check Log
    - Click Save
- Navigate to Services > SquidGuard Proxy filter > General Settings
  - Click Apply


# Backup Settings
- Navigate to Diagnostics > Back and Restore
  - Click Download Configuration as XML


# Extras
- Use your DD-WRT router as a switch
  - https://wiki.dd-wrt.com/wiki/index.php/Switch



