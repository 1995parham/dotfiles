# Neovide GUI installation for Windows
# Neovide is a graphical frontend for Neovim

function Get-Usage {
    return @"
install Neovide - a simple, no-nonsense, cross-platform graphical user interface for Neovim
    _   __                _     __
   / | / /__  ____ _   __(_)___/ /__
  /  |/ / _ \/ __ \ | / / / __  / _ \
 / /|  /  __/ /_/ / |/ / / /_/ /  __/
/_/ |_/\___/\____/|___/_/\__,_/\___/

"@
}

# Dependencies - neovim must be installed first
$script:dependencies = @("neovim")

function main_winget {
    Write-Message -Module "neovide" -Message "installing Neovide"

    # Install Neovide via winget
    Require-Winget "Neovide.Neovide"
}

function main {
    Write-Message -Module "neovide" -Message "Neovide installation complete!" -Severity "success"
    Write-Host ""
    Write-Message -Module "neovide" -Message "You can now launch Neovide from the Start Menu or by running 'neovide' in your terminal" -Severity "info"
}
