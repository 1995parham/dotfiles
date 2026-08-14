#!/usr/bin/env bash

usage() {
    echo -n ".net sdk, runtimes and tooling for building c# projects"

    # shellcheck disable=1004,2016
    echo '
     _       _              _
  __| | ___ | |_ _ __   ___| |_
 / _` |/ _ \| __| |_ \ / _ \ __|
| (_| | (_) | |_| | | |  __/ |_
 \__,_|\___/ \__|_| |_|\___|\__|
  '
}

# The .NET version the projects here target. Arch ships every release
# side-by-side, so pinning is cheap and keeps `dotnet build` from silently
# rolling a project forward to a newer SDK.
dotnet_version="8.0"

# Global tools land in ~/.local/bin, which is already on PATH, instead of
# ~/.dotnet/tools which would need a shell rc edit to be usable.
dotnet_tool_path="$HOME/.local/bin"

main_pacman() {
    # A web project needs four pieces, and missing any one of them fails in a
    # way that does not name the package:
    #   dotnet-sdk-*             build and restore
    #   dotnet-runtime-*         run a console/library app
    #   dotnet-targeting-pack-*  compile against the base framework
    #   aspnet-runtime-*         run an ASP.NET Core app
    #   aspnet-targeting-pack-*  compile against Microsoft.AspNetCore.App
    require_pacman \
        "dotnet-sdk-${dotnet_version}" \
        "dotnet-runtime-${dotnet_version}" \
        "dotnet-targeting-pack-${dotnet_version}" \
        "aspnet-runtime-${dotnet_version}" \
        "aspnet-targeting-pack-${dotnet_version}"
}

main_apt() {
    require_apt \
        "dotnet-sdk-${dotnet_version}" \
        "aspnetcore-runtime-${dotnet_version}"
}

main_brew() {
    require_brew "dotnet@${dotnet_version%%.*}"
}

main() {
    if ! command -v dotnet &>/dev/null; then
        msg 'dotnet is not available in PATH' 'error'
        return 1
    fi

    msg "dotnet $(dotnet --version)"

    dotnet_check_sdk || return 1

    dotnet_configure

    dotnet_install_tools
}

# Warn when the pinned SDK is absent. `dotnet --version` reports whichever SDK
# resolves for the current directory, so it can look healthy while the one the
# projects need is missing.
dotnet_check_sdk() {
    if dotnet --list-sdks | grep -q "^${dotnet_version}"; then
        msg "sdk ${dotnet_version} is installed"
        return 0
    fi

    msg "sdk ${dotnet_version} is not installed, found:" 'error'
    dotnet --list-sdks
    return 1
}

dotnet_configure() {
    msg 'opt out of telemetry and the first-run banner'

    # These are read from the environment, so they belong in the shell config
    # rather than in a dotnet-side config file.
    dotnet_env DOTNET_CLI_TELEMETRY_OPTOUT 1
    dotnet_env DOTNET_NOLOGO 1

    msg 'installed runtimes:'
    dotnet --list-runtimes
}

# Append an export to bash and zsh once, matching how java.sh extends PATH.
dotnet_env() {
    local name=$1
    local value=$2
    local line="export ${name}=${value}"

    local rc
    for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
        [ -f "$rc" ] || continue

        if ! grep -q -F "$line" "$rc"; then
            echo "$line" | tee -a "$rc" >/dev/null
            msg "added ${name} to $(basename "$rc")"
        fi
    done

    export "${name}=${value}"
}

dotnet_install_tools() {
    msg 'fetch some good and useful dotnet tools'

    # dotnet-ef      EF Core migrations (dotnet ef migrations add/database update)
    # csharpier      opinionated formatter, has a neovim/LSP integration
    # dotnet-outdated-tool  reports NuGet packages behind their latest version
    require_dotnet_tool dotnet-ef
    require_dotnet_tool csharpier
    require_dotnet_tool dotnet-outdated-tool

    require_mason omnisharp
    require_mason csharpier
    require_mason netcoredbg
}

# Install or update a dotnet global tool into a directory already on PATH.
# `tool install` fails when the tool exists, so fall through to `tool update`,
# which keeps the script idempotent.
require_dotnet_tool() {
    local package=$1

    if [ ! -d "$dotnet_tool_path" ]; then
        if ! mkdir -p "$dotnet_tool_path"; then
            msg "failed to create ${dotnet_tool_path}" 'error'
            return 1
        fi
    fi

    action 'dotnet' "installing ${package}"

    if dotnet tool install --tool-path "$dotnet_tool_path" "$package" &>/dev/null; then
        ok 'dotnet' "${package} installed"
        return 0
    fi

    if dotnet tool update --tool-path "$dotnet_tool_path" "$package" &>/dev/null; then
        ok 'dotnet' "${package} up to date"
        return 0
    fi

    msg "failed to install ${package}" 'error'
    return 1
}
