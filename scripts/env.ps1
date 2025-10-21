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
    "Microsoft.PowerShell.Preview"
    "BurntSushi.ripgrep.MSVC"
    "sharkdp.bat"
    "sharkdp.fd"
    "junegunn.fzf"
    "jqlang.jq"
    "GNU.Wget2"
    "aria2.aria2"
    "ajeetdsouza.zoxide"
    "dandavison.delta"
    "eza-community.eza"
)

function main_winget {
    msg "installing packages with winget"

    foreach ($package in $packages) {
        Write-Running -Module "require" -Message " winget $package"
        Require-Winget $package
    }

    # Install pipx for Python package management
    msg "setting up pipx"
    python -m pip install --user pipx
    python -m pipx ensurepath

    # Install global Python tools
    msg "installing Python tools"
    Require-Pip "tmuxp" "pre-commit"
}

function main {
    msg -Message "basic environment setup complete" -Severity "success"

    msg "You may need to restart your shell for PATH changes to take effect" -Severity "notice"
}
