#region CODE
$winget = $null
$DesktopAppInstaller = "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
$SystemContext = Resolve-Path "$DesktopAppInstaller"
if ($SystemContext) { $SystemContext = $SystemContext[-1].Path }
$UserContext = Get-Command winget.exe -ErrorAction SilentlyContinue
if ($UserContext) { $winget = $UserContext.Source }
elseif (Test-Path "$SystemContext\AppInstallerCLI.exe") { $winget = "$SystemContext\AppInstallerCLI.exe" }
elseif (Test-Path "$SystemContext\winget.exe") { $winget = "$SystemContext\winget.exe" }
else { return $false }
if ($null -ne $winget) { $winget }
# Logs $(env:LOCALAPPDATA)\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\DiagOutputDir
& "$winget" --version
& "$winget" install --id "Microsoft.Teams" --source "winget" --exact --silent --accept-source-agreements --accept-package-agreements --verbose | Out-String
#endregion