# Dotfiles Scripts Architecture

This document provides comprehensive documentation of the scripts structure and library functions for easier maintenance and script creation.

## Directory Structure

```
scripts/
├── lib/                    # Shared library functions
│   ├── main.sh            # Main aggregator (sources all libs)
│   ├── message.sh         # Messaging and UI utilities
│   ├── require.sh         # Package installation functions
│   ├── linker.sh          # Symlink and file management
│   ├── github.sh          # GitHub release installation
│   ├── clone.sh           # Git repository cloning
│   ├── service.sh         # Cross-platform service management
│   ├── proxy.sh           # Proxy configuration
│   ├── run.sh             # Command execution utilities
│   ├── start.sh           # Main script execution engine
│   └── header.sh          # ASCII art header
├── *.sh                   # Individual setup scripts
└── [Additional PowerShell scripts for Windows support]
```

## Script Execution Flow

Scripts are executed via `start.sh`:
```bash
./start.sh [-y] [-h] [-d] <script-name> [script-options]
```

### Flags
- `-y`: Yes to all prompts (sets `yes_to_all=1`)
- `-h`: Display help (sets `show_help=true`)
- `-d`: As dependency (internal use, sets `as_dependency=true`)

### Execution Phases

Each script goes through these phases (defined in `start.sh`):

1. **Pre Main** (`pre_main` function) - Setup and validation
2. **Install** (`install` function) - Platform-specific installation
3. **Main** (`main` function) - Post-installation configuration
4. **User-specific** (`main_${USER}` function) - User-specific customization

### Platform Detection

The `install` function automatically detects the platform and calls the appropriate function:

- **macOS**: `main_brew` (using Homebrew)
- **Android/Termux**: `main_pkg` (using pkg)
- **Debian/Ubuntu**: `main_apt` (using apt)
- **Arch Linux**: `main_pacman` (using pacman/yay)
- **Void Linux**: `main_xbps` (using xbps)

## Required Global Variables

Scripts should define these at the top:
```bash
root=${root:?"root must be set"}  # Set by start.sh, points to dotfiles root
```

## Script Template Structure

```bash
#!/usr/bin/env bash

# Optional: Usage/description function
usage() {
    echo "Description of what this script does"
    # Optional: ASCII art
}

# Optional: Pre-installation setup
pre_main() {
    # Validation, checks, user prompts
    return 0
}

# Platform-specific installation (choose one or more)
main_brew() {
    require_brew package1 package2
    require_brew_cask app1
}

main_pacman() {
    require_pacman package1 package2
    require_aur aur-package
}

main_apt() {
    require_apt package1 package2
}

main_pkg() {
    require_pkg package1 package2
}

# Optional: Post-installation configuration
main() {
    # Configuration, file setup, etc.
    return 0
}

# Optional: User-specific configuration
main_parham() {
    # User-specific setup (replace 'parham' with actual username)
    return 0
}
```

## Library Functions Reference

### Message Functions (message.sh)

#### Output Functions
```bash
message <module> <message> [severity]
# Severity: info (default), error, notice, warn, success, debug
# Example: message "git" "Repository cloned" "success"

running <module> <message>
# Shows running/in-progress message with arrow
# Example: running "docker" "Building image..."

action <module> <message>
# Shows action being taken
# Example: action "brew" "Installing package"

ok <module> <message>
# Shows success message
# Example: ok "git" "Pull completed"

yes_or_no <module> <question>
# Interactive yes/no prompt (respects yes_to_all flag)
# Returns: 0 for yes, 1 for no
# Example: yes_or_no "firefox" "Install Firefox?"
```

#### UI Utilities
```bash
section_header <title> [width] [char]
# Prints a section header
# Example: section_header "Installation Phase"

list_item <item> [status] [indent]
# Print bulleted list item with optional status
# Status: success/done/✓, error/failed/✗, warning/warn/⚠, info/ⓘ
# Example: list_item "Package installed" "success"

progress_bar <current> <total> [width] [prefix]
# Show progress bar
# Example: progress_bar 50 100 50 "Installing"

colorize <color> <text>
# Print colored text
# Example: colorize "$F_SUCCESS" "Done!"
```

#### Color Variables
```bash
# Basic colors
$F_CYAN, $F_GREEN, $F_RED, $F_ORANGE, $F_YELLOW
$F_GRAY, $F_BLUE, $F_PURPLE, $F_PINK, $F_WHITE, $F_BLACK

# Semantic colors
$F_SUCCESS   # Bright neon green
$F_ERROR     # Bright red
$F_WARNING   # Bright orange
$F_INFO      # Electric blue
$F_NOTICE    # Hot pink
$F_DEBUG     # Bright purple

# Text formatting
$BOLD_ON, $BOLD_OFF, $ITALIC_ON, $ITALIC_OFF
$UNDERLINE_ON, $UNDERLINE_OFF, $DIM_ON, $DIM_OFF

# Reset
$ALL_RESET, $F_RESET
```

