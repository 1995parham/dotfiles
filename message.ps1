# PowerShell color and messaging library
# Ported from message.sh for Windows compatibility

# Base color palette - Vibrant RGB values for maximum visual impact
$script:F_CYAN = "$([char]27)[38;2;0;255;255m"
$script:F_GREEN = "$([char]27)[38;2;0;255;128m"
$script:F_RED = "$([char]27)[38;2;255;64;64m"
$script:F_ORANGE = "$([char]27)[38;2;255;140;0m"
$script:F_YELLOW = "$([char]27)[38;2;255;255;0m"
$script:F_GRAY = "$([char]27)[38;2;120;120;120m"
$script:F_BLUE = "$([char]27)[38;2;64;164;255m"
$script:F_PURPLE = "$([char]27)[38;2;186;85;211m"
$script:F_PINK = "$([char]27)[38;2;255;105;180m"
$script:F_WHITE = "$([char]27)[38;2;255;255;255m"
$script:F_BLACK = "$([char]27)[38;2;0;0;0m"

# Ultra-bright variants for maximum emphasis
$script:F_BRIGHT_GREEN = "$([char]27)[38;2;50;255;50m"
$script:F_BRIGHT_RED = "$([char]27)[38;2;255;50;50m"
$script:F_BRIGHT_YELLOW = "$([char]27)[38;2;255;255;50m"
$script:F_BRIGHT_BLUE = "$([char]27)[38;2;50;150;255m"
$script:F_BRIGHT_CYAN = "$([char]27)[38;2;50;255;255m"
$script:F_BRIGHT_PURPLE = "$([char]27)[38;2;200;100;255m"
$script:F_BRIGHT_ORANGE = "$([char]27)[38;2;255;165;50m"
$script:F_NEON_GREEN = "$([char]27)[38;2;57;255;20m"
$script:F_ELECTRIC_BLUE = "$([char]27)[38;2;0;191;255m"
$script:F_HOT_PINK = "$([char]27)[38;2;255;20;147m"

# Semantic colors for different purposes - Ultra vibrant assignments
$script:F_SUCCESS = $script:F_NEON_GREEN
$script:F_ERROR = $script:F_BRIGHT_RED
$script:F_WARNING = $script:F_BRIGHT_ORANGE
$script:F_INFO = $script:F_ELECTRIC_BLUE
$script:F_NOTICE = $script:F_HOT_PINK
$script:F_DEBUG = $script:F_BRIGHT_PURPLE
$script:F_HIGHLIGHT = $script:F_BRIGHT_ORANGE
$script:F_ACCENT = $script:F_BRIGHT_YELLOW

# Text formatting
$script:BOLD_ON = "$([char]27)[1m"
$script:BOLD_OFF = "$([char]27)[0m"
$script:ITALIC_ON = "$([char]27)[3m"
$script:ITALIC_OFF = "$([char]27)[23m"
$script:UNDERLINE_ON = "$([char]27)[4m"
$script:UNDERLINE_OFF = "$([char]27)[24m"
$script:DIM_ON = "$([char]27)[2m"
$script:DIM_OFF = "$([char]27)[22m"

# Reset and special formatting
$script:F_RESET = "$([char]27)[39m"
$script:ALL_RESET = "$([char]27)[0m"
$script:CLEAR_LINE = "$([char]27)[2K"

# Enhanced progress indicators
$script:CHECK_MARK = [char]0x2713  # ✓
$script:CROSS_MARK = [char]0x2717  # ✗
$script:WARNING_MARK = [char]0x26A0  # ⚠
$script:INFO_MARK = [char]0x24D8  # ⓘ
$script:ARROW_MARK = [char]0x21D2  # ⇒
$script:BULLET_MARK = [char]0x2022  # •

# Global yes_to_all variable
if (-not (Test-Path variable:script:yes_to_all)) {
    $script:yes_to_all = 0
}

