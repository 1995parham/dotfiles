# Dotfiles Scripts Architecture

This document provides comprehensive documentation of the repository layout, the scripts structure, and the library functions, for easier maintenance and script creation.

## Repository Layout

The repository is organized as one directory per tool/module, plus the machinery that installs them.

```
dotfiles/
├── start.sh               # symlink -> scripts/lib/start.sh (script dispatcher)
├── start.ps1              # symlink -> scripts/lib/start.ps1 (Windows dispatcher)
├── install.sh             # standalone linker for the "always on" dotfiles
├── scripts/               # setup scripts, one per module (see below)
├── hosts/<host>/          # host-specific overrides (scripts + configs)
├── bin/bin/               # personal scripts, linked to ~/bin by install.sh
├── secrets/               # encrypted material (e.g. github-token-keys.enc)
├── companies/             # logos/assets used by prompts and configs
├── conf/                  # small configs without their own directory (htop, aria2, ...)
├── <module>/              # one directory per tool: zsh, git, tmux, kitty, starship, ...
├── .github/workflows/     # CI: install.yaml + sh-lint.yaml
├── .editorconfig          # 4-space indentation everywhere
├── .stylua.toml           # lua formatting rules (checked in CI)
└── .markdownlint.json     # markdown lint rules
```

Two entry points exist and they do different things:

- `./install.sh [-y]` - links only the base set (`conf`, `tmux`, `wakatime`, `vim`, `bin`) and
  requires `bash`, `zsh`, `tmux`, `vim` to already be present. Sources `message.sh`,
  `linker.sh`, and `header.sh` directly, without the phase engine.
- `./start.sh <script>` - the real dispatcher, runs one module script through the full
  phase engine described below.