### Package Installation (require.sh)

#### Homebrew (macOS)
```bash
require_brew <packages...>
# Install Homebrew formulas
# Example: require_brew git neovim

require_brew_cask <packages...>
# Install Homebrew casks
# Example: require_brew_cask firefox docker

require_brew_head <packages...>
# Install/upgrade HEAD versions
# Example: require_brew_head neovim
```

#### Pacman (Arch Linux)
```bash
require_pacman <packages...>
# Install pacman packages
# Example: require_pacman base-devel git

not_require_pacman <packages...>
# Remove pacman packages
# Example: not_require_pacman package-to-remove

require_aur <packages...>
# Install AUR packages via yay
# Respects allow_no_aur flag
# Auto-upgrades -git packages
# Example: require_aur yay neovim-git
```

#### APT (Debian/Ubuntu)
```bash
require_apt <packages...>
# Install apt packages
# Example: require_apt build-essential
```

#### Other Package Managers
```bash
require_pkg <packages...>        # Android Termux
require_xbps <packages...>       # Void Linux
require_snap <packages...>       # Snap packages
```

#### Language-Specific
```bash
require_pip <packages...>
# Install Python packages via pipx
# Supports version pinning: package@version
# Example: require_pip black@23.0.0

require_npm <packages...>
# Install npm packages globally
# Example: require_npm typescript

require_go <package> [version]
# Install Go packages
# Example: require_go github.com/user/tool@latest

require_mason <packages...>
# Install Neovim LSP servers via Mason
# Example: require_mason lua-language-server
```

#### GitHub Releases
```bash
require_github_release <repo> <binary_name> <release_name> [archive_ext]
# Install from GitHub releases
# Supports: tar.gz, tar.xz, zip, dmg (macOS), deb (Linux), or raw binary
# Tracks versions and supports upgrades
# Example: require_github_release "user/repo" "binary" "binary-linux-amd64" "tar.gz"
```

#### System Configuration
```bash
require_country <country_code>
# Check if in specific country via IP
# Example: require_country "US"

not_require_country <country_code>
# Check if NOT in specific country

require_host <hostname>
# Check connectivity to host via ping
# Example: require_host "github.com"

require_hosts_record <address> <hostname>
# Add entry to /etc/hosts
# Example: require_hosts_record "127.0.0.1" "myapp.local"
```

### File & Symlink Management (linker.sh)

#### Core Linking Functions
```bash
linker <module> <src_path> <dst_path>
# Core function to create symlinks
# - Validates paths for safety
# - Handles existing files/links with confirmation
# - Checks if symlink already points to correct location
# Example: linker "nvim" "$root/nvim" "$HOME/.config/nvim"

dotfile <module> [file] [is_hidden]
# Link to home directory
# is_hidden: true (default) adds dot prefix
# If file not specified, uses module name
# Example: dotfile "bashrc"          # Links $root/bashrc/bashrc to ~/.bashrc
# Example: dotfile "git" "gitconfig"  # Links $root/git/gitconfig to ~/.gitconfig

configfile <module> [src_file] [src_dir]
# Link to ~/.config directory
# If src_file specified: links specific file
# If src_file omitted: links entire directory
# Example: configfile "nvim"                    # Links $root/nvim to ~/.config/nvim
# Example: configfile "nvim" "init.lua"         # Links $root/nvim/init.lua to ~/.config/nvim/init.lua

configrootfile <module> <src_file> [src_dir]
# Link file to ~/.config root (not in subdirectory)
# Example: configrootfile "starship" "starship.toml"

configsystemd <module> <src_file> [src_dir]
# Link to ~/.config/systemd/user
# Example: configsystemd "docker" "docker.service"
```

#### File Copy Function
```bash
copycat <module> <src> <dest> [use_sudo]
# Copy file with diff preview
# - Shows differences before copying
# - Requests confirmation if changes exist
# - Supports directory destinations (ending with /)
# - Respects yes_to_all flag
# use_sudo: true (default) or false
# Example: copycat "firefox" "firefox/user.js" "/etc/firefox/"
# Example: copycat "app" "config.json" "$HOME/.config/app/config.json" "false"
```

### Git Repository Management (clone.sh)

```bash
clone <repo> [path] [dir] [push_url]
# Clone or update git repository
# - Clones if not exists
# - Pulls with --ff-only if exists
# - Verifies origin URL matches
# - Shows progress with percentage
# - Optionally sets push URL
# Example: clone "https://github.com/user/repo" "$HOME/projects"
# Example: clone "https://github.com/user/repo" "$HOME/projects" "custom-dir" "git@github.com:user/repo"
```

### Service Management (service.sh)

Cross-platform service management (systemd on Linux, launchctl on macOS):

```bash
detect_service_manager
# Returns: "systemctl", "launchctl", or "unknown"

service_start <service_name> [service_manager]
# Start a service
# Example: service_start "docker"

service_stop <service_name> [service_manager]
# Stop a service
# Example: service_stop "docker"

service_restart <service_name> [service_manager]
# Restart a service
# Example: service_restart "docker"

service_manager_name [service_manager]
# Get human-readable service manager name
```

