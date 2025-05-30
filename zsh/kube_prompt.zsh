#!/usr/bin/env zsh

declare -g kube_prompt_msg
kube_prompt_msg=""

_kube_prompt_update() {
    if [[ -z $KUBECONFIG ]]; then
        kube_prompt_msg=""
        return
    fi

    _kube_prompt_ctx=$(kubectl config current-context 2>/dev/null)
    _kube_prompt_ns=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)

    kube_prompt_msg=" %F{242}󱃾 $_kube_prompt_ctx"
    if [[ -n $_kube_prompt_ns ]]; then
        kube_prompt_msg+="/$_kube_prompt_ns"
    fi
    kube_prompt_msg+="%f"
}

add-zsh-hook precmd _kube_prompt_update
