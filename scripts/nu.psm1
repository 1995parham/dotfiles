New-Module -Name nu -ScriptBlock {
    function Install-Main {
        Write-Output "installing nu on windows"

        scoop install nu starship

        Write-Output "$env:APPDATA"

        if (-not(Test-Path $enn:APPDATA/nushell/nu/config/config.toml)) {
            sudo New-Item -Path $env:APPDATA/nushell/nu/config -Name config.toml -ItemType SymbolicLink -Value $PSScriptRoot\..\nu\nu\config.toml
        }

    }
}