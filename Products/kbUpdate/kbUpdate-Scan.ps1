$KbUpdatePath = "\\$env:COMPUTERNAME\d$\kbupdate"
$CabPath = Join-Path -Path $KbUpdatePath -ChildPath "catalog\wsusscn2.cab"
$ScanPath = Join-Path -Path $KbUpdatePath -ChildPath "Scan"
$EndpointList = Join-Path -Path $ScanPath -ChildPath "endpoints.txt"
$ExportFolder = Join-Path -Path $KbUpdatePath -ChildPath "ScanResults"
Get-ADComputer -Filter {Enabled -eq $true} | Select-Object -ExpandProperty Name | Out-File -FilePath $EndpointList
New-Item -ItemType Directory -Path $ExportFolder -Force | Out-Null
$Servers = Get-Content $EndpointList
$ScanResults = Get-KbNeededUpdate -ComputerName $Servers -ScanFilePath $CabPath
if (-not $ScanResults) { exit }
$ReportPath = Join-Path $ExportFolder "Full_Compliance_Report_$((Get-Date).ToString('yyyyMMdd')).csv"
$ScanResults | Select-Object ComputerName, KBUpdate, Title, IsMandatory, RebootRequired | Export-Csv -Path $ReportPath -NoTypeInformation
$MissingKBs = $ScanResults.KBUpdate | Sort-Object -Unique
$KBListPath = Join-Path $ExportFolder "MissingKBs.txt"
$MissingKBs | Out-File -FilePath $KBListPath