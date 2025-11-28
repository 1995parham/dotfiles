#!/usr/bin/env bash

k3s_channel="${K3S_CHANNEL:-stable}"
k3s_config_dir="/etc/rancher/k3s"
k3s_config_file="${k3s_config_dir}/config.yaml"
k3s_cluster_name="homelab"
k3s_data_dir="/var/lib/rancher/k3s"
k3s_node_ip=""
k3s_flannel_iface=""
k3s_cluster_cidr="10.73.0.0/16"
k3s_service_cidr="10.78.0.0/16"
k3s_kubeconfig_local="${HOME}/.kube/k3s.yaml"
k3s_copy_kubeconfig=true
declare -a k3s_disable_components=("servicelb" "traefik")
declare -a k3s_tls_sans=()

usage() {
    echo "Install a single-node (server+agent) k3s cluster on Arch Linux."
    # shellcheck disable=1004,2016
    cat <<'EOF'
          _  ____ ____
 _ __ ___| |/ ___/ ___|
| '__/ _ \ | |   \___ \
| | |  __/ | |___ ___) |
|_|  \___|_|\____|____/

Arguments:
  --channel CHANNEL           k3s release channel (default: $K3S_CHANNEL or stable)
  --cluster-name NAME         Logical cluster name (default: homelab)
  --data-dir PATH             Override /var/lib/rancher/k3s
  --node-ip IP                Force the node IP when multiple addresses exist
  --flannel-iface IFACE       Interface name flannel should bind to
  --tls-san VALUE             Additional TLS SAN entries (repeat flag)
  --disable LIST              Disable packaged components (repeat flag or comma separated)
  --cluster-cidr CIDR         Pod CIDR (default: 10.42.0.0/16)
  --service-cidr CIDR         Service CIDR (default: 10.43.0.0/16)
  --kubeconfig PATH           Where to copy the kubeconfig (default: ~/.kube/k3s.yaml)
  --skip-kubeconfig           Do not copy kubeconfig to \$HOME
  -h, --help                  Show this message

Example:
  start.sh k3s --node-ip 192.168.40.10 --flannel-iface eno1 --tls-san cluster.lab.local
EOF
}

add_tls_san() {
    local san=${1:-""}
    [[ -z "${san}" ]] && return

    for existing in "${k3s_tls_sans[@]}"; do
        if [[ "${existing}" == "${san}" ]]; then
            return
        fi
    done

    k3s_tls_sans+=("${san}")
}

add_disable_component() {
    local component=${1:-""}
    [[ -z "${component}" ]] && return

    for existing in "${k3s_disable_components[@]}"; do
        if [[ "${existing}" == "${component}" ]]; then
            return
        fi
    done

    k3s_disable_components+=("${component}")
}

pre_main() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
        --channel)
            k3s_channel="${2:-}"
            shift 2
            ;;
        --cluster-name)
            k3s_cluster_name="${2:-}"
            shift 2
            ;;
        --data-dir)
            k3s_data_dir="${2:-}"
            shift 2
            ;;
        --node-ip)
            k3s_node_ip="${2:-}"
            shift 2
            ;;
        --flannel-iface)
            k3s_flannel_iface="${2:-}"
            shift 2
            ;;
        --tls-san)
            add_tls_san "${2:-}"
            shift 2
            ;;
        --disable)
            IFS=',' read -ra disable_list <<<"${2:-}"
            for component in "${disable_list[@]}"; do
                add_disable_component "${component}"
            done
            shift 2
            ;;
        --cluster-cidr)
            k3s_cluster_cidr="${2:-}"
            shift 2
            ;;
        --service-cidr)
            k3s_service_cidr="${2:-}"
            shift 2
            ;;
        --kubeconfig)
            k3s_kubeconfig_local="${2:-}"
            shift 2
            ;;
        --skip-kubeconfig)
            k3s_copy_kubeconfig=false
            shift
            ;;
        -h | --help)
            usage
            exit 0
            ;;
        *)
            msg "unknown option: $1" "error"
            exit 1
            ;;
        esac
    done
}

main_pacman() {
    require_pacman conntrack-tools curl ethtool iptables-nft ipset socat cni-plugins nfs-utils open-iscsi containerd
}

ensure_config_dir() {
    if [[ ! -d "${k3s_config_dir}" ]]; then
        msg "create ${k3s_config_dir}"
        sudo install -d -m 0750 -o root -g root "${k3s_config_dir}"
    fi
}

write_config_file() {
    local tmp
    tmp=$(mktemp)

    {
        echo "write-kubeconfig-mode: \"0644\""
        echo "cluster-name: \"${k3s_cluster_name}\""
        echo "data-dir: \"${k3s_data_dir}\""
        echo "cluster-cidr: \"${k3s_cluster_cidr}\""
        echo "service-cidr: \"${k3s_service_cidr}\""
        echo "node-taint:"
        echo '  - "node-role.kubernetes.io/control-plane=true:NoSchedule"'
        echo "node-label:"
        echo '  - "node-role.kubernetes.io/control-plane=true"'

        if [[ -n "${k3s_node_ip}" ]]; then
            echo "node-ip: \"${k3s_node_ip}\""
        fi
        if [[ -n "${k3s_flannel_iface}" ]]; then
            echo "flannel-iface: \"${k3s_flannel_iface}\""
        fi

        if [[ ${#k3s_disable_components[@]} -gt 0 ]]; then
            echo "disable:"
            for component in "${k3s_disable_components[@]}"; do
                echo "  - ${component}"
            done
        fi

        if [[ ${#k3s_tls_sans[@]} -gt 0 ]]; then
            echo "tls-san:"
            for san in "${k3s_tls_sans[@]}"; do
                echo "  - ${san}"
            done
        fi
    } >"${tmp}"

    sudo install -o root -g root -m 0600 "${tmp}" "${k3s_config_file}"
    rm -f "${tmp}"
    msg "wrote configuration to ${k3s_config_file}"
}

install_k3s() {
    local exec_cmd="server --config ${k3s_config_file}"
    msg "installing k3s (${k3s_channel} channel)"
    if ! curl -sfL https://get.k3s.io | sudo env INSTALL_K3S_CHANNEL="${k3s_channel}" INSTALL_K3S_EXEC="${exec_cmd}" sh -; then
        msg "k3s installer failed" "error"
        return 1
    fi

    sudo k3s check-config

    sudo systemctl enable --now k3s.service
    sudo systemctl enable --now containerd.service
}

wait_for_file() {
    local path=$1
    local retries=15
    local delay=2

    for ((i = 0; i < retries; i++)); do
        if sudo test -f "${path}"; then
            return 0
        fi
        sleep "${delay}"
    done

    return 1
}

copy_kubeconfig() {
    if [[ "${k3s_copy_kubeconfig}" != true ]]; then
        return
    fi

    local src="/etc/rancher/k3s/k3s.yaml"
    if ! wait_for_file "${src}"; then
        msg "kubeconfig not found at ${src} yet" "warn"
        return
    fi

    local dest="${k3s_kubeconfig_local}"
    mkdir -p "$(dirname "${dest}")"
    sudo cp "${src}" "${dest}"
    sudo chown "${USER}:${USER}" "${dest}"
    msg "kubeconfig copied to ${dest}"
}

print_summary() {
    if [[ "${k3s_copy_kubeconfig}" = true ]]; then
        msg "export KUBECONFIG=${k3s_kubeconfig_local} && kubectl get nodes"
    else
        msg "use sudo kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml get nodes"
    fi
}

main() {
    ensure_config_dir
    write_config_file
    install_k3s
    copy_kubeconfig
    print_summary
}
