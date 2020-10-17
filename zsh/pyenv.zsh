#!/usr/bin/env zsh

if type pyenv > /dev/null; then
    eval "$(pyenv init -)"
fi
if type pyenv-virtualenv > /dev/null; then
    eval "$(pyenv virtualenv-init -)"
fi
