$PrepFolder = "c:\kbupdate"
$RepoFolder = Join-Path $PrepFolder "repository"
$ScanFolder = Join-Path $PrepFolder "scan"
$EndpointList = Join-Path -Path $ScanFolder -ChildPath "endpoints.txt"
$Servers = Get-Content $EndpointList
Install-KbUpdate -ComputerName $Servers -FilePath $RepoFolder