#!/usr/bin/env pwsh

function Get-Usage {
    return @"
Code editing. Redefined.
               _
  ___ ___   __| | ___
 / __/ _ \ / _` |/ _ \
| (_| (_) | (_| |  __/
 \___\___/ \__,_|\___|
"@
}

function main_winget {
    Require-Winget -Packages @("Microsoft.VisualStudioCode.CLI", "Microsoft.VisualStudioCode")
}

function main {
}