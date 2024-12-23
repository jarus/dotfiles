#!/usr/bin/env zsh

_rust_prompt_update() {
    if is-recursive-exist Cargo.toml; then
        rust_version_prompt_msg=" %F{242} rust:$(rustc --version | awk '{print $2}')%f"
    else
        rust_version_prompt_msg=""
    fi
}

add-zsh-hook precmd _rust_prompt_update
