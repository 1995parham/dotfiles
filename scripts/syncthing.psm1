New-Module -Name nu -ScriptBlock {
    function Install-Main {
        Write-Output "installing syncthing on windows"

        scoop install syncthing syncthingtray
    }
}