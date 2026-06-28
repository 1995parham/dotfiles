#!/usr/bin/env bash

usage() {
    echo "HashiCorp Vault: manage secrets and protect sensitive data"

    # shellcheck disable=1004,2016
    echo '
 _   _           _ _
| | | | __ _ _   _| | |_
| | | |/ _` | | | | | __|
| |_| | (_| | |_| | | |_
 \___/ \__,_|\__,_|_|\__|
  '
}

# Install Vault from HashiCorp's official release server.
#
# There is no maintained package for Vault outside of Homebrew and
# HashiCorp's own apt repo: the AUR `vault-bin`/`vault-git` packages are
# orphaned (stuck at 1.18.0) and the official Arch repos dropped Vault
# after the 2023 BSL relicense. HashiCorp also attaches no binaries to
# GitHub releases, so require_github_release does not work here. The
# canonical source is releases.hashicorp.com, which is what we use.
vault-upstall() {
    local os arch version url

    case "$(uname -s)" in
    Linux) os=linux ;;
    Darwin) os=darwin ;;
    *)
        msg "unsupported OS: $(uname -s)" "error"
        return 1
        ;;
    esac

    case "$(uname -m)" in
    x86_64 | amd64) arch=amd64 ;;
    aarch64 | arm64) arch=arm64 ;;
    armv7l) arch=arm ;;
    i386 | i686) arch=386 ;;
    *)
        msg "unsupported arch: $(uname -m)" "error"
        return 1
        ;;
    esac

    msg "resolving latest Vault version from releases.hashicorp.com"

    # Latest OSS version: drop pre-releases and +ent/+fips builds.
    version=$(curl -fsSL "https://releases.hashicorp.com/vault/index.json" |
        python3 -c "import json,sys
v=[k for k in json.load(sys.stdin)['versions'] if '+' not in k and '-' not in k]
v.sort(key=lambda s: tuple(int(x) for x in s.split('.')))
print(v[-1] if v else '')")

    if [[ -z "${version}" ]]; then
        msg "failed to resolve latest Vault version" "error"
        return 1
    fi

    if [[ "$(vault version 2>/dev/null | grep -oE 'v[0-9.]+' | head -1)" == "v${version}" ]]; then
        msg "vault v${version} already installed (up to date)" "success"
        return 0
    fi

    url="https://releases.hashicorp.com/vault/${version}/vault_${version}_${os}_${arch}.zip"

    local install_dir="${HOME}/.local/bin"
    local tmp
    tmp=$(mktemp -d)
    mkdir -p "${install_dir}"

    action "vault" "installing v${version} from ${url}"

    if ! curl -fsSL -o "${tmp}/vault.zip" "${url}"; then
        msg "failed to download ${url}" "error"
        rm -rf "${tmp}"
        return 1
    fi

    if ! unzip -qo "${tmp}/vault.zip" -d "${tmp}"; then
        msg "failed to unzip vault archive" "error"
        rm -rf "${tmp}"
        return 1
    fi

    chmod +x "${tmp}/vault"
    mv "${tmp}/vault" "${install_dir}/vault"
    rm -rf "${tmp}"

    if ! echo "${PATH}" | grep -q "${install_dir}"; then
        msg "${install_dir} is not in your PATH" "warn"
    fi

    msg "$(vault version 2>/dev/null | head -1)" "success"
}

main_pacman() {
    vault-upstall
}

main_brew() {
    require_brew hashicorp/tap/vault
}

main_apt() {
    # vault is distributed through HashiCorp's own apt repository
    if ! command -v vault &>/dev/null; then
        msg "Installing Vault from HashiCorp repository" "info"

        # Install dependencies
        sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

        # Add HashiCorp GPG key
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://apt.releases.hashicorp.com/gpg |
            sudo gpg --dearmor -o /etc/apt/keyrings/hashicorp.gpg
        sudo chmod a+r /etc/apt/keyrings/hashicorp.gpg

        # Add repository
        echo "deb [signed-by=/etc/apt/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" |
            sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null

        sudo apt-get update
        sudo apt-get install -y vault
    fi
}

main_pkg() {
    vault-upstall
}

main_xbps() {
    vault-upstall
}

main() {
    if command -v vault &>/dev/null; then
        msg "$(vault version 2>/dev/null | head -1) installed" "success"
    fi

    return 0
}
