# Setup
Open WSUS (Windows Server Update Services)
- Run through wizard and click "Start Connecting" ... may take a few minutes.
- Choose Languages
  - Keep just English (or add/change languages if needed)
- Choose Products
  - Keep defaults
    - Critical Updates
    - Definition Updates
    - Security Updates
- Configure Sync Schedule
  - Synchronize Automatically
    - Synchronizations Per Day: 1
- Finished
  - DO NOT Check "Begin Initial Synchronization". Instead, set up Automatic Approvals first.

# Products and Classifications
- Carefully select which products and features to include, as the download size can easily go above 500GB in total updates stored.
- Recommended
  - Active Directory
  - Microsoft Server Operating System 23H2
  - Windows > Microsoft Edge
  - Windows > Microsoft Server Operating System-23H2 and later (or whatever is latest)
  - Windows 10, version 1903 and later (or whatever is latest)
  - Windows Server 2016
  - Windows Server 2019

# IMPORTANT: Ensure the WSUS Server Itself is Updated
- Or devices may not show in the WSUS console up once they are configured.

# Approvals
Approve updates under WSUS Console > Updates

Enable Automatic Approvals to ensure the WSUS server pulls down future updates locally. Do this before the first synchronization
- open WSUS Console
- Options > Automatic Approvals
- Check Default Automatic Approval Rule
- Add/update more rules as needed (Recommend adding Definition Updates to the default)
- Automatic approval of critical and security updates is recommended.

# Synchronization
- Note that synchronizing only downloads a list of updates. No update package will be downloaded if they are not Approved manually or automatically.
- Observe download status in WSUS Console > [System Name] > Download Status

## Synchronization Reports
- To view synchronization reports, you will need to install somethings.
  - SQLSysClrTypes.msi can be found at https://www.microsoft.com/en-us/download/details.aspx?id=56041 ... this is required to install the Report Viewer. You only need install the single msi from the package.
  - A ReportViewer.msi link will be given when you attempt to view a report.
  - Once both are installed, close and reopen the WSUS window to view reports.

## Cancel Downloading Updates
- ```(Get-WsusServer).CancelAllDownloads()```

# WSUS Group Policy
- Microsoft recommends creating a new GPO that contains only WSUS settings. Link this WSUS GPO to an Active Directory container that's appropriate for the environment.
- ```Computer Configuration > Administrative Templates > Windows Components > Windows Update```
  - (Settings here are recommended for lab)
  -  Configure Automatic Updates
    - Enabled
    - Configure Automatic Updating: 4 - Auto download and schedule the install
    - Check Install During Automatic Maintenance
    - Schedule Install Day: 0 - Every day
    - Schedule Install Time: 03:00
    - Check Every Week
  - Specify Internet Microsoft Update Service Location
    - Enabled
    - Detecting Updates: http://cm1.corp.contoso.com:8530/
    - Statistics Server: http://cm1.corp.contoso.com:8530/
  - Automatic Update Detection Frequency
    - Enabled
    - Interval (Hours): 1
 
 - Force & validate
   - Force GPO via ```gpupdate /force```
   - Validate GPO via ```gpresult /r```
   - Validate GPO via ```HKEY_LOCAL_MACHINE > SOFTWARE > Policies > Microsoft > Windows > WindowsUpdate > WUServer```
   - Force WSUS checkin via ```wuauclt /detectnow``` then ```wuauclt /reportnow.```.
   - Or all in one go ```gpupdate /force && gpresult /r && wuauclt /detectnow && wuauclt /reportnow```

# Synchronize software updates from a disconnected software update point
- On the Connected Server
  - Run ```wsusutil.exe export export.xml export.cab```
  - Copy the ```export.xml``` and ```export.cab``` files to the external drive.
  - Copy ```<WSUSInstallationDrive>\WSUS\WSUSContent\``` to an external drive.
- On the Disconnected Server
  - Copy ```WSUSContent``` from the external drive to the appropriate path on this server.
  - Run ```wsusutil.exe import export.xml export.cab``` pointing to the files from the external drive.
  - Run ```wsusutil.exe reset```
  - Open the WSUS Management Console. Navigate to Updates > All Updates, filter by Needed, and verify if the updates are now marked as Ready for installation.

## Cleanup
As needed...

### Run this in Command Prompt (not powershell)
```
net stop wsusservice
cd "C:\Program Files\Update Services\Tools"
wsusutil.exe reset
echo Delete WSUS Folder Content
pause
net start wsusservice
```

Delete the contents of c:\wsus\ when it tells you to.

Take a look in Task Manager and you’ll see that the process “SQL Server Windows NT – 64 bit” is consuming all the CPU. This is because all database tables are being checked and any missing hotfixes are being marked for download.

This could take up to 30-60 minutes to complete, depending on the Products and Classifications you have. When the CPU drops you’re ready to proceed.

### Run this in PowerShell, then REBOOT

```
#Change server name and port number and $True if it is on SSL
$Computer = $env:COMPUTERNAME
$Domain = $env:USERDNSDOMAIN
$FQDN = "$Computer" + "." + "$Domain"
[String]$updateServer1 = $FQDN
[Boolean]$useSecureConnection = $False
[Int32]$portNumber = 8530
 
# Load .NET assembly
[void][reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")
 
$count = 0
 
# Connect to WSUS Server
$updateServer = [Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer($updateServer1, $useSecureConnection, $portNumber)
write-host "<<<Connected sucessfully >>>" -foregroundcolor "yellow" 
$updatescope = New-Object Microsoft.UpdateServices.Administration.UpdateScope

$u = $updateServer.GetUpdates($updatescope )

foreach ($u1 in $u ) {
  if ($u1.IsSuperseded -eq 'True') {
    write-host Decline Update : $u1.Title
    $u1.Decline() 
    $count = $count + 1
  } 
}

write-host Total Declined Updates: $count

trap {
  write-host "Error Occurred"
  write-host "Exception Message: "
  write-host $_.Exception.Message
  write-host $_.Exception.StackTrace
  exit
}
```

- After the reboot, reselect Products and Classifications (better this time)
- Run the Automatic Approval Rule(s) you set up.
- Start a sync manually.
- You may see sqlserv.exe taking up a lot of cpu/memory. It could take 30-60min to complete.
- Once the sqlserv.exe completes its crunching, you should see folders appear in c:\wsus and the system should start downloading actual update packages.
- In WSUS COnsole > [ServerName] > Download Status you should see a much smaller number of required space.


# Resources
- https://learn.microsoft.com/en-us/windows-server/administration/windows-server-update-services/get-started/windows-server-update-services-wsus
- https://learn.microsoft.com/en-us/windows-server/administration/windows-server-update-services/deploy/2-configure-wsus#24-configure-wsus-computer-groups
- https://learn.microsoft.com/en-us/windows-server/administration/windows-server-update-services/deploy/2-configure-wsus#26-configure-client-computers-to-receive-updates-from-the-wsus-server
- https://learn.microsoft.com/en-us/mem/configmgr/sum/get-started/synchronize-software-updates-disconnected