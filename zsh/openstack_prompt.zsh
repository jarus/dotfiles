#!/usr/bin/env zsh

_openstack_prompt_update() {
    if [[ -n $OS_PROJECT_NAME ]]; then
        openstack_prompt_msg=" %F{242} os:$OS_REGION_NAME/$OS_USER_DOMAIN_NAME/$OS_PROJECT_NAME%f"
    else
        openstack_prompt_msg=""
    fi
}

add-zsh-hook precmd _openstack_prompt_update
