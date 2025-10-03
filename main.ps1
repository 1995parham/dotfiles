# PowerShell library aggregator
# Ported from main.sh - loads all library scripts

$dotfileLibRoot = Split-Path -Parent $PSCommandPath

# Source all library modules
. (Join-Path $dotfileLibRoot "scripts\lib\message.ps1")
. (Join-Path $dotfileLibRoot "scripts\lib\require.ps1")
. (Join-Path $dotfileLibRoot "scripts\lib\service.ps1")

# Only load linker if root is set (similar to bash version)
if (Test-Path variable:script:root) {
    . (Join-Path $dotfileLibRoot "scripts\lib\linker.ps1")
}

# Export all functions from loaded modules
# PowerShell will automatically make these available when this script is dot-sourced
