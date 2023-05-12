# Initial Windows 10 Setup
## Install Remote Server Administration Tools (RSAT)
```
**Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online**
```

## Deduplicate An Array of Objects By Selecting Only the Latest Date
```
$UniqueList = $completelist | Group-Object -Property ID | ForEach-Object{$_.Group | Sort-Object -Property StartTime -Descending | Select-Object -First 1}
```

## Sort A Hashtable by Key Name
```
$myHashtable.GetEnumerator() | Sort-Object Key
```

## Group On Multiple Fields, then Restore Those Field Values
```
$GroupedStuff = $Things | Group-Object Host,DateScanned,UserName
ForEach ($Result in $GroupedStuff) {
    $fields = $Result.name -split ', '
    $Result | Add-Member -MemberType NoteProperty -Name "Host" -Value $fields[0]
    $Result | Add-Member -MemberType NoteProperty -Name "DateScanned" -Value $fields[1]
    $Result | Add-Member -MemberType NoteProperty -Name "UserName" -Value $fields[2]
}
```


## Store Output Streams to Variable
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



Add $ to InfoFar and ErrorVar if you want the Information and Errors to NOT be sent down the pipeline.