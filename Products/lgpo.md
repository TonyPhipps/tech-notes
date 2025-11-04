```ps
# Set all Local GPO you wish to export. We will then run a backup, edit the output, and test importing of the resulting registry.pol
C:\Tools\LGPO.exe /b "$env:USERPROFILE\Documents\"
C:\Tools\LGPO.exe /parse /m "$env:USERPROFILE\Documents\{B69A433C-670F-4C21-A124-EFB0DA9E61B2}\DomainSysvol\GPO\Machine\registry.pol" > "$env:USERPROFILE\Documents\output.txt"
# Edit the output.txt file to only include your desired changes, then save it as registry.pol
C:\Tools\LGPO.exe /t "$env:USERPROFILE\Documents\registry.pol"
```

This is the syntax to expect for registry.pol:
```
Computer
SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit
ForceAuditPolicy
DWORD:1

Computer
SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\RestrictNTLM
AuditIncomingNTLMTraffic
DWORD:2

Computer
SOFTWARE\Policies\Microsoft\Windows\PowerShell
ScriptBlockLogging
DWORD:1

Computer
SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging
EnableScriptBlockLogging
DWORD:1

Computer
SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging
EnableModuleLogging
DWORD:1

Computer
SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames
*
DELETEALLVALUES

Computer
SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames
*
SZ:*
```