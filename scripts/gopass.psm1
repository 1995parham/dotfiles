New-Module -Name gopass -ScriptBlock {
    function Install-Main {
        scoop install gopass
        winget install Gpg4win
    }
}
