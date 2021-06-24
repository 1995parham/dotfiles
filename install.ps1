if ($PSEdition -ne 'Core') {
    Write-Output 'switching to powershell core'
    winget install 'PowerShell' && pwsh.exe
}

Write-Output 'install oh-my-posh module'
Install-Module oh-my-posh -Scope CurrentUser

Write-Output 'install posh-git module'
Install-Module posh-git -Scope CurrentUser

Write-Output $profile
New-Item -Path $profile -ItemType HardLink -Value $PSScriptRoot/powershell/profile.ps1