### Proxy Management (proxy.sh)

```bash
proxy_start [url]
# Setup HTTP proxy
# Default: http://127.0.0.1:2081
# Sets: ftp_proxy, http_proxy, https_proxy
# Example: proxy_start "http://proxy.example.com:8080"

proxy_stop
# Remove all proxy configurations
```

### Command Execution (run.sh)

```bash
run_verbose <command...>
# Execute command and add to shell history
# Example: run_verbose docker build -t myapp .
```

## Script Dependencies & Additionals

Scripts can declare dependencies and optional additions:

```bash
# Dependencies (will be installed first)
export dependencies=("git" "node")

# Optional additional packages (user will be prompted)
export additionals=("python" "go" "java")
```

## Helper Functions in Scripts

Most scripts define these helper functions:

```bash
msg() { message "${script}" "$@"; }
# Shorthand for module-scoped messages
# Usage in script: msg "Installing packages" "info"
```

## Common Patterns

### Interactive Installation
```bash
if yes_or_no "module" "Install this feature?"; then
    # Install feature
    action "module" "Installing feature"
else
    msg "Skipping feature" "notice"
fi
```

### Conditional Package Installation
```bash
main_pacman() {
    if yes_or_no 'app' 'Use stable version?'; then
        not_require_pacman app-git
        require_pacman app
    else
        not_require_pacman app
        require_aur app-git
    fi
}
```

### Configuration File Setup
```bash
main() {
    export yes_to_all=1  # Skip prompts for file operations

    copycat 'module' "module/config.json" "$HOME/.config/module/config.json" 'false'
    configfile "module" "settings.lua"
    dotfile "module" "modulerc"
}
```

### Service Setup
```bash
main_pacman() {
    require_pacman package

    if ! sudo systemctl enable --now service.service; then
        msg 'Failed to enable service' 'error'
        return 1
    fi
}
```

### GitHub Release Installation
```bash
main_brew() {
    # Binary name can use variables evaluated at runtime
    require_github_release \
        "user/repo" \
        "binary-name" \
        "release-\${version}-darwin-amd64" \
        "tar.gz"
}
```

### User Groups
```bash
main_pacman() {
    require_pacman package

    sudo groupadd -f groupname
    sudo usermod -aG groupname "$USER"

    msg "Re-login required for group changes to take effect" "notice"
}
```

## Script Naming Conventions

- Script files: `<name>.sh` in `scripts/` directory
- Module name matches script name (without .sh)
- Use kebab-case for multi-word names: `google-chrome.sh`
- PowerShell equivalents: `<name>.ps1`

## Environment Variables

### Set by Framework
- `$root`: Path to dotfiles root (or host-specific root)
- `$main_root`: Always points to main dotfiles root
- `$yes_to_all`: 0 or 1, set by `-y` flag
- `$show_help`: true or false, set by `-h` flag
- `$as_dependency`: true or false, set by `-d` flag
- `$USER`: Current username
- `$HOSTNAME`: System hostname

### XDG Variables
- `$XDG_CONFIG_HOME`: Defaults to `$HOME/.config`

## Best Practices

1. **Always validate inputs**: Use `${var:?"error message"}` syntax
2. **Check command availability**: Use `command -v cmd &>/dev/null`
3. **Handle errors**: Return non-zero on failure, check function return values
4. **Use helper functions**: Prefer `msg` over `echo`, `require_*` over direct package managers
5. **Respect flags**: Check `$yes_to_all` before prompts
6. **Platform detection**: Implement platform-specific `main_*` functions
7. **Safe paths**: Avoid hardcoded paths, use `$root` and `$HOME`
8. **User feedback**: Use appropriate message severity levels
9. **Idempotency**: Scripts should be safe to run multiple times
10. **Dependencies**: Declare in `dependencies` array, don't call start.sh directly

## Creating New Scripts

Use the built-in template generator:
```bash
./start.sh new <script-name>
```

This creates a new script with the standard template structure.

## Testing Scripts

Run scripts individually:
```bash
./start.sh <script-name>         # Interactive mode
./start.sh -y <script-name>      # Auto-yes mode
./start.sh -h <script-name>      # Help mode
```

## Host-Specific Scripts

Scripts can have host-specific versions:
```
hosts/<hostname>/scripts/<script-name>.sh
```

Both general and host-specific versions will run when executed.

## Debugging

- Use `message "module" "debug info" "debug"` for debug output
- Check `$show_help` flag to print usage without execution
- Use `set -x` temporarily for bash tracing
- Function availability: `declare -f function_name >/dev/null`

## Notes

- All library functions are available after sourcing `main.sh`
- Scripts execute in a subshell via `source`
- Return codes matter: 0 for success, non-zero for failure
- The framework handles Ctrl+C gracefully with a cleanup trap
- Package managers check if packages are already installed before attempting installation
