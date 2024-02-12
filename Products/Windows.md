# Offline Updates
Cumulative Updates
- https://www.catalog.update.microsoft.com
- Search for something like "Cumulative Update for Windows Server 2019"
- Download the latest cumulative update that applies


# Repair Windows Store Apps
Attempt 1
```
wsreset
```


Attempt 2
```
Get-AppXPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register “$($_.InstallLocation)AppXManifest.xml”}
```

Attempt 3
```
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