# PowerShell package management library
# Ported from require.sh for Windows compatibility

# Install packages using winget
function Require-Winget {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$Packages
    )

    $toInstall = @()

    foreach ($pkg in $Packages) {
        Write-Running -Module "require" -Message " winget $pkg"

        # Check if package is already installed
        $installed = winget list --id $pkg --exact 2>&1 | Select-String -Pattern $pkg -Quiet

        if (-not $installed) {
            $toInstall += $pkg
        }
    }

    if ($toInstall.Count -gt 0) {
        Write-Action -Module "require" -Message " winget install $($toInstall -join ' ')"
        foreach ($pkg in $toInstall) {
            winget install --id $pkg --exact --accept-source-agreements --accept-package-agreements
        }
    }
}

# Install Go packages
function Require-Go {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Package,
        [string]$Version = "latest"
    )

    Write-Action -Module "require" -Message " go $Package @ $Version"

    $env:GO111MODULE = "on"
    & go install "$Package@$Version" 2>$null
}

# Install Python packages using pipx
function Require-Pip {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$Packages
    )

    foreach ($pkg in $Packages) {
        # Check for version specification
        $notSpecificVersion = $true
        if ($pkg -match '@') {
            $notSpecificVersion = $false
        }

        # Remove version specification and trim spaces
        $name = ($pkg -split '@')[0].Trim()

        Write-Running -Module "require" -Message " python $name ($pkg)"

        # Check if already installed
        $installed = pipx list 2>&1 | Select-String -Pattern $name -Quiet

        if ($notSpecificVersion -and $installed) {
            Write-Action -Module "require" -Message " pipx upgrade $name ($pkg)"
            pipx upgrade $pkg
        }
        else {
            if ($notSpecificVersion) {
                Write-Action -Module "require" -Message " pipx install $name ($pkg)"
                pipx install --include-deps $pkg
            }
            else {
                Write-Action -Module "require" -Message " pipx install by force $name ($pkg)"
                pipx install --include-deps --force $pkg
            }
        }
    }
}

# Install Node.js packages using npm
function Require-Npm {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$Packages
    )

    foreach ($pkg in $Packages) {
        Write-Action -Module "require" -Message " node $pkg"

        # Check if package is installed globally
        $installed = npm list -g $pkg 2>&1 | Select-String -Pattern $pkg -Quiet

        if (-not $installed) {
            npm install -g $pkg
        }
    }
}

# Clone git repository
function Clone-Repo {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Repo,
        [string]$Path = ".",
        [string]$Dir = "",
        [string]$PushUrl = ""
    )

    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }

    # Extract repo name from URL
    $repoName = $Repo -replace '.*[:/](.+?)(\.git)?$', '$1'

    if ($Dir -eq "") {
        $Dir = Split-Path -Leaf $repoName
    }

    $targetPath = Join-Path $Path $Dir

    if (-not (Test-Path $targetPath)) {
        Write-Action -Module "git" -Message "$repoName cloning..."

        try {
            git clone $Repo $targetPath *>&1 | Out-Null
            Write-Action -Module "git" -Message "$repoName ${script:F_SUCCESS}$script:CHECK_MARK${script:ALL_RESET}"
        }
        catch {
            Write-Action -Module "git" -Message "$repoName ${script:F_ERROR}$script:CROSS_MARK${script:ALL_RESET}"
            return
        }
    }
    else {
        Push-Location $targetPath

        $originUrl = git remote get-url origin 2>$null
        $originUrl = $originUrl -replace '\.git$', ''
        $compareRepo = $Repo -replace '\.git$', ''

        if ($compareRepo -eq $originUrl) {
            Write-Action -Module "git" -Message "$repoName ${script:F_DEBUG}already exists${script:ALL_RESET}"
        }
        else {
            Write-Action -Module "git" -Message "$repoName ($Repo != $originUrl) ${script:F_ERROR}$script:CROSS_MARK${script:ALL_RESET}"
        }

        Pop-Location
    }

    # Add push URL if specified
    if ($PushUrl -ne "") {
        Push-Location $targetPath

        $existingPushUrls = git remote get-url origin --all 2>$null

        if ($existingPushUrls -match [regex]::Escape($PushUrl)) {
            Write-Action -Module "git" -Message "$repoName pushurl -> $PushUrl ${script:F_DEBUG}$script:CHECK_MARK${script:ALL_RESET}"
        }
        else {
            try {
                git remote set-url --add origin $PushUrl *>&1 | Out-Null
                Write-Action -Module "git" -Message "$repoName pushurl -> $PushUrl ${script:F_SUCCESS}$script:CHECK_MARK${script:ALL_RESET}"
            }
            catch {
                Write-Action -Module "git" -Message "$repoName pushurl -> $PushUrl ${script:F_ERROR}$script:CROSS_MARK${script:ALL_RESET}"
            }
        }

        Pop-Location
    }
}

# Install Mason packages for Neovim
function Require-Mason {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$Packages
    )

    foreach ($pkg in $Packages) {
        Write-Action -Module "require" -Message " neovim + mason $pkg"
        nvim "+MasonInstall $pkg" --headless +qall 2>$null
    }
}

# Export functions
Export-ModuleMember -Function @(
    'Require-Winget',
    'Require-Go',
    'Require-Pip',
    'Require-Npm',
    'Clone-Repo',
    'Require-Mason'
)
