New-Module -Name gopass -ScriptBlock {
    function Install-Main {
        scoop install gopass gpg4win
    }
}