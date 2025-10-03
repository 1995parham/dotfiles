# PowerShell file linking library for Windows
# Ported from linker.sh with Windows-specific adaptations

# Check if running with admin privileges
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Check if Developer Mode is enabled (allows symlinks without admin)
function Test-DeveloperMode {
    try {
        $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
        $devMode = Get-ItemProperty -Path $regPath -Name "AllowDevelopmentWithoutDevLicense" -ErrorAction SilentlyContinue
        return ($null -ne $devMode -and $devMode.AllowDevelopmentWithoutDevLicense -eq 1)
    }
    catch {
        return $false
    }
}

# Core linker function - creates symlinks or copies files
function Invoke-Linker {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Module,
        [Parameter(Mandatory=$true)]
        [string]$SrcPath,
        [Parameter(Mandatory=$true)]
        [string]$DstPath,
        [switch]$Copy
    )

    $createLink = $true

    # Check if destination already exists
    if ((Test-Path $DstPath) -or (Test-Path $DstPath -PathType Leaf)) {
        Write-Message -Module $Module -Message "$DstPath has already existed"

        # Check if it's a symlink pointing to the correct location
        if ((Get-Item $DstPath -Force -ErrorAction SilentlyContinue).LinkType -eq "SymbolicLink") {
            $target = (Get-Item $DstPath -Force).Target
            if ($target -eq $SrcPath) {
                Write-Message -Module $Module -Message "$DstPath points to the correct location"
                return
            }
        }

        if (Yes-Or-No -Module $Module -Question "do you want to remove $DstPath?") {
            Remove-Item -Path $DstPath -Recurse -Force
            Write-Action -Module $Module -Message "$DstPath is removed successfully"
        }
        else {
            $createLink = $false
        }
    }

    if ($createLink) {
        # Create parent directory if it doesn't exist
        $parentDir = Split-Path -Parent $DstPath
        if (-not (Test-Path $parentDir)) {
            New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
        }

        # Decide whether to symlink or copy
        $useSymlink = $false
        if (-not $Copy) {
            if (Test-Administrator) {
                $useSymlink = $true
            }
            elseif (Test-DeveloperMode) {
                $useSymlink = $true
            }
            else {
                Write-Message -Module $Module -Message "No admin rights or Developer Mode. Using copy instead of symlink." -Severity "warn"
            }
        }

        if ($useSymlink) {
            # Create symbolic link
            $itemType = if (Test-Path $SrcPath -PathType Container) { "Junction" } else { "SymbolicLink" }

            try {
                New-Item -ItemType $itemType -Path $DstPath -Target $SrcPath -Force | Out-Null
                Write-Action -Module $Module -Message "symbolic link created successfully from $SrcPath to $DstPath"
            }
            catch {
                Write-Message -Module $Module -Message "Failed to create symlink: $_" -Severity "error"
                Write-Message -Module $Module -Message "Falling back to copy" -Severity "warn"
                Copy-Item -Path $SrcPath -Destination $DstPath -Recurse -Force
                Write-Action -Module $Module -Message "copied successfully from $SrcPath to $DstPath"
            }
        }
        else {
            # Copy files
            Copy-Item -Path $SrcPath -Destination $DstPath -Recurse -Force
            Write-Action -Module $Module -Message "copied successfully from $SrcPath to $DstPath"
        }
    }
}

# Creates a dotfile in the home directory
function Set-Dotfile {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Module,
        [string]$File = "",
        [bool]$IsHidden = $true,
        [switch]$Copy
    )

    if (-not (Test-Path variable:script:root)) {
        Write-Message -Module $Module -Message "root variable is not set" -Severity "error"
        return
    }

    $fileName = if ($File) { $File } else { $Module }

    if ($IsHidden) {
        $dstFile = ".$fileName"
    }
    else {
        $dstFile = $fileName
    }

    $srcFile = $File
    $dstPath = Join-Path $env:USERPROFILE $dstFile
    $srcPath = Join-Path $script:root (Join-Path $Module $srcFile)

    Invoke-Linker -Module $Module -SrcPath $srcPath -DstPath $dstPath -Copy:$Copy
}

# Creates a config file in the user's AppData\Local directory
function Set-ConfigFile {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Module,
        [string]$SrcFile = "",
        [string]$SrcDir = "",
        [switch]$Copy
    )

    if (-not (Test-Path variable:script:root)) {
        Write-Message -Module $Module -Message "root variable is not set" -Severity "error"
        return
    }

    $configBase = $env:LOCALAPPDATA
    if (-not (Test-Path $configBase)) {
        New-Item -ItemType Directory -Path $configBase -Force | Out-Null
    }

    if ($SrcFile) {
        $srcPathParts = @($script:root)
        if ($SrcDir) { $srcPathParts += $SrcDir }
        $srcPathParts += @($Module, $SrcFile)
        $srcPath = Join-Path @srcPathParts

        $dstFile = Join-Path $Module $SrcFile

        $moduleDir = Join-Path $configBase $Module
        if (-not (Test-Path $moduleDir)) {
            New-Item -ItemType Directory -Path $moduleDir -Force | Out-Null
        }
    }
    else {
        $srcPathParts = @($script:root)
        if ($SrcDir) { $srcPathParts += $SrcDir }
        $srcPathParts += $Module
        $srcPath = Join-Path @srcPathParts

        $dstFile = $Module
    }

    $dstPath = Join-Path $configBase $dstFile

    Invoke-Linker -Module $Module -SrcPath $srcPath -DstPath $dstPath -Copy:$Copy
}

# Creates a config file in the root of AppData\Local
function Set-ConfigRootFile {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Module,
        [Parameter(Mandatory=$true)]
        [string]$SrcFile,
        [string]$SrcDir = "",
        [switch]$Copy
    )

    if (-not (Test-Path variable:script:root)) {
        Write-Message -Module $Module -Message "root variable is not set" -Severity "error"
        return
    }

    $configBase = $env:LOCALAPPDATA
    if (-not (Test-Path $configBase)) {
        New-Item -ItemType Directory -Path $configBase -Force | Out-Null
    }

    $srcPathParts = @($script:root)
    if ($SrcDir) { $srcPathParts += $SrcDir }
    $srcPathParts += @($Module, $SrcFile)
    $srcPath = Join-Path @srcPathParts

    $dstPath = Join-Path $configBase $SrcFile

    Invoke-Linker -Module $Module -SrcPath $srcPath -DstPath $dstPath -Copy:$Copy
}

# Export functions
Export-ModuleMember -Function @(
    'Test-Administrator',
    'Test-DeveloperMode',
    'Invoke-Linker',
    'Set-Dotfile',
    'Set-ConfigFile',
    'Set-ConfigRootFile'
)
