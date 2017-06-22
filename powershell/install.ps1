Write-Output "[profile] Hello to parham powershell setup"
Write-Output "[profile] Powershell profile: $profile"
Write-Output "[profile] Powershell script location: $PSScriptRoot"

Write-Output "[profile] create profile configuration"
New-Item -Path $profile -ItemType "file" -Force
Remove-Item $profile
if (Get-Command ls -errorAction SilentlyContinue)
{
	Write-Output "[profile] symbolic link :)"
	ln -s "$PSScriptRoot/Microsoft.PowerShell_profile.ps1" $profile
} else {
	Write-Output "[profile] hard copy :("
        Copy-Item "$PSScriptRoot/Microsoft.PowerShell_profile.ps1"  $profile
}
