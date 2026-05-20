# P10k instant prompt — must be near the top, before any output
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if (( $+commands[tmux] )) && [[ -z "$TMUX" && -z "$VIM" && "$TERM_PROGRAM" != "vscode" ]]; then
	tmux new-session -A
	exit
fi

# ── Env ───────────────────────────────────────────────────────────────────────
# Linux only: macOS manages ssh-agent via launchd and sets SSH_AUTH_SOCK automatically
[[ "$OSTYPE" == linux* ]] && export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export NVM_LAZY_LOAD=true   # must be set before antidote loads zsh-nvm

# ── History ───────────────────────────────────────────────────────────────────
HISTFILE="$HOME/.histfile"
HISTSIZE=10000
SAVEHIST=10000
setopt APPENDHISTORY SHARE_HISTORY HIST_IGNORE_DUPS

# ── Key bindings ──────────────────────────────────────────────────────────────
bindkey -v

# Cursor shape: beam in insert mode, block in normal mode
function zle-keymap-select {
	if [[ ${KEYMAP} == vicmd || $1 == block ]]; then
		printf '\e[2 q'
	else
		printf '\e[6 q'
	fi
}
zle -N zle-keymap-select
function zle-line-init { printf '\e[?25h\e[6 q'; }
zle -N zle-line-init
preexec() { printf '\e[?25h\e[6 q'; }

# ── Plugins ───────────────────────────────────────────────────────────────────
ANTIDOTE_HOME=${ZDOTDIR:-$HOME}/.antidote
[[ -d $ANTIDOTE_HOME ]] || git clone --depth=1 https://github.com/mattmc3/antidote.git $ANTIDOTE_HOME
zstyle ':antidote:bundle' use-friendly-names 'yes'
source $ANTIDOTE_HOME/antidote.zsh
antidote load

# ── Completions ───────────────────────────────────────────────────────────────
autoload -Uz compinit add-zsh-hook
zstyle ':completion:*' menu select

if [[ ! -f /tmp/firstrun ]]; then
	compinit && touch /tmp/firstrun
else
	compinit -C
fi

source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/catppuccin-mocha.zsh"

if command -v kubectl &>/dev/null; then
	export KUBECONFIG="$HOME/.kube/config"
	_kubectl_completion="${XDG_CACHE_HOME:-$HOME/.cache}/kubectl_completion.zsh"
	if [[ ! -f $_kubectl_completion || "$(command -v kubectl)" -nt $_kubectl_completion ]]; then
		kubectl completion zsh >| $_kubectl_completion
	fi
	source $_kubectl_completion
	compdef _kubectl k
fi

# ── Deferred ──────────────────────────────────────────────────────────────────
_fzf_cache="${XDG_CACHE_HOME:-$HOME/.cache}/fzf_init.zsh"
[[ -f $_fzf_cache ]] || fzf --zsh >| $_fzf_cache
zsh-defer source $_fzf_cache
unset _fzf_cache

command -v direnv &>/dev/null && zsh-defer -c 'eval "$(direnv hook zsh)"'

# ── Prompt ────────────────────────────────────────────────────────────────────
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# ── Aliases ───────────────────────────────────────────────────────────────────
alias ls='eza'
alias diffancy='git diff | diff-so-fancy'
alias k=kubectl
alias kseal='kubeseal --controller-name sealed-secrets --controller-namespace kube-system --format yaml'

source ${ZDOTDIR:-$HOME}/.local/share/zsh/aliases/git

# ── Tools ─────────────────────────────────────────────────────────────────────
# Auto-switch node version on directory change
_auto_nvm_use() { [[ -f .nvmrc ]] && nvm use; }
add-zsh-hook chpwd _auto_nvm_use
zsh-defer _auto_nvm_use

# Google Cloud SDK — Linux uses ~/.google-cloud-sdk, macOS uses ~/google-cloud-sdk
_gcloud_base=""
[[ -d "$HOME/.google-cloud-sdk" ]] && _gcloud_base="$HOME/.google-cloud-sdk"
[[ -z "$_gcloud_base" && -d "$HOME/google-cloud-sdk" ]] && _gcloud_base="$HOME/google-cloud-sdk"
if [[ -n "$_gcloud_base" ]]; then
	[[ -f "$_gcloud_base/path.zsh.inc" ]] && source "$_gcloud_base/path.zsh.inc"
	[[ -f "$_gcloud_base/completion.zsh.inc" ]] && zsh-defer source "$_gcloud_base/completion.zsh.inc"
fi
unset _gcloud_base
