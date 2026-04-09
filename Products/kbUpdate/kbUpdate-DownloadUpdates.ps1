$PrepFolder = "c:\kbupdate"
$RepoFolder = Join-Path $PrepFolder "repository"
$ScanResultsFolder = Join-Path $PrepFolder "ScanResults"
$KBListPath =  Join-Path $ScanResultsFolder "MissingKBs.txt"
New-Item -ItemType Directory -Path $RepoFolder -Force | Out-Null
if (-not (Test-Path $KBListPath)) {
    Write-Error "Could not find the MissingKBs.txt list at $KBListPath"
    exit
}
$KBsToDownload = Get-Content $KBListPath
Write-Host "Found $($KBsToDownload.Count) required updates in the manifest." -ForegroundColor Cyan
foreach ($KB in $KBsToDownload) {
    Write-Host "Querying Catalog for $KB..." -ForegroundColor Yellow
    $Update = Get-KbUpdate -Name $KB -Architecture x64 -Simple
    if ($Update) {
        foreach ($U in $Update) {
            Write-Host "  -> Downloading: $($U.Title)" -ForegroundColor Green
            $U | Save-KbUpdate -Path $RepoFolder
        }
    } else {
        Write-Warning "  -> $KB was not found in the online catalog. It may be superseded or an AV definition."
    }
}
Write-Host "`nTargeted Download Complete!" -ForegroundColor Green
Write-Host "Your updates are ready to be pushed from $RepoFolder"