#!/usr/bin/env pwsh

function Get-Usage {
    return @"
git configuration useful on systems with ssh keys used by @1995parham/@elaheh-dastan
       _ _
  __ _(_) |_
 / _` | | __|
| (_| | | |_
 \__, |_|\__|
 |___/
"@
}

function main_winget {}

function main {
    git config --global user.name "Parham Alvani"
    git config --global user.email "parham.alvani@gmail.com"
}