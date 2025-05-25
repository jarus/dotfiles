#!/usr/bin/env zsh

export KUBIE_PROMPT_DISABLE=1

declare -g kubie_prompt_msg
kubie_prompt_msg=""

_kubie_prompt_update() {
    if [[ $KUBIE_ACTIVE != 1 ]]; then
        kubie_prompt_msg=""
        return
    fi

    _kubie_prompt_ctx=$(kubie info ctx)
    _kubie_prompt_ns=$(kubie info ns)
    kubie_prompt_msg=" %F{242}󱃾 kubie:$_kubie_prompt_ctx/$_kubie_prompt_ns%f"
}

add-zsh-hook precmd _kubie_prompt_update
