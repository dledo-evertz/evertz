# get username
$username = get-wmiobject win32_computersystem | Select-Object username # EVERTZ_MICROSYS\username

$username = $username.username.ToString().Split('\')[-1]

Write-Output "username: $username"

# Override env vars to mimic local Administrator account
$env:APPDATA = "C:\Users\$username\AppData\Roaming"
$env:HOMEDRIVE = "C:"
$env:HOMEPATH = "\Users\$username"
$env:LANG = "en_US.UTF-8"
$env:LOCALAPPDATA = "C:\Users\$username\AppData\Local"
$env:OneDrive = "C:\Users\$username\OneDrive"
$env:TMP = "C:\Users\$username\AppData\Local\Temp"
$env:TEMP = "C:\Users\$username\AppData\Local\Temp"
$env:USERNAME = "$username"
$env:USERPROFILE = "C:\Users\$username"
""

Get-ChildItem env:* | Sort-Object name

# $winget = $null
# $DesktopAppInstaller = "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
# $SystemContext = Resolve-Path "$DesktopAppInstaller"
# if ($SystemContext) { $SystemContext = $SystemContext[-1].Path }
# $UserContext = Get-Command winget.exe -ErrorAction SilentlyContinue
# if ($UserContext) { $winget = $UserContext.Source }
# #elseif (Test-Path "$SystemContext\AppInstallerCLI.exe") { $winget = "$SystemContext\AppInstallerCLI.exe" }
# elseif (Test-Path "$SystemContext\winget.exe") { $winget = "$SystemContext\winget.exe" }
# else { return $false }
# if ($null -ne $winget) { $winget }
# # Logs $(env:LOCALAPPDATA)\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\DiagOutputDir
$winget = "C:\Users\$username\AppData\Local\Microsoft\WindowsApps\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\winget.exe"
Write-Output "winget: $winget"
& "$winget" --version
& "$winget" install --id "Microsoft.Teams" --source "winget" --exact --silent --accept-source-agreements --accept-package-agreements --verbose | Out-String
