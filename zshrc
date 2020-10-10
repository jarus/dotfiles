if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
  export LC_CTYPE='en_US.UTF-8'
  export LC_ALL='en_US.UTF-8'
fi

ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "modules/utility", from:prezto
zplug "modules/terminal", from:prezto
zplug "modules/history", from:prezto
zplug "modules/ssh", from:prezto
zplug "modules/python", from:prezto
zplug "modules/completion", from:prezto

zplug "~/.zsh", as:theme, from:local

zplug load

fpath=(
  /usr/local/share/zsh/functions
  $fpath
)

if [ -f ~/.zshrc_local ]; then
    source ~/.zshrc_local
fi

# Fix forward-delete in zsh under macOS (fn + backspace)
bindkey "^[[3~" delete-char
