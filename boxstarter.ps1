Disable-UAC

# Configure Windows
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar

#--- Windows Settings ---
Disable-BingSearch
Disable-GameBarTips

#--- Uninstall unecessary applications that come with Windows out of the box ---

# 3D Builder
Get-AppxPackage Microsoft.3DBuilder | Remove-AppxPackage

# Alarms
Get-AppxPackage Microsoft.WindowsAlarms | Remove-AppxPackage

# Autodesk
Get-AppxPackage *Autodesk* | Remove-AppxPackage

# Bing Weather, News, Sports, and Finance (Money):
Get-AppxPackage Microsoft.BingFinance | Remove-AppxPackage
Get-AppxPackage Microsoft.BingNews | Remove-AppxPackage
Get-AppxPackage Microsoft.BingSports | Remove-AppxPackage
Get-AppxPackage Microsoft.BingWeather | Remove-AppxPackage

# BubbleWitch
Get-AppxPackage *BubbleWitch* | Remove-AppxPackage

# Candy Crush
Get-AppxPackage king.com.CandyCrush* | Remove-AppxPackage

# Comms Phone
Get-AppxPackage Microsoft.CommsPhone | Remove-AppxPackage

# Dell
Get-AppxPackage *Dell* | Remove-AppxPackage

# Dropbox
Get-AppxPackage *Dropbox* | Remove-AppxPackage

# Facebook
Get-AppxPackage *Facebook* | Remove-AppxPackage

# Feedback Hub
Get-AppxPackage Microsoft.WindowsFeedbackHub | Remove-AppxPackage

# Get Started
Get-AppxPackage Microsoft.Getstarted | Remove-AppxPackage

# Keeper
Get-AppxPackage *Keeper* | Remove-AppxPackage

# March of Empires
Get-AppxPackage *MarchofEmpires* | Remove-AppxPackage

# McAfee Security
Get-AppxPackage *McAfee* | Remove-AppxPackage

# Uninstall McAfee Security App
$mcafee = gci "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_ -match "McAfee Security" } | select UninstallString
if ($mcafee) {
	$mcafee = $mcafee.UninstallString -Replace "C:\Program Files\McAfee\MSC\mcuihost.exe",""
	Write "Uninstalling McAfee..."
	start-process "C:\Program Files\McAfee\MSC\mcuihost.exe" -arg "$mcafee" -Wait
}


Update-ExecutionPolicy Unrestricted

Set-EnvironmentVariable -Name Cmder_Root  'C:\Program Files\Tools\cmdermini'        Machine $true
Set-EnvironmentVariable -Name Choco                   "C:\ProgramData\chocolatey"      Machine $true
Set-EnvironmentVariable -Name ChocolateyToolsLocation "C:\Program Files\Tools"      Machine $true
Set-EnvironmentVariable -Name ChocolateyInstall       "C:\ProgramData\chocolatey"      Machine $true


# Create-Shortcut -name "${env:ALLUSERSPROFILE}\Microsoft\Windows\Start Menu\Programs\Cmder" -target "%Cmder_Root%\Cmder.exe" -icon "%Cmder_Root%\icons\cmder.ico"


cinst -y Microsoft-Hyper-V-All -source windowsFeatures

## Git
cinst -y git.install
cinst -y poshgit

# Restart PowerShell / CMDer before moving on - or run
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

cinst Git-Credential-Manager-for-Windows

## docker
cinst -y docker-for-windows

## Editors
cinst -y visualstudiocode

## Visual Studio 2017 and extensions
cinst -y visualstudio2017enterprise
if (Test-PendingReboot) { Invoke-Reboot }
choco install resharper

## Basics
cinst -y vlc
cinst -y GoogleChrome
cinst -y 7zip.install
cinst -y sysinternals
cinst -y DotNet3.5
cinst -y adobereader
cinst -y keepass.install
cinst -y cmdermini
cinst -y paint.net
cinst -y totalcommander
if (Test-PendingReboot) { Invoke-Reboot }

# Pinning Things
Install-ChocolateyPinnedTaskBarItem "$env:programfiles\Google\Chrome\Application\chrome.exe"

# Cleanup
del C:\eula*.txt
del C:\install.*
del C:\vcredist.*
del C:\vc_red.*

# Let's get Updates, too
Enable-UAC
Enable-MicrosoftUpdate
