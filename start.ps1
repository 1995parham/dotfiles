$script = $args[0]
Write-Output "load $script"

try {
        . "$PSScriptRoot/scripts/$script.ps1"
}
catch {
        Write-Error "failed to load [${script}], make sure the script exists"
        Exit
}

try {
        Action-Main
}
catch {
        Write-Error "failed to execute [${script}]: $($PSItem.ToString())"
}

Write-Output "complete"
