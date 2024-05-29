$winget = $null

# Function to check if Winget is installed
function Check-Winget {
    $DesktopAppInstaller = "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
    $SystemContext = Resolve-Path "$DesktopAppInstaller"

    if ($SystemContext) { $SystemContext = $SystemContext[-1].Path }

    $UserContext = Get-Command winget.exe -ErrorAction SilentlyContinue

    if ($UserContext) { $winget = $UserContext.Source }
    #elseif (Test-Path "$SystemContext\AppInstallerCLI.exe") { $winget = "$SystemContext\AppInstallerCLI.exe" }
    elseif (Test-Path "$SystemContext\winget.exe") { $winget = "$SystemContext\winget.exe" }
    else { return $false }

    if ($null -ne $winget) { 
        Write-Output "winget: $winget"
        Write-Output "winget version: $(& $winget --version)"
    }
    else {
        Write-Output "Winget is not installed. Please install Winget v1.7 or higher from https://github.com/microsoft/winget-cli/releases"
        exit 1
    }
}

# Function to update Winget
function Update-Winget {
    try {
        & $winget upgrade --id Microsoft.Winget.Client --accept-source-agreements --accept-package-agreements
        Write-Output "Winget has been updated."
    }
    catch {
        Write-Output "Failed to update Winget."
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
            & $winget install --id $App --source "winget" --exact --silent --accept-source-agreements --accept-package-agreements --verbose | Out-String
            Write-Output "$App has been installed."
        }
        catch {
            Write-Output "Failed to install $App."
        }
    }
}

# Check if Winget is installed
Check-Winget

# Update Winget to the latest version
Update-Winget

# List of applications to install
$appsToInstall = @(
    "Microsoft.Teams"   #MSTEAMS
)

# Install applications
Install-Apps -Apps $appsToInstall