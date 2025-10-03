#Requires -Version 5.1

<#
.SYNOPSIS
    Dotfiles installation script for Windows
.DESCRIPTION
    PowerShell equivalent of start.sh for Windows-based installations
.PARAMETER ScriptName
    Name of the script to run (e.g., 'env', 'neovim', 'neovide')
.PARAMETER Help
    Display help information
.PARAMETER YesToAll
    Answer yes to all prompts
.EXAMPLE
    .\start.ps1 env
    .\start.ps1 neovim -YesToAll
#>

param(
    [Parameter(Position=0)]
    [string]$ScriptName = "",
    [switch]$Help,
    [Alias('y')]
    [switch]$YesToAll
)

$ErrorActionPreference = "Stop"

# Global variables
$script:root = $PSScriptRoot
$script:mainRoot = $PSScriptRoot
$script:yes_to_all = if ($YesToAll) { 1 } else { 0 }

# Load library functions
. (Join-Path $script:root "main.ps1")

function Show-Usage {
    Write-Host ""
    Write-Host "usage: .\start.ps1 [-y] [-h] script [script options]"
    Write-Host "  -h, -Help      display help"
    Write-Host "  -y, -YesToAll  yes to all prompts"
    Write-Host ""
    Write-Host " .\start.ps1 list for see available scripts"
    Write-Host ""
}

function Show-Header {
    Write-Host @"

  ____        _    __ _ _
 |  _ \  ___ | |_ / _(_) | ___  ___
 | | | |/ _ \| __| |_| | |/ _ \/ __|
 | |_| | (_) | |_|  _| | |  __/\__ \
 |____/ \___/ \__|_| |_|_|\___||___/

 Windows Edition

These scripts and repository created for personal use but I have tried to generalize it as much as I can.
Feel free to report issues at https://github.com/1995parham/dotfiles/issues or mailto:parham.alvani@gmail.com.

Best,
Parham Alvani

"@
}

function Resolve-ScriptName {
    param([string]$Script)

    switch ($Script) {
        "list" { return "lib\list" }
        default { return $Script }
    }
}

function Resolve-ScriptPath {
    param([string]$Script)

    $scriptPath = Join-Path $script:mainRoot "scripts\$Script.ps1"

    if (Test-Path $scriptPath) {
        return $scriptPath
    }

    return $null
}

function Invoke-ScriptInstall {
    # Detect Windows and call main_winget
    Write-Message -Module "pre" -Message "windows, using winget"

    if (Get-Command -Name "main_winget" -ErrorAction SilentlyContinue) {
        main_winget
    }
    else {
        Write-Message -Module "pre" -Message "main_winget not found, there is nothing to do" -Severity "error"
        exit 1
    }
}

function Invoke-ScriptRun {
    param([array]$ScriptArgs)

    $start = Get-Date

    if ($Help) {
        Show-Usage
        Write-Host ""
        if (Get-Command -Name "Get-Usage" -ErrorAction SilentlyContinue) {
            Get-Usage
        }
        return
    }

    # Create msg alias for Write-Message
    function script:msg {
        param([string]$Message, [string]$Severity = "info")
        Write-Message -Module $ScriptName -Message $Message -Severity $Severity
    }

    # Display usage
    if (Get-Command -Name "Get-Usage" -ErrorAction SilentlyContinue) {
        msg (Get-Usage)
    }

    # Handle dependencies
    if (Test-Path variable:script:dependencies) {
        Invoke-Dependencies $script:dependencies
    }

    # Run install
    Write-SectionHeader -Title "Install"
    Invoke-ScriptInstall

    # Run main if it exists
    if (Get-Command -Name "main" -ErrorAction SilentlyContinue) {
        Write-SectionHeader -Title "Main"
        main @ScriptArgs
    }

    # Run user-specific main if it exists
    $userMain = "main_$env:USERNAME"
    if (Get-Command -Name $userMain -ErrorAction SilentlyContinue) {
        Write-SectionHeader -Title "Attention on deck $env:USERNAME"
        & $userMain @ScriptArgs
    }

    Write-Host ""
    $took = ((Get-Date) - $start).TotalSeconds
    Write-Host "done. it took $([math]::Round($took, 0)) seconds."
}

function Invoke-Dependencies {
    param([array]$Dependencies)

    if ($Dependencies.Count -eq 0) {
        return
    }

    $output = "dependencies: |" + ($Dependencies -join "|") + "|"
    Write-Message -Module $ScriptName -Message $output

    if (Yes-Or-No -Module $ScriptName -Question "do you want to install dependencies?") {
        foreach ($dep in $Dependencies) {
            $depArgs = $dep -split '\s+'
            $flags = @()
            if ($script:yes_to_all -eq 1) {
                $flags += "-YesToAll"
            }

            & (Join-Path $script:mainRoot "start.ps1") @flags @depArgs
        }
    }
}

# Main execution
function Main {
    # Check for admin if needed (optional warning)
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Message -Module "pre" -Message "Not running as Administrator. Some features may not work." -Severity "warn"
    }

    Show-Header

    if (-not $ScriptName) {
        Show-Usage
        $ScriptName = "list"
    }

    # Resolve script name
    $resolvedScript = Resolve-ScriptName -Script $ScriptName
    $scriptPath = Resolve-ScriptPath -Script $resolvedScript

    if (-not $scriptPath) {
        Write-Message -Module "pre" -Message "404 script not found" -Severity "notice"
        Show-Usage
        exit 1
    }

    # Load and execute the script
    try {
        . $scriptPath
        Invoke-ScriptRun -ScriptArgs $args
    }
    catch {
        Write-Message -Module "pre" -Message "Failed to execute script: $_" -Severity "error"
        exit 1
    }
}

# Run main
Main
