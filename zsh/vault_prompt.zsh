#!/usr/bin/env zsh

_vault_prompt_update() {
    if [[ -n $VAULT_ADDR ]]; then
        vault_addr=${VAULT_ADDR#http://}
        vault_addr=${vault_addr#https://}
        vault_prompt_msg=" %F{242} vault:$vault_addr"

        if [[ -n $VAULT_NAMESPACE ]]; then
            vault_prompt_msg+=" $VAULT_NAMESPACE"
        fi

        vault_prompt_msg+="%f"
    else
        vault_prompt_msg=""
    fi
}

add-zsh-hook precmd _vault_prompt_update
