#!/usr/bin/env zsh

export PYENV_ROOT="$HOME/.pyenv"
export PATH=$HOME/.pyenv/bin:$PATH

export VIRTUAL_ENV_DISABLE_PROMPT=1
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

eval "$(pyenv init --path)"
eval "$(pyenv init - zsh)"

declare -g pyenv_prompt_msg
declare -g _pyenv_prompt_pyenv_version
declare -g _pyenv_prompt_python_version

pyenv_prompt_msg=""

_pyenv_prompt_update() {
    if [[ $_pyenv_prompt_pyenv_version == $PYENV_VERSION ]]; then
        return
    fi

    _pyenv_prompt_pyenv_version=$PYENV_VERSION
    if [[ "${_pyenv_prompt_pyenv_version:-system}" == "system" ]]; then
        _pyenv_prompt_python_version=""
        pyenv_prompt_msg=""
        return
    fi

    _pyenv_prompt_python_version=$(python -c "import platform; print('%s %s' % (platform.python_implementation(), platform.python_version()))")
    pyenv_prompt_msg=" %F{242} py:$_pyenv_prompt_pyenv_version ($_pyenv_prompt_python_version)%f"
}

add-zsh-hook precmd _pyenv_prompt_update
