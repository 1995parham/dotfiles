#!/usr/bin/env bash

usage() {
    echo "k8s and openshift command line tools (kubectl, oc, stern, etc.)"
    # shellcheck disable=2028
    echo '
 _          _               _   _
| | ___   _| |__   ___  ___| |_| |
| |/ / | | | |_ \ / _ \/ __| __| |
|   <| |_| | |_) |  __/ (__| |_| |
|_|\_\\__,_|_.__/ \___|\___|\__|_|

	'
}

main_brew() {
    require_brew kubernetes-cli helm stern argocd openshift-cli kubectx krew fluxcd/tap/flux k9s kubeseal
}

main_pacman() {
    export allow_no_aur=true

    require_pacman kubectl helm argocd kubectx stern k9s fluxcd krew kubeseal
    require_aur okd-client-bin
}

main() {
    msg 'install helm-ls on neovim'
    require_mason 'helm-ls'

    msg "awesome chart repositories for helm"
    # Bitnami has migrated into OCI registry, which can be used directly.
    # helm repo add bitnami https://charts.bitnami.com/bitnami || true
    helm repo add nats https://nats-io.github.io/k8s/helm/charts || true
    helm repo add emqx https://repos.emqx.io/charts || true

    helm repo update

    msg 'required kubectl plugins (using krew)'
    kubectl krew install kuttl cnpg

    msg 'required helm plugins (using helm plugin manager)'
    if helm plugin list | grep "diff"; then
        helm plugin update diff
    else
        helm plugin install https://github.com/databus23/helm-diff
    fi

    configfile k9s
}
