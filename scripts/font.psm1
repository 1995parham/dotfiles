New-Module -Name font -ScriptBlock {
    function Install-Main {
        Write-Output "install fonts with Chocolatey"

        sudo choco.exe install vazir-font jetbrainsmono
    }
}