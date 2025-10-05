# Node.js installation for Windows
# Ported from node.sh

function Get-Usage {
    return @"
install nodejs, remembers language-servers most of the time needs nodejs
                 _
 _ __   ___   __| | ___
| '_ \ / _ \ / _` |/ _ \
| | | | (_) | (_| |  __/
|_| |_|\___/ \__,_|\___|

"@
}

function main_winget {
    # Install Node.js, pnpm, and fnm
    Require-Winget "OpenJS.NodeJS" "pnpm.pnpm" "Schniz.fnm"

    # Create Husky config directory
    $huskyDir = Join-Path $env:USERPROFILE ".config\husky"
    if (-not (Test-Path $huskyDir)) {
        New-Item -ItemType Directory -Path $huskyDir -Force | Out-Null
    }

    # Create init.sh with current PATH
    $initPath = Join-Path $huskyDir "init.sh"
    "PATH=`"$env:PATH`"" | Out-File -FilePath $initPath -Encoding utf8
}

function main {
    Write-Message -Module "node" -Message "$(node -v)" -Severity "success"

    # Install TypeScript language server via Mason
    Require-Mason "typescript-language-server"
}
