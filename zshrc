if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
  export LC_CTYPE='en_US.UTF-8'
  export LC_ALL='en_US.UTF-8'
fi

typeset -U PATH

source ~/.zinit/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit ice compile'async.zsh' pick'async.zsh'
zinit load mafredri/zsh-async

autoload -Uz vcs_info
autoload -Uz add-zsh-hook

() {
    zstyle ':vcs_info:*' enable git

    local formats=" %b%c%u"
    local actionformats="${formats} %F{yellow}!%a%f"
    zstyle ':vcs_info:*:*' formats $formats
    zstyle ':vcs_info:*:*' actionformats $actionformats
    zstyle ':vcs_info:*:*' stagedstr "%F{green}●%f"
    zstyle ':vcs_info:*:*' unstagedstr "%F{yellow}●%f"
    zstyle ':vcs_info:*:*' check-for-changes true
    zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

    +vi-git-untracked(){
        if [[ ! $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]]; then
            return
        fi

        while IFS= read -r line; do
            if [[ $line == $'# branch.ab '* ]]; then
                local -a splitted_line
                splitted_line=( ${(s: :)line} )

                if [[ ${splitted_line[3]} != "+0" || ${splitted_line[4]} != "-0" ]]; then
                    hook_com[branch]+=" %F{cyan}("
                    if [[ ${splitted_line[3]} != "+0" ]]; then
                        hook_com[branch]+="↑${splitted_line[3]:1}"
                    fi
                    if [[ ${splitted_line[3]} != "+0" && ${splitted_line[4]} != "-0" ]]; then
                        hook_com[branch]+=" "
                    fi
                    if [[ ${splitted_line[4]} != "-0" ]]; then
                        hook_com[branch]+="↓${splitted_line[4]:1}"
                    fi
                    hook_com[branch]+=")%f"
                fi
                hook_com[branch]+=" "
            fi
            if [[ $line == $'? '* ]]; then
                hook_com[staged]+="%F{red}●%f"
                break
            fi
        done < <(git status --branch --porcelain=v2 2> /dev/null)
    }
}

source ~/.dotfiles/zsh/terminal.zsh
source ~/.dotfiles/zsh/async_vcs_info.zsh

setopt PROMPT_SUBST
PROMPT=$'
'

if [[ $OSTYPE == "darwin"* ]]; then
    PROMPT+=$'%F{242}%n%f@%F{166}%m%f '
else
    PROMPT+=$'%F{242}%n%f@%F{190}%m%f '
fi

PROMPT+=$'%F{blue}%~%f$vcs_info_msg_0_$pyenv_prompt_msg
%(?.%F{yellow}.%F{red})$%f '

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format '%F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format '%F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format '%F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      zdharma/fast-syntax-highlighting \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions \
  blockf atpull'zinit creinstall -q .' \
      spwhitt/nix-zsh-completions

if [[ -d "$HOME/.pyenv/" ]]; then
  export PATH=$HOME/.pyenv/bin:$PATH
fi

zinit ice wait'!' silent atload'_pyenv_prompt_update'
zinit snippet ~/.dotfiles/zsh/pyenv.zsh

if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
    source ~/.nix-profile/etc/profile.d/nix.sh
fi

if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH=$HOME/.cargo/bin:$PATH
fi

if [ -f ~/.zshrc_local ]; then
    source ~/.zshrc_local
fi

# Fix forward-delete in zsh under macOS (fn + backspace)
bindkey "^[[3~" delete-char
