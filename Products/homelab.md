# Windows and Office 365 deployment lab kit
- https://learn.microsoft.com/en-us/microsoft-365/enterprise/modern-desktop-deployment-and-management-lab?view=o365-worldwide
- ```Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All```

## IP Address Schema
- Default Gateway: 10.0.0.254
- Subnet: 255.255.255.0

| Host    | IP           |
| :-----: | :----------: |
|     DC1 | 10.0.0.6     |
|  CM1    |   10.0.0.7   |
|     GW1 | 10.0.0.254   | 

## Isolate But Maintain Internet
- Follow [this](https://github.com/TonyPhipps/tech-notes/blob/main/Products/hyperv.md), but use 10.0.0.1/24 instead of 192.168.0.1/24
- Set all adapters (2x on GW1, with second adapter being 10.0.0.253) to NatSwitch
- Change Gateway on all VMs, all adapters to 10.0.0.1
- Ping www.google.com to confirm