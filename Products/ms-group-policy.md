The basic syntax to back up a single GPO by name is below. Note the folder must exist prior to running the command. Also, two GPO's can be exported to the same folder, resuling in a shared manifest.xml
```ps
Backup-GPO -Name "Your GPO Name" -Path "C:\GPO_Backups" -Comment "Backup of Your GPO"
```