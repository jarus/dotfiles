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
source ~/.dotfiles/zsh/history.zsh

setopt PROMPT_SUBST
PROMPT=$'
'

if [[ $OSTYPE == "darwin"* ]]; then
    PROMPT+=$'%F{242}%n%f@%F{166}%m%f '
else
    PROMPT+=$'%F{242}%n%f@%F{190}%m%f '
fi

PROMPT+=$'%F{blue}%~%f$vcs_info_msg_0_$pyenv_prompt_msg\n%(?.%F{yellow}.%F{red})$%f '

zinit wait lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  atload"zicompinit; zicdreplay" blockf \
    zsh-users/zsh-completions \
  atload"zicompinit; zicdreplay" blockf \
    spwhitt/nix-zsh-completions

if [[ -d "$HOME/.pyenv/" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH=$HOME/.pyenv/bin:$PATH
fi

zinit ice wait'!' silent atload'_pyenv_prompt_update'
zinit snippet ~/.dotfiles/zsh/pyenv.zsh

zinit ice has'docker'
zinit snippet https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker

if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
    source ~/.nix-profile/etc/profile.d/nix.sh
fi

if [ -e /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export HOMEBREW_NO_ENV_HINTS=1

    zinit ice as"completion"
    zinit snippet $(brew --prefix)/share/zsh/site-functions/_brew
fi

if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH=$HOME/.cargo/bin:$PATH

  zinit ice as"completion" has"rustup" \
    atclone"rustup completions zsh > _rustup && rustup completions zsh cargo > _cargo" \
    atpull="%atclone" \
    run-atpull \
    atload"zicompinit; zicdreplay" \
    nocompile
  zinit load zdharma-continuum/null
fi

if [[ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]]; then
  export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin":$PATH
fi

if [[ "$VSCODE_INJECTION" == "1" ]]; then
  echo "Apply workaround for VSCode SSH Agent Forwarding bug #168202"
  export SSH_AUTH_SOCK=$(ls -t /tmp/ssh-**/* | head -1)
fi

zinit light Aloxaf/fzf-tab
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' fzf-flags '--info=hidden' '--no-separator'
zstyle ':fzf-tab:*' fzf-min-height 50
zstyle ':fzf-tab:*' switch-group 'left' 'right'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
zstyle ':completion:*:*:*:*:processes' command 'sudo ps ax -o pid,user,command'

zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search
typeset ZSH_FZF_HISTORY_SEARCH_FZF_EXTRA_ARGS='--layout=reverse --height 50% --info=hidden --no-separator'

if [ -f ~/.zshrc_local ]; then
    source ~/.zshrc_local
fi

# Fix forward-delete in zsh under macOS (fn + backspace)
bindkey "^[[3~" delete-char

alias ll="ls -alh --color"
alias servit="python3 -m http.server 9000"

if [[ "$TERM" == "xterm-256color" ]]; then
  # Configure btop to use low color mode if term identifies as xterm-256color
  # like Terminal.app on macOS
  alias btop="btop --low-color"
fi
