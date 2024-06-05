# Define the URL for downloading the latest version of Microsoft Teams Windows App
$teamsDownloadUrl = "https://go.microsoft.com/fwlink/?linkid=2243204&clcid=0x409"

# Define the path to download the installer
$installerPath = "$env:TEMP\TeamsBootstrapInstaller.exe"

# Function to check if Microsoft Teams Windows App is installed
function CheckIfTeamsInstalled {
    $teamsInstalled = Get-AppxPackage -AllUsers | Where-Object { $_.Name -eq "MSTeams" }
    return [bool]$teamsInstalled
}

# Function to get the installed version of Microsoft Teams Windows App
function GetTeamsInstalledVersion {
    $teamsVersions = Get-AppxPackage -AllUsers | Where-Object { $_.Name -eq "MSTeams" } | Select-Object Version | Sort-Object
    if ($teamsVersions) {
        return $teamsVersions[0]
    } else {
        return $null
    }
}

# Function to install or update Microsoft Teams Windows App
function InstallOrUpdateTeams {
    # Check if Microsoft Teams Windows App is already installed
    $installedVersion = GetTeamsInstalledVersion
    if ($installedVersion) {
        Write-Host "Microsoft Teams Windows App version $installedVersion is already installed."

        # Check for latest version
        # $wingetTeams = Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/winget-pkgs/contents/manifests/m/Microsoft/Teams"
        # $wingetTeamsLatestIndex = ($wingetTeams.Count - 3) # subtract 3 to avoid "classic" & "free" versions
        # $teamsLatestVersion = ($wingetTeams.item($wingetTeamsLatestIndex)).Name

        $teamsLatestVersion = ((Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/winget-pkgs/commits?path=manifests/m/Microsoft/Teams&per_page=100").commit | Where-Object message -like "*Microsoft.Teams version*").message.split(" ")[4]

        if ($installedVersion -ne $teamsLatestVersion) {
            Write-Host "Microsoft Teams Windows App is outdated (Installed: $installedVersion Latest: $teamsLatestVersion). Updating..."
            try {
                # Download the latest version of Microsoft Teams Windows App
                Invoke-WebRequest -Uri $teamsDownloadUrl -OutFile $installerPath
                Write-Output "Downloaded teams from $teamsDownloadUrl at $installerPath"

                # Install Microsoft Teams Windows App silently
                Start-Process -FilePath $installerPath -Wait -ArgumentList "/silent"

                # Clean up the installer
                Remove-Item $installerPath

                Write-Host "Microsoft Teams Windows App has been updated successfully."
            } catch {
                Write-Host "Failed to update Microsoft Teams Windows App. Error: $_"
            }
        }
    } else {
        Write-Host "Microsoft Teams Windows App is not installed. Downloading and installing..."
        try {
            # Download the latest version of Microsoft Teams Windows App
            Invoke-WebRequest -Uri $teamsDownloadUrl -OutFile $installerPath
            Write-Output "Downloaded teams from $teamsDownloadUrl at $installerPath"

            # Install Microsoft Teams Windows App silently
            Start-Process -FilePath $installerPath -Wait -ArgumentList "-p"

            # Clean up the installer
            Remove-Item $installerPath

            Write-Host "Microsoft Teams Windows App has been installed successfully."
        } catch {
            Write-Host "Failed to install Microsoft Teams Windows App. Error: $_"
        }
    }
}

# Main script logic
InstallOrUpdateTeams