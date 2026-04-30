# Audit winrm settings
```ps1
# Check WinRM Listeners
winrm enumerate winrm/config/listener

# Check for HTTP.sys URL reservations
netsh http show urlacl | Select-String "5985"

# Identify what process is actually bound to the port
Get-NetTCPConnection -LocalPort 5985 -ErrorAction SilentlyContinue | 
    Select-Object LocalAddress, OwningProcess, State | 
    Format-Table -AutoSize

# Check PowerShell Session Configurations
Get-PSSessionConfiguration | Select-Object Name, Permission
```


# Reset/Delete all settings
```ps1
# Stop the service
Stop-Service winrm -Force

# Delete the kernel-level URL reservations (Clears the 503 error)
netsh http delete urlacl url=http://+:5985/wsman/
netsh http delete urlacl url=https://+:5986/wsman/

# Remove all listeners from the WSMan provider
Get-ChildItem wsman:\localhost\listener | Remove-Item -Recurse

# Restore WinRM configuration to factory defaults
winrm invoke restore winrm/config @{}

# Unregister existing PowerShell endpoints
Unregister-PSSessionConfiguration -Name * -Force
```


# Initialize winrm
```ps1
# Perform a fresh setup of the WinRM service and listeners
Enable-PSRemoting -Force -SkipNetworkProfileCheck

# Restart the service to ensure the new Request Queue is active
Restart-Service winrm -Force

# Final Verification: Test the local loopback
Test-WSMan -ComputerName localhost
```