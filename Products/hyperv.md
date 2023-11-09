# Isolate Systems While Still Providing Internet
Great for labbing!
- ```New-VMSwitch -SwitchName "NATSwitch" -SwitchType Internal```
- ```New-NetIPAddress -IPAddress 192.168.0.1 -PrefixLength 24 -InterfaceAlias "vEthernet (NATSwitch)"```
- ```New-NetNAT -Name "NATNetwork" -InternalIPInterfaceAddressPrefix 192.168.0.0/24```
- Assign the VM's network adapter to the NatSwitch.
- Use 192.168.0.0/24 range.
- There will be no DHCP.
- There is no way to remotely access the machines from the LAN unless you create NAT rules to enable access via port translation.
- Be sure to change the Gateway to 10.0.0.1 on the DC01 server at the very least, or it won't be able to resolve DNS queries for the others.
