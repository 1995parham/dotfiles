New-Module -Name gopass -ScriptBlock {
    function Install-Main {
        scoop install gopass
        winget install Gpg4win
        Write-Output 'please install gopass-jsonapi from its source to configure gopass extension'
    }
}
