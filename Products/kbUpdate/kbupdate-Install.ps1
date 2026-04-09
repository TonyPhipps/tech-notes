$SourcePath = $PSScriptRoot
$TargetModulePath = "C:\Program Files\WindowsPowerShell\Modules"
if (-not (Test-Path $TargetModulePath)) {
    New-Item -ItemType Directory -Path $TargetModulePath -Force
}
Write-Host "Installing kbupdate and dependencies to $TargetModulePath..." -ForegroundColor Cyan
$ModuleFolders = Get-ChildItem -Path (Join-Path $SourcePath "Modules") -Directory
foreach ($Folder in $ModuleFolders) {
    $Dest = Join-Path $TargetModulePath $Folder.Name
    Copy-Item -Path $Folder.FullName -Destination $Dest -Recurse -Force
}
Write-Host "Verifying installation..." -ForegroundColor Cyan
Import-Module kbupdate -Force
if (Get-Command -Module kbupdate) {
    Write-Host "SUCCESS: kbupdate is ready for use." -ForegroundColor Green
} else {
    Write-Error "Module could not be loaded. Check Execution Policy."
}