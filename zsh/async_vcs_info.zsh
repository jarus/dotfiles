#!/usr/bin/env zsh

_async_vcs_info_start() {
    async_start_worker vcs_info
    async_register_callback vcs_info _async_vcs_info_done
}

_async_vcs_info_get_vcs_info_msg() {
    cd -q $1
    vcs_info
    print ${vcs_info_msg_0_}
}

_async_vcs_info_done() {
    local job=$1
    local return_code=$2
    local stdout=$3
    local more=$6
    if [[ $job == '[async]' ]]; then
        if [[ $return_code -eq 2 ]]; then
            # Need to restart the worker. Stolen from
            # https://github.com/mengelbrecht/slimline/blob/master/lib/async.zsh
            _async_vcs_info_start
            return
        fi
    fi
    vcs_info_msg_0_=$stdout
    [[ $more == 1 ]] || zle reset-prompt
}

_async_vcs_info_precmd_handler() {
    async_job vcs_info _async_vcs_info_get_vcs_info_msg $PWD
}

_async_vcs_info_chpwd_handler() {
    vcs_info_msg_0_=
}

# Asynchronous VCS status
_async_vcs_info_start
add-zsh-hook precmd _async_vcs_info_precmd_handler
add-zsh-hook chpwd _async_vcs_info_chpwd_handler
