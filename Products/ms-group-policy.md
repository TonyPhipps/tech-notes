# Backup a GPO
The basic syntax to back up a single GPO by name is below. Note the folder must exist prior to running the command.
```ps1
Backup-GPO -Name "Your GPO Name" -Path "C:\GPO_Backups" -Comment "Backup of Your GPO"
```


# Disable Screensaver
- `User Configuration > Administrative Templates > Control Panel > Personalization`
  - Enable Screen Saver: Disbled
  - Password Protect the Screen saver: Disabled
  - Screen Saver Timeout: Disabled
  - Force Specific Screen Saver: Disabled
- `Computer Configuration > Windows Settings > Security Settings > Local Policies > Security Options`
  - Interactive logon: Machine inactivity limit: 0
- `Computer Configuration > Administrative Templates > System > Power Management > Video and Display Settings`
  - Turn off the display (plugged in): 0
  - Turn off the display (on battery): 0

