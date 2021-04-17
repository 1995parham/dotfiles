New-Module -Name texlive -ScriptBlock {
    function Install-Main {
        Write-Output "installing texlive on windows with its official installer"
        New-Item -Type Directory texlive-install
        Invoke-WebRequest http://mirror.ctan.org/systems/texlive/tlnet/install-tl-windows.exe -OutFile texlive-install/install-tl-windows.exe
        ./install-tl-windows.exe
    }
}
