# ZSH and zinit config

# Profile start
# zmodload zsh/zprof #enable zsh profiling

export ZSHSHARE="$HOME/.local/share/zsh" # Path to custom autoload functions
export EDITOR=vim
export VISUAL=vim

ZSH_THEME='powerlevel10k/powerlevel10k'

[[ "$TERM" == "linux" ]] || [[ ! -z "$NOTMUX"  ]] && ZSH_TMUX_AUTOSTART="false" || ZSH_TMUX_AUTOSTART="true"
ZSH_TMUX_AUTOCONNECT="false"
ZSH_TMUX_FIXTERM="true"
ZSH_TMUX_FIXTERM_WITHOUT_256COLOR="tmux"
ZSH_TMUX_FIXTERM_WITH_256COLOR="tmux-256color"

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

setopt promptsubst

zinit snippet OMZL::clipboard.zsh
zinit snippet OMZL::termsupport.zsh
zinit snippet OMZL::git.zsh

zinit snippet OMZP::git
zinit snippet OMZP::ssh-agent
zinit snippet OMZP::vi-mode
zinit snippet OMZP::tmux
zinit snippet OMZP::docker
zinit snippet OMZP::fzf
zinit snippet OMZP::direnv
zinit snippet OMZP::colored-man-pages

zinit light zsh-users/zsh-syntax-highlighting
zinit load agkozak/zsh-z

zinit ice depth=1;zinit light romkatv/powerlevel10k


fpath=($fpath $ZSHSHARE/autoloaded)

# User configuration

# Aliases
alias open="xdg-open"
alias ssh="TERM=xterm-256color ssh"
alias btctl="bluetoothctl"
alias packs="pacman -Q | wc -l"

alias l='exa -la'
alias ls='exa'
alias la='exa -a'
alias ll='exa -l'
alias lll='exa -l | less'
alias lla='exa -la'
alias lt='exa -T'
alias lta='exa -Ta'
alias ltla='exa -Tla'

alias tig='vim -c GV'

# Functions

function unexa() { unalias ls }

function flocate(){ locate -i $@ | fzf | xargs -I% vim % }

autoload -Uz gi 

autoload -Uz diffancy

autoload -Uz venv-select

autoload -Uz setTheme

alias setdarktheme="setTheme gruvbox-dark dark.toml dark 2"
alias setlighttheme="setTheme gruvbox-light light.toml light 1"

autoload -Uz _nvm
alias nvm="_nvm"

# Init 
[ ! -z "$FIRSTRUN" ] && [[ ! -f /tmp/firstrun ]] && lolarch.zsh && touch /tmp/firstrun

# For powerlevel10k, to customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
prompt_context(){}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Profile end
# zprof # start zsh profiling
