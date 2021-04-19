New-Module -Name texlive -ScriptBlock {
    function Install-Main {
        Write-Output "installing texlive on windows with its official installer"

        
        if (-not(Test-Path -Path ./texlive-installer)) {
            New-Item -Type Directory texlive-installer
            Invoke-WebRequest http://mirror.ctan.org/systems/texlive/tlnet/install-tl-windows.exe -OutFile texlive-installer/install-tl-windows.exe
        }

        ./texlive-installer/install-tl-windows.exe
    }
}
