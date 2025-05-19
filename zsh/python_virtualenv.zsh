#!/usr/bin/env zsh

export VIRTUAL_ENV_DISABLE_PROMPT=1

declare -g virtualenv_prompt_msg
declare -g _virtualenv_prompt_virtualenv_version
declare -g _virtualenv_prompt_python_version

virtualenv_prompt_msg=""

_virtualenv_prompt_update() {
    # Check if virtualenv is active
    if [[ -z "$VIRTUAL_ENV" ]]; then
        virtualenv_prompt_msg=""
        return
    fi

    # Ignore if the virtualenv is from pyenv
    if [[ "$VIRTUAL_ENV" == *"$HOME/.pyenv/versions/"* ]]; then
        virtualenv_prompt_msg=""
        return
    fi

    # Get the virtualenv name from the VIRTUAL_ENV_PROMPT variable
    # remove the brackets and other special characters from the virtualenv name
    _virtualenv_prompt_virtualenv_name="${VIRTUAL_ENV_PROMPT//[^a-zA-Z0-9._-]/}"

    _virtualenv_prompt_python_version=$(python -c "import platform; print('%s %s' % (platform.python_implementation(), platform.python_version()))")
    virtualenv_prompt_msg=" %F{242}󱔎 venv:$_virtualenv_prompt_virtualenv_name ($_virtualenv_prompt_python_version)%f"
}

add-zsh-hook precmd _virtualenv_prompt_update
