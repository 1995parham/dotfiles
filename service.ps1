# PowerShell service management library for Windows
# Extends service.sh with Windows service support

# Detect the service manager type based on the operating system
function Get-ServiceManager {
    if ($IsWindows -or $env:OS -match "Windows") {
        return "sc"
    }
    elseif ($IsMacOS) {
        return "launchctl"
    }
    elseif ($IsLinux) {
        if (Get-Command systemctl -ErrorAction SilentlyContinue) {
            return "systemctl"
        }
    }
    return "unknown"
}

# Start a service
function Start-ServiceManager {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ServiceName,
        [string]$ServiceManager = ""
    )

    if (-not $ServiceManager) {
        $ServiceManager = Get-ServiceManager
    }

    switch ($ServiceManager) {
        "sc" {
            Start-Service -Name $ServiceName
        }
        "launchctl" {
            sudo launchctl kickstart -k "system/$ServiceName"
        }
        "systemctl" {
            systemctl start $ServiceName
        }
        default {
            Write-Message -Module "service" -Message "Unknown service manager: $ServiceManager" -Severity "error"
            return $false
        }
    }
    return $true
}

# Stop a service
function Stop-ServiceManager {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ServiceName,
        [string]$ServiceManager = ""
    )

    if (-not $ServiceManager) {
        $ServiceManager = Get-ServiceManager
    }

    switch ($ServiceManager) {
        "sc" {
            Stop-Service -Name $ServiceName
        }
        "launchctl" {
            sudo launchctl kill SIGTERM "system/$ServiceName"
        }
        "systemctl" {
            systemctl stop $ServiceName
        }
        default {
            Write-Message -Module "service" -Message "Unknown service manager: $ServiceManager" -Severity "error"
            return $false
        }
    }
    return $true
}

# Restart a service
function Restart-ServiceManager {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ServiceName,
        [string]$ServiceManager = ""
    )

    if (-not $ServiceManager) {
        $ServiceManager = Get-ServiceManager
    }

    switch ($ServiceManager) {
        "sc" {
            Restart-Service -Name $ServiceName
        }
        "launchctl" {
            sudo launchctl kill SIGTERM "system/$ServiceName"
            Start-Sleep -Seconds 1
            sudo launchctl kickstart -k "system/$ServiceName"
        }
        "systemctl" {
            systemctl restart $ServiceName
        }
        default {
            Write-Message -Module "service" -Message "Unknown service manager: $ServiceManager" -Severity "error"
            return $false
        }
    }
    return $true
}

# Get a human-readable name for the service manager
function Get-ServiceManagerName {
    param(
        [string]$ServiceManager = ""
    )

    if (-not $ServiceManager) {
        $ServiceManager = Get-ServiceManager
    }

    switch ($ServiceManager) {
        "sc" {
            return "windows, using services"
        }
        "launchctl" {
            return "darwin, using launchctl"
        }
        "systemctl" {
            return "linux, using systemd"
        }
        default {
            return "unknown service manager"
        }
    }
}

# Export functions
Export-ModuleMember -Function @(
    'Get-ServiceManager',
    'Start-ServiceManager',
    'Stop-ServiceManager',
    'Restart-ServiceManager',
    'Get-ServiceManagerName'
)
