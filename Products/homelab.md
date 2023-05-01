# Windows and Office 365 deployment lab kit
- https://learn.microsoft.com/en-us/microsoft-365/enterprise/modern-desktop-deployment-and-management-lab?view=o365-worldwide
- ```Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All```
- Default password is ```P@ssw0rd```

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

## Linux Tips and Trips for HyperV
- Disable UEFI secure boot via the PowerShell command ```Set-VMFirmware -vmname "Splunk" -EnableSecureBoot Off```

## Prevent Windows Eval Lab Instances from Shutting Down
Every 1hr these lab instances will shut down. These steps will prevent that.
- Take ownership of ```c:\windows\system32\wlms\wlms.exe wlms.exe```
  - Right click > Properties
  - Advanced
  - By Owner: Trustedinstaller click Change
  - Type ```Administrators``` in the text box and click Check Name
  - Click OK on all Windows
  - NOTE: This will actually set the owner to SYSTEM.
- Use psexec to imitate SYSTEM and rename the file
  - Download and install/extract Microsoft [pstools](https://learn.microsoft.com/en-us/sysinternals/downloads/pstools).
  - Open a command prompt (As Administrator) and navigate to where psexec.exe resides.
  - execute ```psexec -i -s cmd.exe``` This will open another cmd prompt.
  - Execute ```whoami``` to confirm user is ```nt authority\system```
  - Execute ```rename c:\windows\system32\wlms\wlms.exe wlms1.exe```

Following above steps disables the hourly shutdown of VM after expiry of license but the easiest way is to Activate the windows by providing a legal key. Since this is not a supported method please do not use this on laptops/VMs that are in production.
