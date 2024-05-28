Get-ChildItem env:* | Sort-Object name

# Override env vars to mimic local Administrator account
$env:APPDATA = "C:\Users\Administrator\AppData\Roaming"
$env:LOCALAPPDATA = "C:\Users\Administrator\AppData\Local"
$env:OneDrive = "C:\Users\Administrator\OneDrive"
$env:TMP = "C:\Users\ADMINI~1\AppData\Local\Temp"
$env:TEMP = "C:\Users\ADMINI~1\AppData\Local\Temp"
$env:USERNAME = "Administrator"
$env:USERPROFILE = "C:\Users\Administrator"
""

Get-ChildItem env:* | Sort-Object name
