if ($PSEdition -ne 'Core') {
    Write-Output 'switching to powershell core'
    winget install 'PowerShell' && pwsh.exe
}

Write-Output 'install oh-my-posh module'
Install-Module oh-my-posh -Scope CurrentUser

Write-Output 'install posh-git module'
Install-Module posh-git -Scope CurrentUser

Write-Output $profile
if ((Test-Path $profile -IsValid) -and ((Get-Item $profile).Target -eq "$PSScriptRoot\powershell\profile.ps1")) {
    Write-Output "$profile points to correct location"
} else {
    Remove-Item $profile || true
    sudo New-Item -Path $profile -ItemType SymbolicLink -Value $PSScriptRoot/powershell/profile.ps1
}