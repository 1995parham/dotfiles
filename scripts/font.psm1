New-Module -Name font -ScriptBlock {
    function Install-Main {
        Write-Output "install fonts"

        scoop bucket add nerd-fonts
        sudo scoop install Meslo-NF JetBrains-Mono
    }
}