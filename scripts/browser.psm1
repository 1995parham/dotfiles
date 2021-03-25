New-Module -Name browser -ScriptBlock {
        function Install-Main {
                Write-Output "install firefox browser"
                sudo choco install firefox
        }
}