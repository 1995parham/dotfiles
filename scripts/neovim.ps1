# Neovim installation and configuration for Windows
# Ported from neovim.sh

function Get-Usage {
    return @"
hyperextensible Vim-based text editor (plugins, theme, etc.)
                       _
 _ __   ___  _____   _(_)_ __ ___
| '_ \ / _ \/ _ \ \ / / | '_ ` _ \
| | | |  __/ (_) \ V /| | | | | | |
|_| |_|\___|\___/ \_/ |_|_| |_| |_|

"@
}

# Dependencies (neovim-core is just "Neovim.Neovim" in winget, installed via env)
$script:dependencies = @("env")

function Install-LspServers {
    Write-Message -Module "neovim" -Message "installing LSP servers"
    Require-Npm "@mistweaverco/kulala-ls"
}

function main_winget {
    Write-Message -Module "neovim" -Message "neovim should be installed via env script"

    # Install nvim-remote via pip
    Write-Message -Module "neovim" -Message "installing nvim-remote"
    Require-Pip "nvim-remote"
}

function main {
    $nvimConfigPath = Join-Path $env:LOCALAPPDATA "nvim"

    # Check if config directory exists
    if (Test-Path $nvimConfigPath) {
        Push-Location $nvimConfigPath

        try {
            $url = git remote get-url origin 2>$null

            if ($url -match "github\.com[:/]1995parham/elievim") {
                Write-Message -Module "neovim" -Message "valid repository, fetching updates"
                git pull origin main

                Pop-Location
                Install-LspServers

                Write-Message -Module "neovim" -Message "syncing plugins"
                nvim --headless "+Lazy! sync" +qa

                return
            }
            else {
                Write-Message -Module "neovim" -Message "invalid repository: $url"

                Pop-Location

                if (Yes-Or-No -Module "neovim" -Question "do you want to remove current neovim configuration?") {
                    Write-Message -Module "neovim" -Message "removing current configuration"
                    Remove-Item -Path $nvimConfigPath -Recurse -Force
                }
                else {
                    return
                }
            }
        }
        catch {
            Pop-Location

            if (Yes-Or-No -Module "neovim" -Question "do you want to remove current neovim configuration?") {
                Write-Message -Module "neovim" -Message "removing current configuration"
                Remove-Item -Path $nvimConfigPath -Recurse -Force
            }
            else {
                return
            }
        }
    }

    # Clone ElieVIM configuration
    Write-Message -Module "neovim" -Message "cloning ElieVIM configuration"
    Clone-Repo -Repo "https://github.com/1995parham/elievim" -Path $env:LOCALAPPDATA -Dir "nvim"

    # Install LSP servers
    Install-LspServers

    # Sync plugins
    Write-Message -Module "neovim" -Message "syncing plugins (this may take a while)"
    nvim --headless "+Lazy! sync" +qa

    Write-Message -Module "neovim" -Message "neovim setup complete!" -Severity "success"
}