`scripts/lib/` is **vendored from an upstream repository**
([1995parham/dotfiles.lib](https://github.com/1995parham/dotfiles.lib)) via `git subtree`.
Prefer fixing library bugs upstream; local edits there have to survive the next subtree merge.
This is also why CI excludes `scripts/lib/` and `start.sh` from the shell linter.

## Directory Structure

```
scripts/
├── lib/                    # Shared library functions (git subtree, see above)
│   ├── main.sh            # Main aggregator (sources all libs) + _host_short
│   ├── message.sh         # Messaging and UI utilities
│   ├── require.sh         # Package installation functions
│   ├── linker.sh          # Symlink and file management
│   ├── github.sh          # GitHub release installation
│   ├── clone.sh           # Git repository cloning
│   ├── service.sh         # Cross-platform service management
│   ├── proxy.sh           # Proxy configuration
│   ├── whereami.sh        # Public IP / country detection (with cache)
│   ├── run.sh             # Command execution utilities
│   ├── start.sh           # Main script execution engine
│   ├── header.sh          # ASCII art header
│   ├── new.sh             # `./start.sh new`    - script template generator
│   ├── list.sh            # `./start.sh list`   - list available scripts
│   ├── update.sh          # `./start.sh update` - update installed packages
│   ├── unit.sh            # Tiny test harness (assert_equals, assert_retval)
│   ├── tests/             # Unit tests for the library itself
│   └── *.ps1              # PowerShell mirrors (main, message, require, linker, ...)
├── *.sh                   # Individual setup scripts
└── *.ps1                  # PowerShell equivalents for Windows support
```

## Script Execution Flow

Scripts are executed via `start.sh`:
```bash
./start.sh [-y] [-h] [-d] [--allow-root] <script-name> [script-options]
```

### Flags
- `-y`: Yes to all prompts (sets `yes_to_all=1`)
- `-h`: Display help (sets `show_help=true`), prints `_usage` + the script's `usage`
- `-d`: As dependency (internal use, sets `as_dependency=true`, skips the ASCII header)
- `--allow-root`: Permit running as root; without it `start.sh` refuses when `EUID` is 0

### Built-in Subcommands

These names are resolved to `scripts/lib/` instead of `scripts/`:

```bash
./start.sh new [name]   # generate a new script from the template
./start.sh list         # list available scripts (general + host-specific)
./start.sh update       # update packages via the platform package manager
```

Running `./start.sh` with no script prints usage and falls back to `list`.

### Execution Phases

Each script goes through these phases (defined in `start.sh`'s `run`):

1. **Pre Main** (`pre_main` function) - Setup and validation
2. **Install** (`install` function) - Platform-specific installation
3. **Main** (`main` function) - Post-installation configuration
4. **User-specific** (`main_${profile}` function) - Per-user customization

The profile in phase 4 is `${PROFILE:-${USER}}`. Setting `export PROFILE=elahe` lets a
machine whose login name differs from the canonical profile (e.g. `ellie`, `raha`) reuse the
same `main_elahe` function instead of adding alias stubs to every script.

`pre_main`, `main`, and `main_${profile}` all receive the script's extra arguments; `install`
does not.

### Platform Detection

The `install` function detects the platform, in this order, and calls the matching function.
If the matching function is missing, the run aborts with an error.

- **macOS** (`$OSTYPE` = `darwin*`): `main_brew` (using Homebrew)
- **Android/Termux** (`$OSTYPE` = `linux-android`): `main_pkg` (using pkg)
- **Debian/Ubuntu** (`apt` present): `main_apt` (using apt)
- **Arch Linux** (`pacman` present): `main_pacman` (using pacman/yay)
- **Void Linux** (`xbps-install` present): `main_xbps` (using xbps)

Note that `apt` is probed **before** `pacman`, so a machine with both would take the apt path.

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

main_xbps() {
    require_xbps package1 package2
}

# Optional: Post-installation configuration
main() {
    # Configuration, file setup, etc.
    return 0
}

# Optional: User-specific configuration
main_parham() {
    # User-specific setup (replace 'parham' with the username or $PROFILE)
    return 0
}
```

Only define the platform functions you actually support — see `scripts/dotnet.sh`, which
implements `main_pacman`/`main_apt`/`main_brew` and simply omits the rest. A missing function
produces a clear "main_X not found, there is nothing to do" message.

Helper functions private to a script are conventionally prefixed with the module name
(`dotnet_configure`, `require_dotnet_tool`) to avoid colliding with the library or with a
host-specific script sourced into the same shell.

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

spinner [message] <pid>
# Show a spinner while the given background pid is alive (Linux only, reads /proc)
# Note the argument order: message first, pid second
# Example: long_task & spinner "Working" $!
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
# Install from GitHub releases into ~/.local/bin
# Supports: tar.gz, tar.xz, tar.bz2, zip, dmg (macOS), deb (Linux), or raw binary
# Tracks installed versions and re-installs only on upgrade
# <binary_name> is eval'd, so it may reference ${version} resolved at runtime
# Honors OFFLINE=1: logs a skip and returns 0 for hosts that cannot reach github.com
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

require_systemd_kernel_parameter <[+|-]parameter>
# Add/remove a kernel parameter in every /boot/loader/entries/*.conf (systemd-boot)
# Prefix with '-' to remove, '+' or nothing to add
# Example: require_systemd_kernel_parameter "+nvidia_drm.modeset=1"
# Example: require_systemd_kernel_parameter "-quiet"
```

### Location Detection (whereami.sh)

```bash
whereami
# Print public IP + country/ISP, with VPN/hosting markers
# Falls back through ip-api.com -> ifconfig.io -> ipmyp.ir -> /tmp/whereami.sh cache
# Returns: 0 live source, 1 stale cache only, 2 nothing available
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
# is_hidden: true (default) adds dot prefix to the destination name
# Destination name is the file when given, otherwise the module name
# Example: dotfile "git" "gitconfig"  # Links $root/git/gitconfig to ~/.gitconfig
# Example: dotfile "vim" "vimrc"      # Links $root/vim/vimrc to ~/.vimrc
# Example: dotfile "bin" "bin" false  # Links $root/bin/bin to ~/bin (no dot prefix)
# Note: omitting <file> links the module DIRECTORY ($root/<module>/) to ~/.<module>

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

run_editor_before
# NOT IMPLEMENTED, always returns 1. Do not use.
```

## Script Dependencies & Additionals

Scripts can declare dependencies and optional additions:

```bash
# Dependencies: prompted once as a group, installed before `run`
export dependencies=("git" "node")

# Optional additional packages: prompted individually, installed after `run`
export additionals=("python" "go" "java")
```

Both are installed by re-invoking `${main_root}/start.sh` with `-d` (and `-y` when
`yes_to_all` is set), so each one gets its own full phase run. An entry may carry arguments
(`"nvim --headless"`); it is word-split before being passed along.

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
- `$root`: Path to dotfiles root — reassigned per script, so a host-specific script sees
  `${main_root}/hosts/<host>` instead of the repo root
- `$main_root`: Always points to main dotfiles root
- `$yes_to_all`: 0 or 1, set by `-y` flag
- `$show_help`: true or false, set by `-h` flag
- `$as_dependency`: true or false, set by `-d` flag
- `$allow_root`: true or false, set by `--allow-root`
- `$script`: Name of the script currently running (used by the `msg` helper)
- `$USER` / `$PROFILE`: Profile selection for the `main_<profile>` phase
- `$HOSTNAME`: System hostname (trimmed to its first label for script resolution)

### Read by Library Functions
- `$allow_no_aur`: when true, `require_aur` succeeds instead of failing when `yay` is absent
- `$OFFLINE`: when `1`, `require_github_release` skips the download and returns 0

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

It prompts for the name (if omitted), whether the script is host-specific, a description,
whether it needs `$root`, and the user for the `main_<user>` stub — then writes a skeleton
with `figlet` ASCII art in `usage` and every platform function stubbed out returning `1`
(i.e. "this platform is not supported yet"). Delete the stubs you do not implement rather
than leaving them returning `1`, since a stub that returns `1` aborts the run under `set -e`.

## Testing & Linting

Run scripts individually:
```bash
./start.sh <script-name>         # Interactive mode
./start.sh -y <script-name>      # Auto-yes mode
./start.sh -h <script-name>      # Help mode
```

Library unit tests live in `scripts/lib/tests/` and use the tiny harness in
`scripts/lib/unit.sh`. Each test file sources `unit.sh` at the *bottom*; sourcing triggers the
runner, which discovers every function named `test_*` via `declare -F` and reports a summary.

```bash
./scripts/lib/tests/test_linker.sh   # run one test file (30 tests, exits non-zero on failure)
```

These tests are **not** wired into CI — run them by hand after touching `scripts/lib/`.
`test_colors.sh` is a color-palette demo rather than a real test file (it defines no `test_*`
functions, so it reports "All 0 tests passed").

Available assertions:
```bash
assert_equals <value> <expected>
assert_retval <command...> <expected-exit-code>
```

CI (`.github/workflows/`):
- `sh-lint.yaml` — `luizm/action-sh-checker` (shellcheck with `SHELLCHECK_OPTS: -x`, plus
  shfmt), excluding `scripts/lib/` and `start.sh`; and `stylua --check .` for Lua files.
- `install.yaml` — runs `./start.sh -y env` and `./install.sh -y` on ubuntu-latest and
  macos-latest, then verifies symlinks and that the required binaries are on `PATH`.

Style: 4-space indent everywhere (`.editorconfig`), `#!/usr/bin/env bash` shebang, and code
must be shellcheck-clean with `-x` since scripts rely on sourced library files.

## Host-Specific Scripts

Scripts can have host-specific versions:
```
hosts/<hostname>/scripts/<script-name>.sh
```

Resolution details (`_resolve_script_paths` in `scripts/lib/start.sh`):

- The hostname is trimmed to its first label by `_host_short`, so `box.home.arpa` resolves
  as `box`.
- Up to three paths are collected and **all matching ones run, in this order**:
  1. `scripts/<name>.sh` (general)
  2. `hosts/<host>/scripts/<name>.sh` (host-specific)
  3. `<host>/scripts/<name>.sh` (legacy layout, kept as a fallback)
- `$root` is set to the owning root for each — the repo root for the general script,
  `hosts/<host>` for the host-specific one — so `dotfile`/`configfile` calls in a host script
  resolve against the host directory.
- `./start.sh new` asks whether the new script should be host-specific and creates it under
  `hosts/<host>/scripts/` if so.

Because both scripts are sourced into the same shell, a host-specific script can override or
extend functions defined by the general one.

## Debugging

- Use `message "module" "debug info" "debug"` for debug output
- Check `$show_help` flag to print usage without execution
- Use `set -x` temporarily for bash tracing
- Function availability: `declare -f function_name >/dev/null`

## Notes

- All library functions are available after sourcing `main.sh`. `linker.sh` is only sourced
  when `$root` is set, so linking helpers are unavailable outside a script run.
- Scripts are `source`d into `start.sh`'s own shell, not a subshell — functions and variables
  they define persist, which is what lets the host-specific script build on the general one
  (and why a stray `exit` in a script kills the whole run).
- Sourcing errors are swallowed (`2>/dev/null`) and reported as "failed to source"; if a
  script mysteriously does nothing, source it by hand to see the real error.
- Return codes matter: 0 for success, non-zero for failure
- `start.sh` runs under `set -euo pipefail`, so an unguarded failing command aborts the run.
  Append `|| true` where a non-zero exit is acceptable.
- The framework handles Ctrl+C gracefully with a cleanup trap
- Package managers check if packages are already installed before attempting installation
  (`brew list --versions`, `pacman -Qi`, `xbps-query`, ...), and batch the missing ones into a
  single install command
- `require_aur` additionally re-runs `yay` for already-installed `*-git` packages to pull in
  upstream commits
