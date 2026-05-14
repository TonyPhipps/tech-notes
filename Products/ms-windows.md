# Offline Updates
Cumulative Updates
- https://www.catalog.update.microsoft.com
- Search for something like "Cumulative Update for Windows Server 2019"
- Download the latest cumulative update that applies


# Change a User's ProfileImagePath
- Log off the target user.
- Open RegEdit as admin
- Navigate to Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\
- Open the Key that matches the user's SID (or really, find it by opening each)
- Change the ProfileImagePath as needed.
- Copy the files from the old folder to the new.
- Log back in as the user.


# Repair Windows Store Apps
Attempt 1
```ps
Get-AppxPackage -allusers *WindowsStore* | Remove-AppxPackage
Get-AppxPackage -allusers *WindowsStore* | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
wsreset
Updates & Downloads > "Get Updates"
```

Attempt 2
```ps
Get-AppXPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
```

Attempt 3
```ps
sfc /scannow
Dism /Online /Cleanup-Image /ScanHealth
Dism /Online /Cleanup-Image /CheckHealth
Dism /Online /Cleanup-Image /RestoreHealth
net stop bits
net stop wuauserv
net stop appidsvc
net stop cryptsvc
Del "%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\*.*"
Get-ChildItem "C:\Windows\SoftwareDistribution\Download" | Remove-Item -force
Get-ChildItem "%systemroot%\system32\catroot2" | Remove-Item -force
regsvr32.exe /s atl.dll
regsvr32.exe /s urlmon.dll
regsvr32.exe /s mshtml.dll
netsh winsock reset
netsh winsock reset proxy
net start bits
net start wuauserv
net start appidsvc
net start cryptsvc
reset
shutdown -r -t 0
```

Attempt 4
Download and run the MediaCreationTool###.exe
```
https://www.microsoft.com/en-us/software-download/windows10
```

Tell it to Update/Upgrade (to Windows 10). System components will be repaired/replaced.


# Windows KB Updates
Manually install KB packages
```ps1
wusa.exe "C:\Path\To\Your\Patch\kbupdate.msu" /norestart
Dism /Online /Add-Package /PackagePath:"C:\Path\To\Your\kbupdate.cab"
```

## Error Code 0x800f0986
Repair System Files (DISM & SFC):
```ps1
dism /online /cleanup-image /restorehealth
sfc /scannow
# reboot and try again
```

Reset Windows Update Components:
```ps1
net stop wuauserv
net stop cryptSvc
net stop bits
net stop msiserver
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old
ren C:\Windows\System32\catroot2 catroot2.old
net start wuauserv
net start cryptSvc
net start bits
net start msiserver
# reboot and try again
```
