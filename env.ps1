# get username
$username = get-wmiobject win32_computersystem | Select-Object username | Out-String # EVERTZ_MICROSYS\username

$username = $username.username.ToString().Split('\')[-1]

Write-Output "username: $username"

Get-ChildItem env:* | Sort-Object name

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
