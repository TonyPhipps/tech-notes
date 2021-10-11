# Install
Install modules
```
Install-Module Microsoft.Graph -Scope CurrentUser
```

Verify modules were installed
```
Get-InstalledModule Microsoft.Graph
```

Update the SDK
```
Update-Module Microsoft.Graph
```

Remove the SDK
```
Uninstall-Module Microsoft.Graph
```

Use the SDK
```
# Generate a certificate to upload to application registration
$cert = New-SelfSignedCertificate -Subject "CN=MSGraph_ReportingAPI" -CertStoreLocation "Cert:\CurrentUser\My" -KeyExportPolicy Exportable -KeySpec Signature -KeyLength 2048 -KeyAlgorithm RSA -HashAlgorithm SHA256
Export-Certificate -Cert $cert -FilePath "C:\Users\username\MSGraph_ReportingAPI.cer"

# Import Certificate and check
Import-Certificate -FilePath "C:\Users\username\MSGraph_ReportingAPI.cer" -CertStoreLocation 'Cert:\LocalMachine\My' -Verbose 
Get-ChildItem Cert:\CurrentUser\My

# Setup variables and connect
$ClientID       = "xxx"    # Application (client) ID gathered when creating the app registration
$tenantdomain   = "yyy"    # Directory (tenant) ID gathered when creating the app registration
$Thumbprint     = "zzz"    # Certificate thumbprint gathered when configuring your credential

Select-MgProfile -Name "beta"
  
Connect-MgGraph -ClientId $ClientID -TenantId $tenantdomain -CertificateThumbprint $Thumbprint

# Test connection
Get-MgRiskyUser -All
```

# Resources
- [Install the Microsoft Graph PowerShell SDK](https://docs.microsoft.com/en-us/graph/powershell/installation)
- [pAzure Active Directory Identity Protection and the Microsoft Graph PowerShell SDK](https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/active-directory/identity-protection/howto-identity-protection-graph-api.md)