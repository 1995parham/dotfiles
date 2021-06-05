New-Module -Name browser -ScriptBlock {
        function Install-Main {
                Write-Output "install firefox browser"
                scoop install firefox
        }
}