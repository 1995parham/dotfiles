# Python installation for Windows
# Ported from python.sh

$packages = @(
    # An extremely fast Python package and project manager, written in Rust.
    "uv",
    # Pipenv is a production-ready tool that aims to bring the best of all
    # packaging worlds to the Python world.
    "pipenv",
    # Poetry is a tool for dependency management and packaging in Python.
    "poetry"
)

function Get-Usage {
    return @"
python with useful tools for science and phd
             _   _
 _ __  _   _| |_| |__   ___  _ __
| '_ \| | | | __| '_ \ / _ \| '_ \
| |_) | |_| | |_| | | | (_) | | | |
| .__/ \__, |\__|_| |_|\___/|_| |_|
|_|    |___/

"@
}

function Install-PythonPackages {
    Write-Message -Module "python" -Message "installing user-local packages"
    Write-Message -Module "python" -Message "these packages generally are there for dependency management"

    foreach ($package in $packages) {
        Require-Pip $package
    }
}

function main_winget {
    # Install Python and pipx
    Require-Winget "Python.Python.3.12"

    Write-Message -Module "python" -Message "ensuring pipx is available"

    # Check if pipx is installed, if not install it with pip
    try {
        $pipxVersion = pipx --version 2>$null
        if (-not $pipxVersion) {
            throw "pipx not found"
        }
        Write-Message -Module "python" -Message "pipx is already installed" -Severity "debug"
    }
    catch {
        Write-Action -Module "python" -Message "installing pipx via pip"
        python -m pip install --user pipx
        python -m pipx ensurepath
    }

    # Install pyenv for Windows
    Write-Message -Module "python" -Message "installing pyenv-win"
    Require-Winget "pyenv.pyenv-win"
}

function main {
    # Install Python packages
    Install-PythonPackages

    Write-Message -Module "python" -Message "python setup complete!" -Severity "success"
}
