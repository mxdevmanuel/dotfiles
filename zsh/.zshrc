# P10k instant prompt — must be near the top, before any output
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -n "$SSH_CONNECTION" && -z "$TMUX" ]]; then
	tmux attach || tmux new-session
	exit
fi

# Linux only: macOS manages ssh-agent via launchd and sets SSH_AUTH_SOCK automatically
[[ "$OSTYPE" == linux* ]] && export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

HISTFILE="$HOME/.histfile"
HISTSIZE=10000
SAVEHIST=10000

setopt appendhistory
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

bindkey -v

# Antidote: bootstrap on first run, then load plugins from ~/.zsh_plugins.txt
ANTIDOTE_HOME=${ZDOTDIR:-$HOME}/.antidote
if [[ ! -d $ANTIDOTE_HOME ]]; then
	git clone --depth=1 https://github.com/mattmc3/antidote.git $ANTIDOTE_HOME
fi
zstyle ':antidote:bundle' use-friendly-names 'yes'
# zsh-nvm lazy loading (NVM_LAZY_LOAD works for lukechilds/zsh-nvm)
export NVM_LAZY_LOAD=true
source $ANTIDOTE_HOME/antidote.zsh
antidote load

_fzf_cache="${XDG_CACHE_HOME:-$HOME/.cache}/fzf_init.zsh"
[[ ! -f $_fzf_cache ]] && fzf --zsh >| $_fzf_cache
zsh-defer source $_fzf_cache

command -v direnv &>/dev/null && zsh-defer -c 'eval "$(direnv hook zsh)"'

zstyle ':completion:*' menu select

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"

alias ls="eza"

alias k=kubectl
alias kseal="kubeseal --controller-name sealed-secrets --controller-namespace kube-system --format yaml"

autoload -Uz compinit

if [[ ! -f /tmp/firstrun ]] then
	compinit
	touch /tmp/firstrun
else
	compinit -C
fi

source ${ZDOTDIR:-$HOME}/.local/share/zsh/aliases/git

if command -v kubectl &>/dev/null; then
	export KUBECONFIG="$HOME/.kube/config"
	# Cache kubectl completions — regenerate only when kubectl binary changes
	_kubectl_completion="${XDG_CACHE_HOME:-$HOME/.cache}/kubectl_completion.zsh"
	if [[ ! -f $_kubectl_completion || "$(command -v kubectl)" -nt $_kubectl_completion ]]; then
		kubectl completion zsh >| $_kubectl_completion
	fi
	source $_kubectl_completion
	compdef _kubectl k
fi

# Auto-switch node version on directory change, silent and no-op when no .nvmrc
_auto_nvm_use() {
	[[ -f .nvmrc ]] || return 0
	nvm use
}
autoload -Uz add-zsh-hook
add-zsh-hook chpwd _auto_nvm_use
zsh-defer _auto_nvm_use

alias diffancy='git diff | diff-so-fancy'

# Google Cloud SDK — Linux uses ~/.google-cloud-sdk, macOS uses ~/google-cloud-sdk
_gcloud_base=""
[[ -d "$HOME/.google-cloud-sdk" ]] && _gcloud_base="$HOME/.google-cloud-sdk"
[[ -z "$_gcloud_base" && -d "$HOME/google-cloud-sdk" ]] && _gcloud_base="$HOME/google-cloud-sdk"

if [[ -n "$_gcloud_base" ]]; then
	[[ -f "$_gcloud_base/path.zsh.inc" ]] && source "$_gcloud_base/path.zsh.inc"
	[[ -f "$_gcloud_base/completion.zsh.inc" ]] && zsh-defer source "$_gcloud_base/completion.zsh.inc"
fi
unset _gcloud_base
