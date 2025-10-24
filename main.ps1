# PowerShell library aggregator
# Ported from main.sh - loads all library scripts

$dotfileLibRoot = Split-Path -Parent $PSCommandPath

# Source all library modules
. (Join-Path $dotfileLibRoot "message.ps1")
. (Join-Path $dotfileLibRoot "require.ps1")
. (Join-Path $dotfileLibRoot "service.ps1")

# Only load linker if root is set (similar to bash version)
if (Test-Path variable:script:root) {
    . (Join-Path $dotfileLibRoot "linker.ps1")
}

# Export all functions from loaded modules
# PowerShell will automatically make these available when this script is dot-sourced
