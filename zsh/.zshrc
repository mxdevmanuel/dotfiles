# ZSH and Oh-my-zsh config

# Profile start
zmodload zsh/zprof #enable zsh profiling

# Path to your oh-my-zsh installation.
export ZSH="/home/manuel/.oh-my-zsh"
export ZSHSHARE="$HOME/.local/share/zsh"
export EDITOR=vim
export VISUAL=vim


ZSH_THEME='powerlevel10k/powerlevel10k'

[[ "$TERM" == "linux" ]] || [[ ! -z "$NOTMUX"  ]] && ZSH_TMUX_AUTOSTART="false" || ZSH_TMUX_AUTOSTART="true"
ZSH_TMUX_AUTOCONNECT="false"
ZSH_TMUX_FIXTERM="true"
ZSH_TMUX_FIXTERM_WITHOUT_256COLOR="tmux"
ZSH_TMUX_FIXTERM_WITH_256COLOR="tmux-256color"

plugins=(
        git ssh-agent vi-mode tmux fzf docker direnv colored-man-pages z zsh-syntax-highlighting
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
alias llt='exa -T'
# alias llfu='exa -bghHliS --git'
# alias l='exa -lbF --git'                                               # list, size, type, git
# alias ll='exa -lbGF --git'                                             # long list
# alias llm='exa -lbGF --git --sort=modified'                            # long list, modified date sort
# alias lc='exa -lbhHigmuSa --time-style=long-iso --git --color-scale'  # all list
# alias lx='exa -lbhHigmuSa@ --time-style=long-iso --git --color-scale' # all + extended list

# # speciality views
# alias lS='exa -1'			                                                  # one column, just names
# alias lt='exa --tree --level=2'                                         # tree

alias tig='vim -c GV'

# Config variables
export DEFAULT_USER="manuel"
export VIRTUAL_ENV_DISABLE_PROMPT="Y"

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

function gi() { curl -sLw "\n" https://www.gitignore.io/api/$@ ;}

autoload -Uz diffancy

autoload -Uz venv-select

autoload -Uz setTheme

alias setdarktheme="setTheme gruvbox-dark dark.toml dark 2"
alias setlighttheme="setTheme gruvbox-light light.toml light 1"

autoload -Uz _nvm
alias nvm="_nvm"

# Init 
[ ! -z "$FIRSTRUN" ] && [[ ! -f /tmp/firstrun ]] && clear && neofetch && touch /tmp/firstrun

# For powerlevel10k, to customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
prompt_context(){}
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Profile end
zprof # start zsh profiling
