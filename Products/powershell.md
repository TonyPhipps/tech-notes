Ways to Stop a Script or Contents
- break - stops the current loop runspace.
- :label (then later) break label - break out of the loop runspace with the referenced labl. Good for nested loops.
- continue - stops the current runspace, allowing parent runspace to continue.
- exit - stops the full powershell process and exits the console window, if in one.

Store Output Streams to Variable
- Add $ to InfoFar and ErrorVar if you want the Information and Errors to NOT be sent down the pipeline.
```
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
```
Start-Job {                
    hostname
} | Wait-Job -Timeout 3 | Receive-Job
```


# Arrays
Add a property to each item in arrray
```
foreach ($Item in $Array) {
    $Item | Add-Member -MemberType NoteProperty -Name "ANewProperty" -Value $AVariable
}
```

Deduplicate An Array of Objects By Selecting Only the Latest Date
```
$UniqueList = $completelist | Group-Object -Property ID | ForEach-Object{$_.Group | Sort-Object -Property StartTime -Descending | Select-Object -First 1}
```

Merge Two Arrays
```
$MergedArray = $Array1 + $Array2
```

Group On Multiple Fields, then Restore Those Field Values
```
$GroupedStuff = $Things | Group-Object Host,DateScanned,UserName
ForEach ($Result in $GroupedStuff) {
    $fields = $Result.name -split ', '
    $Result | Add-Member -MemberType NoteProperty -Name "Host" -Value $fields[0]
    $Result | Add-Member -MemberType NoteProperty -Name "DateScanned" -Value $fields[1]
    $Result | Add-Member -MemberType NoteProperty -Name "UserName" -Value $fields[2]
}
```


# Hashtables
Sort A Hashtable by Key Name
```
$myHashtable.GetEnumerator() | Sort-Object Key
```



# Files and Directories
Remove Empty Directories Recursively
```
Get-ChildItem $Destination -Directory -Recurse |
    Foreach-Object { $_.FullName} |
        Sort-Object -Descending |
            Where-Object { !@(Get-ChildItem -force $_) } |
                Remove-Item
```

Force Get-Childitem to NOT pull Windows directory or Program Files directories.
```
Get-ChildItem c:\ -Depth 0 -Directory | Where-Object {$_.Name -notmatch "windows|Program Files|Program Files \(x86\)"} | Get-Childitem -Recurse
```

Merge CSV files
```
Get-ChildItem *.csv | Select-Object name -ExpandProperty name | Import-Csv | export-csv -NoTypeInformation merged.csv
```





# Misc
Convert .json file to PowerShell objects
```
$file = "file.json"
$json = Get-Content $file | ConvertFrom-Json
$json
## Note that some json nests the records deeper into the array. For example:
$records = $json._embedded.records
$records
```

Run an encoded command
```
$Command = 'Get-Service BITS' 
$Encoded = [convert]::ToBase64String([System.Text.encoding]::Unicode.GetBytes($command)) 
powershell.exe -encoded $Encoded
```

Convert plain text to base64
```
$Text = 'This is a secret and should be hidden'
$Bytes = [System.Text.Encoding]::Unicode.GetBytes($Text)
$EncodedText = [Convert]::ToBase64String($Bytes)
$EncodedText
```

Convert base64 to plain text
```
$base64_string = "VABoAGkAcwAgAGkAcwAgAGEAIABzAGUAYwByAGUAdAAgAGEAbgBkACAAcwBoAG8AdQBsAGQAIABiAGUAIABoAGkAZABkAGUAbgA="
[System.Text.Encoding]::Default.GetString([System.Convert]::FromBase64String($base64_string))
```

Fix $ScriptRoot so its the same whether in ISE or regular Powershell console.
```
if ($psISE) {
    $ScriptRoot = Split-Path -Path $psISE.CurrentFile.FullPath -Parent
} else {
    $ScriptRoot = $PSScriptRoot
}
```


Opens Powershell ISE as administrator under alternate credentials. 
*Window will show Administrator:, but with alternate administrative credentials. Often necessary where least privilege is desired, like logging in as user, then elevating to an administrator with Runas.*
```
$Account = "domain\service_account"
$Credential = Get-Credential $Account
Start-Process $PsHome\powershell.exe -Credential $Credential -ArgumentList "-Command Start-Process $PSHOME\powershell_ise.exe -Verb Runas" -Wait
```

Grant access to specific files in a privileged user profile relatively safely.
```
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
```
try {

} catch [Microsoft.Management.Infrastructure.CimException] {
    if ($_.Exception.Message -match "Cannot create a file when that file already exists" ) {
        Write-Host ("Explanation of the error for {0}." -f $Variable) -ForegroundColor Red
        return 1
    } elseif ($_.Exception.Message -match "No mapping between account names and security IDs was done" ) {
        Write-Host ("Explanation of the other error for {0}." -f $Variable) -ForegroundColor Red
        return 1
    } else {
        throw $_
    }
}
```