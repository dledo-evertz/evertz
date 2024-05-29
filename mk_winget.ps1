$global:winget = $null

# Function to check if Winget is installed
function Check-Winget {
    # $DesktopAppInstaller = "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
    # $SystemContext = Resolve-Path "$DesktopAppInstaller"

    # if ($SystemContext) { $SystemContext = $SystemContext[-1].Path }

    # $UserContext = Get-Command winget.exe -ErrorAction SilentlyContinue

    # if ($UserContext) { $global:winget = $UserContext.Source }
    # #elseif (Test-Path "$SystemContext\AppInstallerCLI.exe") { $winget = "$SystemContext\AppInstallerCLI.exe" }
    # elseif (Test-Path "$SystemContext\winget.exe") { $winget = "$SystemContext\winget.exe" }
    # else { return $false }

    # hack
    # get username
    $username = get-wmiobject win32_computersystem | Select-Object username # EVERTZ_MICROSYS\username
    $username = $username.username.ToString().Split('\')[-1]
    Write-Output "username: $username"
    $global:winget = "C:\Users\$username\AppData\Local\Microsoft\WindowsApps\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\winget.exe"

    if ($null -ne $global:winget) { 
        Write-Output "winget: $global:winget"
        Write-Output "winget version: $(& $global:winget --version)"
    }
    else {
        Write-Output "Winget is not installed. Please install Winget v1.7 or higher from https://github.com/microsoft/winget-cli/releases"
        exit 1
    }
}

# Function to update Winget
function Update-Winget {
    try {
        & $global:winget upgrade --id Microsoft.Winget.Client --accept-source-agreements --accept-package-agreements --verbose
        Write-Output "Winget has been updated."
    }
    catch {
        Write-Warning "Failed to update winget"
        Write-Warning $Error
        exit 1
    }
}

# Function to install applications using Winget
function Install-Apps {
    param (
        [Parameter(Mandatory = $true)]
        [string[]] $Apps
    )

    foreach ($App in $Apps) {
        try {
            & $global:winget install --id $App --source "winget" --exact --accept-source-agreements --accept-package-agreements --verbose
            Write-Output "$App has been installed."
        }
        catch {
            Write-Warning "Failed to install $App"
            Write-Warning $Error[0]
        }
    }
}

# Check if Winget is installed
Check-Winget

# Update Winget to the latest version
#Update-Winget

# List of applications to install
$appsToInstall = @(
    "Microsoft.Teams"   #MSTEAMS
)

# Install applications
Install-Apps -Apps $appsToInstall