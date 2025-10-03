# PowerShell color and messaging library
# Simplified version with basic functionality

# Global yes_to_all variable
if (-not (Test-Path variable:script:yes_to_all)) {
    $script:yes_to_all = 0
}

function Colorize {
    param(
        [string]$Color,
        [string]$Text
    )
    Write-Host $Text -NoNewline -ForegroundColor $Color
}

function Yes-Or-No {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Module,
        [Parameter(Mandatory=$true)]
        [string]$Question
    )

    if ($script:yes_to_all -eq 1) {
        return $true
    }

    while ($true) {
        Write-Host "[$Module] " -NoNewline -ForegroundColor Yellow
        Write-Host "$Question " -NoNewline -ForegroundColor Magenta
        Write-Host "[" -NoNewline
        Write-Host "y" -NoNewline -ForegroundColor Green
        Write-Host "/" -NoNewline
        Write-Host "n" -NoNewline -ForegroundColor Red
        Write-Host "]: " -NoNewline
        $response = Read-Host

        switch -Regex ($response) {
            '^[Yy]' { return $true }
            '^[Nn]' {
                Write-Host "Aborted" -ForegroundColor Yellow
                return $false
            }
        }
    }
}

function Write-Message {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Module,
        [string]$Message = "",
        [string]$Severity = "info"
    )

    $color = "Cyan"

    switch ($Severity) {
        "info" { $color = "Cyan" }
        "error" { $color = "Red" }
        "notice" { $color = "Magenta" }
        "warn" { $color = "Yellow" }
        "success" { $color = "Green" }
        "debug" { $color = "DarkGray" }
    }

    Write-Host "[$Module] " -NoNewline -ForegroundColor $color
    Write-Host $Message -ForegroundColor $color
}

function Write-Running {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Module,
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    Write-Host "[$Module] " -NoNewline -ForegroundColor Yellow
    Write-Host $Message -ForegroundColor Yellow
}

function Write-Action {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Module,
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    Write-Host "[$Module] " -NoNewline -ForegroundColor Yellow
    Write-Host $Message -ForegroundColor Yellow
}

function Write-Ok {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Module,
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    Write-Host "[$Module] " -NoNewline -ForegroundColor Green
    Write-Host $Message -ForegroundColor Green
}

function Write-SectionHeader {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Title,
        [int]$Width = 60,
        [string]$Char = "="
    )

    Write-Host ""
    Write-Host ($Char * $Width) -ForegroundColor Yellow
    Write-Host " $Title " -ForegroundColor Yellow
    Write-Host ($Char * $Width) -ForegroundColor Yellow
    Write-Host ""
}

function Write-ListItem {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Item,
        [string]$Status = "",
        [int]$Indent = 0
    )

    $prefix = "  " * $Indent
    $color = "Yellow"

    switch ($Status) {
        { $_ -in @("success", "done") } { $color = "Green" }
        { $_ -in @("error", "failed") } { $color = "Red" }
        { $_ -in @("warning", "warn") } { $color = "Yellow" }
        { $_ -in @("info") } { $color = "Cyan" }
    }

    Write-Host "$prefix$Item" -ForegroundColor $color
}

# Functions are automatically available when dot-sourced
