[CmdletBinding()]
param (
    [Parameter(Mandatory = $false, HelpMessage = "The path for preparation.")]
    [ValidateNotNullOrEmpty()]
    [string]$PrepFolder = "$HOME\kbupdate"
)
try {
    Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
    $CatalogFolder = Join-Path -Path $PrepFolder -ChildPath "catalog"
    $Url = "https://go.microsoft.com/fwlink/?linkid=74689"
    $Dest = Join-Path -Path $CatalogFolder -ChildPath "wsusscn2.cab"
    if (-not (Test-Path $PrepFolder)) {
        Write-Host "Creating directory: $PrepFolder" -ForegroundColor Gray
        New-Item -ItemType Directory -Path $PrepFolder -Force | Out-Null
    }
    if (-not (Test-Path $CatalogFolder)) {
        New-Item -ItemType Directory -Path $CatalogFolder -Force | Out-Null
    }
    Write-Host "Saving module to $PrepFolder..." -ForegroundColor Gray
    Save-Module -Name kbupdate -Path $PrepFolder -ErrorAction Stop
    Get-ChildItem -Path $PrepFolder -Recurse | Unblock-File
    $ShouldDownload = $true
    if (Test-Path $Dest) {
        $FileDate = (Get-Item $Dest).LastWriteTime
        $CutoffDate = (Get-Date).AddDays(-1)
        if ($FileDate -ge $CutoffDate) {
            Write-Host "The existing wsusscn2.cab is current (less than 24 hours old)." -ForegroundColor Green
            $ShouldDownload = $false
        } else {
            Write-Host "Existing wsusscn2.cab is outdated. Preparing download..." -ForegroundColor Yellow
        }
    }
    if ($ShouldDownload) {
        Write-Host "Downloading wsusscn2.cab (~1GB, this may take a few minutes)..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $Url -OutFile $Dest -UseBasicParsing
        Write-Host "Download complete!" -ForegroundColor Green
    }
    $FolderName = Split-Path -Path $PrepFolder -Leaf
    $ParentFolder = Split-Path -Path $PrepFolder -Parent
    $DestinationZip = Join-Path -Path $ParentFolder -ChildPath "$FolderName.zip"
    Write-Host "Compressing folder to $DestinationZip..." -ForegroundColor Cyan
    Compress-Archive -Path "$PrepFolder\*" -DestinationPath $DestinationZip -Force
    Write-Host "Success! Your package is ready at: $DestinationZip" -ForegroundColor Green
}
catch {
    Write-Error "An error occurred during execution: $($_.Exception.Message)"
    exit 1
}