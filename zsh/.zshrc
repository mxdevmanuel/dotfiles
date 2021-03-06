# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ZSH and Oh-my-zsh config
# zmodload zsh/zprof #enable zsh profiling

# Path to your oh-my-zsh installation.
export ZSH="/home/manuel/.oh-my-zsh"
export EDITOR=vim
export VISUAL=vim

# COMPLETION_WAITING_DOTS="true"

# DISABLE_UNTRACKED_FILES_DIRTY="true"

ZSH_THEME='powerlevel10k/powerlevel10k'

[[ "$TERM" == "linux" ]] || [[ ! -z "$NOTMUX"  ]] && ZSH_TMUX_AUTOSTART="false" || ZSH_TMUX_AUTOSTART="true"
ZSH_TMUX_AUTOCONNECT="false"
ZSH_TMUX_FIXTERM="true"
ZSH_TMUX_FIXTERM_WITHOUT_256COLOR="tmux"
ZSH_TMUX_FIXTERM_WITH_256COLOR="tmux-256color"

plugins=(
        git ssh-agent vi-mode zsh-syntax-highlighting tmux docker z
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Aliases
alias open="xdg-open"
alias ssh="TERM=xterm-256color ssh"
alias btctl="bluetoothctl"
alias packs="pacman -Q | wc -l"

alias nvm="load-nvm && nvm"
alias npm="load-nvm ; npm"
alias node="load-nvm ; node"

alias vimc="nvim ~/.config/nvim/init.vim"
alias vimd="env FORCE_DARK='true' nvim"
alias vimq="env FORCE_DARK='true' nvim-qt"

alias ls='exa'
alias la='exa -a'
alias ll='exa -l'
alias lll='exa -l | less'
alias lla='exa -la'
alias llt='exa -T'
alias llfu='exa -bghHliS --git'

alias tig='vim -c GV'

# Config variables
export DEFAULT_USER="manuel"
export VIRTUAL_ENV_DISABLE_PROMPT="Y"

# Functions
function CD(){
        cd $@
}

function load-nvm() {
        # if nvm command is present nvm is ready no need to load
        if [[ $(command -v nvm) == "nvm" ]]; then
                #echo "nvm is ready"
        else
                # unalias nvm if alias exists
                [ `alias | grep nvm | wc -l` != 0 ] && unalias nvm

                echo "loading nvm..."
                export NVM_DIR="$HOME/.nvm"
                [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
                [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
        fi
}

function autoload-nvm(){
        if [[ -f ./package.json ]]; then
                load-nvm
        fi
}

function diffancy(){
        git diff $@ --color | diff-so-fancy | less
}

function flocate(){
        locate -i $@ | fzf | xargs -I% vim %
}

function gi() { curl -sLw n https://www.gitignore.io/api/$@ ;}

function unexa() { unalias ls }

function venv-select(){
        RED='\033[0;31m'
        NC='\033[0m' # No Color

        envs=$(find ~/Envs -maxdepth 1 -mindepth 1 -type d)
        selected=$(echo $envs | awk '{n=split($0,a,"/"); print a[n]}' | fzf)

        if [[ $? != 130 ]]
        then
                if [[ ! -z "$VIRTUAL_ENV" ]] 
                then
                        echo -e "${RED}unsetting $VIRTUAL_ENV${NC}" 
                        deactivate 
                fi
                complete=$(echo $envs | grep $selected)
                echo "sourcing $complete"
                source $complete/bin/activate
        fi
}

# Init 
[ ! -f /tmp/firstrun ] && clear && neofetch && touch /tmp/firstrun

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ ! -z "$VENV" ]]
then
        source $VENV/bin/activate
fi

if [[ $TERM == rxvt ]];
then
        export TERM=rxvt-unicode
fi

add-zsh-hook chpwd autoload-nvm
autoload-nvm

eval "$(direnv hook zsh)"

# For powerlevel10k, to customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
prompt_context(){}
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
# zprof # start zsh profiling
