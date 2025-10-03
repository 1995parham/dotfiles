# Basic environment setup for Windows
# Ported from env.sh

function Get-Usage {
    return @"
installs required packages for having a working system
  ___ _ ____   __
 / _ \ |_ \ \ / /
|  __/ | | \ V /
 \___|_| |_|\_/

"@
}

# Dependencies (will be installed first if available)
$script:dependencies = @()

# Basic packages to install via winget
$packages = @(
    "Git.Git"
    "Microsoft.PowerShell"
    "Python.Python.3.12"
    "GoLang.Go"
    "OpenJS.NodeJS"
    "BurntSushi.ripgrep.MSVC"
    "sharkdp.bat"
    "sharkdp.fd"
    "junegunn.fzf"
    "jqlang.jq"
    "GNU.Wget2"
    "aria2.aria2"
    "vim.vim"
    "Neovim.Neovim"
    "ajeetdsouza.zoxide"
    "dandavison.delta"
    "eza-community.eza"
    "aristocratos.btop"
    "mosh.mosh"
)

function main_winget {
    Write-Message -Module "env" -Message "installing packages with winget"

    foreach ($package in $packages) {
        Write-Running -Module "require" -Message " winget $package"
        Require-Winget $package
    }

    # Install pipx for Python package management
    Write-Message -Module "env" -Message "setting up pipx"
    python -m pip install --user pipx
    python -m pipx ensurepath

    # Install global Python tools
    Write-Message -Module "env" -Message "installing Python tools"
    Require-Pip "tmuxp" "pre-commit"
}

function main {
    Write-Message -Module "env" -Message "basic environment setup complete" -Severity "success"

    Write-Host ""
    Write-Message -Module "env" -Message "You may need to restart your shell for PATH changes to take effect" -Severity "notice"
}
