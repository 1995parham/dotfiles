New-Module -Name gopass -ScriptBlock {
    function Install-Main {
        scoop install gopass
        sudo choco install gpg4win
    }
}