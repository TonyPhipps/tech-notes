Ways to Stop a Script or Contents
- break - stops the current loop runspace.
- :label (then later) break label - break out of the loop runspace with the referenced labl. Good for nested loops.
- continue - stops the current runspace, allowing parent runspace to continue.
- exit - stops the full powershell process and exits the console window, if in one.

Store Output Streams to Variable
- Add $ to InfoFar and ErrorVar if you want the Information and Errors to NOT be sent down the pipeline.
```ps
$InfoVar
$ErrorVar
$FullOutput

Do-Something -InformationVariable InfosVar -ErrorVariable ErrorsVar

$FullOutput += "{0}`n" -f $InfosVar[0].MessageData

if ($ErrorsVar.Count -ne 0) {
    foreach ($ErrorFound in $ErrorsVar) {
        $FullOutput += "`t{0}`n" -f $ErrorsVar[0].MessageData
    }
}
```

Timeout a Command
Use this to effectively assign a timeout to any command or command block.
```ps
Start-Job {                
    hostname
} | Wait-Job -Timeout 3 | Receive-Job
```


# Arrays
Add a property to each item in arrray
```ps
foreach ($Item in $Array) {
    $Item | Add-Member -MemberType NoteProperty -Name "ANewProperty" -Value $AVariable
}
```

Deduplicate An Array of Objects By Selecting Only the Latest Date
```ps
$UniqueList = $completelist | Group-Object -Property ID | ForEach-Object{$_.Group | Sort-Object -Property StartTime -Descending | Select-Object -First 1}
```

Merge Two Arrays
```ps
$MergedArray = $Array1 + $Array2
```

Group On Multiple Fields, then Restore Those Field Values
```ps
$GroupedStuff = $Things | Group-Object Host,DateScanned,UserName
ForEach ($Result in $GroupedStuff) {
    $fields = $Result.name -split ', '
    $Result | Add-Member -MemberType NoteProperty -Name "Host" -Value $fields[0]
    $Result | Add-Member -MemberType NoteProperty -Name "DateScanned" -Value $fields[1]
    $Result | Add-Member -MemberType NoteProperty -Name "UserName" -Value $fields[2]
}
```

Compare two arrays to determine if equal
```ps
[Collections.Generic.SortedSet[String]]::CreateSetComparer().Equals($FirstArray,$SecondArray)
```

# Hashtables
Sort A Hashtable by Key Name
```ps
$myHashtable.GetEnumerator() | Sort-Object Key
```



# Files and Directories
Remove Empty Directories Recursively
```ps
Get-ChildItem $Destination -Directory -Recurse |
    Foreach-Object { $_.FullName} |
        Sort-Object -Descending |
            Where-Object { !@(Get-ChildItem -force $_) } |
                Remove-Item
