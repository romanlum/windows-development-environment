Disable-UAC

# Configure Windows
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar

#--- Windows Settings ---
Disable-BingSearch
Disable-GameBarTips

##################
# Privacy Settings
# https://gist.github.com/NickCraver/7ebf9efbfd0c3eab72e9
##################

# Privacy: Let apps use my advertising ID: Disable
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -Type DWord -Value 0
# To Restore:
#Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -Type DWord -Value 1
# Privacy: SmartScreen Filter for Store Apps: Disable
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost -Name EnableWebContentEvaluation -Type DWord -Value 0
# To Restore:
#Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost -Name EnableWebContentEvaluation -Type DWord -Value 1

# WiFi Sense: HotSpot Sharing: Disable
Set-ItemProperty -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting -Name value -Type DWord -Value 0
# WiFi Sense: Shared HotSpot Auto-Connect: Disable
Set-ItemProperty -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots -Name value -Type DWord -Value 0


# Start Menu: Disable Bing Search Results
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name BingSearchEnabled -Type DWord -Value 0
# To Restore (Enabled):
# Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name BingSearchEnabled -Type DWord -Value 1

############################
# Personal Preferences on UI
############################

# Change Explorer home screen back to "This PC"
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Type DWord -Value 1
# Change it back to "Quick Access" (Windows 10 default)
#Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Type DWord -Value 2

# These make "Quick Access" behave much closer to the old "Favorites"
# Disable Quick Access: Recent Files
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowRecent -Type DWord -Value 0
# Disable Quick Access: Frequent Folders
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowFrequent -Type DWord -Value 0
# To Restore:
#Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowRecent -Type DWord -Value 1
#Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowFrequent -Type DWord -Value 1

# Disable the Lock Screen (the one before password prompt - to prevent dropping the first character)
If (-Not (Test-Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization)) {
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows -Name Personalization | Out-Null
}
Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization -Name NoLockScreen -Type DWord -Value 1
# To Restore:
#Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization -Name NoLockScreen -Type DWord -Value 1




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

# Disney Magic Kingdom
Get-AppxPackage *DisneyMagicKingdom* | Remove-AppxPackage

# Hidden City: Hidden Object Adventure
Get-AppxPackage *HiddenCityMysteryofShadows* | Remove-AppxPackage

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
cinst vcredist2008 -y
cinst vcredist2010 -y
cinst vcredist2012 -y
cinst vcredist2013 -y
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