function Colorize {
    param(
        [string]$Color,
        [string]$Text
    )
    Write-Host "${Color}${Text}${script:ALL_RESET}" -NoNewline
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
        Write-Host "${script:F_HIGHLIGHT}[$Module] ${script:F_NOTICE}$Question${script:F_RESET} [${script:F_SUCCESS}y${script:F_RESET}/${script:F_ERROR}n${script:F_RESET}]: " -NoNewline
        $response = Read-Host

        switch -Regex ($response) {
            '^[Yy]' { return $true }
            '^[Nn]' {
                Write-Host "${script:F_WARNING}Aborted${script:F_RESET}"
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

    $severityPrefix = ""
    $moduleColor = $script:F_INFO
    $messageColor = $script:F_RESET

    switch ($Severity) {
        "info" {
            $moduleColor = $script:F_INFO
            $messageColor = $script:F_RESET
        }
        "error" {
            $severityPrefix = "${script:F_ERROR}${script:BOLD_ON} ($script:CROSS_MARK error) ${script:ALL_RESET}"
            $moduleColor = $script:F_ERROR
            $messageColor = $script:F_ERROR
        }
        "notice" {
            $severityPrefix = "${script:F_NOTICE}${script:BOLD_ON} ($script:INFO_MARK notice) ${script:ALL_RESET}"
            $moduleColor = $script:F_NOTICE
            $messageColor = $script:F_NOTICE
        }
        "warn" {
            $severityPrefix = "${script:F_WARNING}${script:BOLD_ON} ($script:WARNING_MARK warn) ${script:ALL_RESET}"
            $moduleColor = $script:F_WARNING
            $messageColor = $script:F_WARNING
        }
        "success" {
            $severityPrefix = "${script:F_SUCCESS}${script:BOLD_ON} ($script:CHECK_MARK success) ${script:ALL_RESET}"
            $moduleColor = $script:F_SUCCESS
            $messageColor = $script:F_SUCCESS
        }
        "debug" {
            $severityPrefix = "${script:F_DEBUG}${script:DIM_ON} ($([char]0x1F41B) debug) ${script:ALL_RESET}"
            $moduleColor = $script:F_DEBUG
            $messageColor = $script:F_DEBUG
        }
    }

    Write-Host "${severityPrefix}${moduleColor}[$Module] ${messageColor}${Message}${script:ALL_RESET}"
}

function Write-Running {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Module,
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    Write-Host "${script:F_HIGHLIGHT}[$Module] ${script:F_ACCENT}$script:ARROW_MARK $Message${script:ALL_RESET}"
}

function Write-Action {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Module,
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    Write-Host "${script:F_WARNING}[$Module] ${script:F_ACCENT}$script:ARROW_MARK $Message${script:ALL_RESET}"
}

function Write-Ok {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Module,
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    Write-Host "${script:F_SUCCESS}[$Module] ${script:F_ACCENT}$script:ARROW_MARK $Message${script:ALL_RESET}"
}

function Write-SectionHeader {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Title,
        [int]$Width = 60,
        [string]$Char = "="
    )

    Write-Host ""
    Write-Host "${script:F_ACCENT}${script:BOLD_ON}" -NoNewline
    Write-Host ($Char * $Width)
    Write-Host " $Title "
    Write-Host ($Char * $Width)
    Write-Host "${script:ALL_RESET}"
}

function Write-ListItem {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Item,
        [string]$Status = "",
        [int]$Indent = 0
    )

    $prefix = "  " * $Indent

    switch ($Status) {
        { $_ -in @("success", "done", "✓") } {
            Write-Host "${prefix}${script:F_SUCCESS}$script:CHECK_MARK $Item${script:ALL_RESET}"
        }
        { $_ -in @("error", "failed", "✗") } {
            Write-Host "${prefix}${script:F_ERROR}$script:CROSS_MARK $Item${script:ALL_RESET}"
        }
        { $_ -in @("warning", "warn", "⚠") } {
            Write-Host "${prefix}${script:F_WARNING}$script:WARNING_MARK $Item${script:ALL_RESET}"
        }
        { $_ -in @("info", "ⓘ") } {
            Write-Host "${prefix}${script:F_INFO}$script:INFO_MARK $Item${script:ALL_RESET}"
        }
        default {
            Write-Host "${prefix}${script:F_ACCENT}$script:BULLET_MARK $Item${script:ALL_RESET}"
        }
    }
}

# Export functions
Export-ModuleMember -Function @(
    'Colorize',
    'Yes-Or-No',
    'Write-Message',
    'Write-Running',
    'Write-Action',
    'Write-Ok',
    'Write-SectionHeader',
    'Write-ListItem'
)
