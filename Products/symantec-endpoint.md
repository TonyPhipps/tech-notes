# Remove
Replace OTHERHOST with just '.' to target local pc
```ps1
(Get-WmiObject -Class Win32_Product -Filter "Name='Symantec Endpoint Protection'" -ComputerName OTHERHOST ).Uninstall()
```