```

Force Get-Childitem to NOT pull Windows directory or Program Files directories.
```ps
Get-ChildItem c:\ -Depth 0 -Directory | Where-Object {$_.Name -notmatch "windows|Program Files|Program Files \(x86\)"} | Get-Childitem -Recurse
```

Merge CSV files
```ps
Get-ChildItem *.csv | Select-Object name -ExpandProperty name | Import-Csv | export-csv -NoTypeInformation merged.csv
```

# Script Meta
## Parameters
Validate the provided path
```ps
...
[Parameter()]
[ValidateScript({Test-Path $_})]
[String]$Path,
...
```

A nicer, fuller version
```ps
...
[ValidateScript({
    try {
        $Folder = Get-Item $_ -ErrorAction Stop
    } catch [System.Management.Automation.ItemNotFoundException] {
        Throw [System.Management.Automation.ItemNotFoundException] "${_} Maybe there are network issues?"
    }
    if ($Folder.PSIsContainer) {
        $True
    } else {
        Throw [System.Management.Automation.ValidationMetadataException] "The path '${_}' is not a container."
    }
})]
...
```


Make a parameter mandatory
```ps
...
[Parameter(mandatory=$true)]
[ValidateScript({Test-Path $_})]
[String]$Path,
...
```

# Certificates

Skip certificate validation checks (use only for known-good self-signed certs)
```ps
# Trust all certificates (use if self-signed cert is being used
add-type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
```


# Misc
Convert .json file to PowerShell objects
```ps
$file = "file.json"
$json = Get-Content $file | ConvertFrom-Json
$json
## Note that some json nests the records deeper into the array. For example:
$records = $json._embedded.records
$records
```

Run an encoded command
```ps
$Command = 'Get-Service BITS' 
$Encoded = [convert]::ToBase64String([System.Text.encoding]::Unicode.GetBytes($command)) 
powershell.exe -encoded $Encoded
```

Convert plain text to base64
```ps
$Text = 'This is a secret and should be hidden'
$Bytes = [System.Text.Encoding]::Unicode.GetBytes($Text)
$EncodedText = [Convert]::ToBase64String($Bytes)
$EncodedText
```

Convert base64 to plain text
```ps
$base64_string = "VABoAGkAcwAgAGkAcwAgAGEAIABzAGUAYwByAGUAdAAgAGEAbgBkACAAcwBoAG8AdQBsAGQAIABiAGUAIABoAGkAZABkAGUAbgA="
[System.Text.Encoding]::Default.GetString([System.Convert]::FromBase64String($base64_string))
```

Fix $ScriptRoot so its the same whether in ISE or regular Powershell console.
```ps
if (($psISE) -and (Test-Path -Path $psISE.CurrentFile.FullPath)) {
    $ScriptRoot = Split-Path -Path $psISE.CurrentFile.FullPath -Parent
} else {
    $ScriptRoot = $PSScriptRoot
}
$ModuleRoot = Split-Path -Path $ScriptRoot -Parent
```


Opens Powershell ISE as administrator under alternate credentials. 
*Window will show Administrator:, but with alternate administrative credentials. Often necessary where least privilege is desired, like logging in as user, then elevating to an administrator with Runas.*
```ps
$Account = "domain\service_account"
$Credential = Get-Credential $Account
Start-Process $PsHome\powershell.exe -Credential $Credential -ArgumentList "-Command Start-Process $PSHOME\powershell_ise.exe -Verb Runas" -Wait
```

Grant access to specific files in a privileged user profile relatively safely.
```ps
$path = "C:\Users\Administrator\Desktop"
$path = "C:\Users\Administrator\Downloads"
$path = "C:\Users\Administrator\Documents"

$ACL = Get-ACL -Path $path
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone","Read","Allow")
$ACL.SetAccessRule($AccessRule)
$ACL | Set-Acl -Path $path
(Get-ACL -Path $path).Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize
```

Try Catch Errors Template
- When debugging, you can use ```$Error[-1] | Select-Object *``` to see the details of the last error thrown.
- Use the value of ```$Error[0].Exception.GetType().FullName``` in the catch square brackets [] as shown below.
- Use the value of ```$Error[0].Exception.Message``` to match on the first line of the error presented.
```ps
try { 
    yourcode
}
catch [System.Management.Automation.CommandNotFoundException] { # an error you are aware of, and want to handle specifically
    if ($_.Exception.Message -match "is not recognized" ) {
        Write-Information -InformationAction Continue -MessageData ("That's not a command.")
        return 1
    } else {
        Write-Information -InformationAction Continue -MessageData ("Error to catch: `n`t{0}" -f $_.Exception.GetType().FullName)
        Write-Information -InformationAction Continue -MessageData ("Message to filter: `n`t{0}" -f $_.Exception.Message)
        throw $_
    }    
}
catch { # catch all remaining errors and provide info to capture them specifically
    Write-Information -InformationAction Continue -MessageData ("Error to catch [] on: `n`t{0}" -f $_.Exception.GetType().FullName)
    Write-Information -InformationAction Continue -MessageData ("Message to filter: `n`t{0}" -f $_.Exception.Message)
    throw $_
}
```


Assign a Variable via Switch
```ps
$day = 3

$result = switch ( $day )
{
    0 { 'Sunday'    }
    1 { 'Monday'    }
    2 { 'Tuesday'   }
    3 { 'Wednesday' }
    4 { 'Thursday'  }
    5 { 'Friday'    }
    6 { 'Saturday'  }
}

$result
$result.GetType() 
```

Assign a Variable an Array or String via Switch
```ps
$day = "Friday"

$result = switch ( $day )
{
    "Monday"    { "Agenda Item 1", "Agenda Item 2" }
    "Tuesday"   { "Agenda Item 3", "Agenda Item 4" }
    "Wednesday" { "" }
    "Thursday"  { "Agenda Item 5" }
    "Friday"    { "Agenda Item 6", "Agenda Item 7" }
    default     { "Weekend!" }
}

$result
$result.GetType() 
```


Add a Hashtable as Properties to an Existing Object
```ps
# Create a hashtable of properties
$newProperties = @{
    City = "New York"
    Country = "USA"
}

# Add the properties from the hashtable to the object
foreach ($key in $newProperties.Keys) {
    $myObject | Add-Member -MemberType NoteProperty -Name $key -Value $newProperties[$key]
}
```
