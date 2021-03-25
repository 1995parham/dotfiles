$script = $args[0]
Write-Output "loading $script..."

try {
        Import-Module "$PSScriptRoot/scripts/$script.psm1"
}
catch {
        Write-Error "failed to load [${script}], make sure the script exists"
        Exit
}

try {
        Install-Main
}
catch {
        Write-Error "failed to execute [${script}]: $($PSItem.ToString())"
}

Write-Output "complete $scirpt"
