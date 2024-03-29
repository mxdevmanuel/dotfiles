# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ZSH and Oh-my-zsh config

# Profile start
# zmodload zsh/zprof #enable zsh profiling

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export ZSHSHARE="$HOME/.local/share/zsh"
export EDITOR=vim
export VISUAL=vim

ZSH_THEME='powerlevel10k/powerlevel10k'

[[ "$TERM" == "linux" ]] || [[ ! -z "$NOTMUX"  ]] && ZSH_TMUX_AUTOSTART="false" || ZSH_TMUX_AUTOSTART="true"
ZSH_TMUX_AUTOCONNECT="false"
ZSH_TMUX_FIXTERM="true"
ZSH_TMUX_FIXTERM_WITHOUT_256COLOR="tmux"
ZSH_TMUX_FIXTERM_WITH_256COLOR="tmux-256color"

VI_MODE_SET_CURSOR=true

plugins=(
        git vi-mode tmux fzf docker direnv colored-man-pages z zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

fpath=($fpath $ZSHSHARE/autoloaded)

# User configuration

# Aliases
alias open="xdg-open"
alias ssh="TERM=xterm-256color ssh"
alias btctl="bluetoothctl"
alias packs="pacman -Q | wc -l"

unalias l
alias l='exa -la'
alias ls='exa'
alias la='exa -a'
alias ll='exa -l'
alias lll='exa -l | less'
alias lla='exa -la'
alias lt='exa -T'
alias lta='exa -Ta'
alias ltla='exa -Tla'

alias project='cd `find ~/Code -type d -and -name .git -exec dirname {} \; | fzf --height "40%"`'

alias yarnw='yarn workspace'

# Functions

# if [[ -z "$THEMED" ]]
# then
# 	hour=$(date +"%H")
# 	if [[ $(echo "$hour > 9" | bc) == "1" ]] && [[ $(echo "$hour < 19 " | bc) == "1" ]]
# 	then
# 		setTheme gruvbox-light light.toml light 1
# 	else
# 		setTheme gruvbox-dark dark.toml dark 2
# 	fi
# fi

function unexa() { unalias ls }

function flocate(){ locate -i $@ | fzf | xargs -I% vim % }

function cheat(){ cache-command.sh curl cht.sh/${@} }

autoload -Uz gi 

autoload -Uz diffancy

autoload -Uz venv-select

autoload -Uz setTheme

alias setdarktheme="setTheme gruvbox-dark dark.toml dark 2"
alias setlighttheme="setTheme gruvbox-light light.toml light 1"

autoload -Uz _nvm
alias nvm="_nvm"

function load-nvmrc(){
	if [[ -f ".nvmrc" ]]
	then
		nvm use
	fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Init 
[ ! -z "$FIRSTRUN" ] && [[ ! -f /tmp/firstrun ]] && lolarch.zsh && touch /tmp/firstrun

# For powerlevel10k, to customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
prompt_context(){}
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Profile end
# zprof # start zsh profiling

# The next line updates PATH for Netlify's Git Credential Helper.
test -f '/home/manuel/.config/netlify/helper/path.zsh.inc' && source '/home/manuel/.config/netlify/helper/path.zsh.inc'
