#!/usr/bin/env bash
# Periodic refresh for terminal tooling not managed by pacman.
# Safe to re-run; updates everything in place.
# - antidote plugin bundle (rebuilds ~/.zsh_plugins.zsh)
# - tpm (tmux plugin manager)
# - nvm (if cloned; zsh-nvm installs it lazily on first use)

set -e

# Antidote plugins
ANTIDOTE_HOME=${ANTIDOTE_HOME:-$HOME/.antidote}
PLUGINS_TXT=$HOME/.zsh_plugins.txt
PLUGINS_ZSH=$HOME/.zsh_plugins.zsh

if [[ -d $ANTIDOTE_HOME ]] && [[ -f $PLUGINS_TXT ]]; then
	echo "==> Updating antidote bundles"
	zsh -c "source $ANTIDOTE_HOME/antidote.zsh && antidote update && antidote bundle < $PLUGINS_TXT > $PLUGINS_ZSH"
else
	echo "==> Antidote not installed yet; will bootstrap on next zsh launch"
fi

# Tmux plugin manager
TPM=$HOME/.tmux/plugins/tpm
if [[ ! -d $TPM ]]; then
	echo "==> Installing tpm"
	git clone https://github.com/tmux-plugins/tpm "$TPM"
else
	echo "==> Updating tpm"
	git -C "$TPM" pull --ff-only
fi

# NVM: installed lazily by zsh-nvm on first `nvm` invocation.
# If it's already cloned, fast-forward it to the latest tagged release.
NVM_DIR=${NVM_DIR:-$HOME/.nvm}
if [[ -d $NVM_DIR/.git ]]; then
	echo "==> Updating nvm"
	git -C "$NVM_DIR" fetch --tags --quiet origin
	latest=$(git -C "$NVM_DIR" tag -l 'v*' --sort=-v:refname | head -1)
	current=$(git -C "$NVM_DIR" describe --tags --abbrev=0 2>/dev/null || echo "")
	if [[ -n $latest && "$current" != "$latest" ]]; then
		echo "    nvm ${current:-unknown} -> $latest"
		git -C "$NVM_DIR" checkout --quiet "$latest"
	else
		echo "    nvm up to date (${current:-unknown})"
	fi
else
	echo "==> nvm not installed; zsh-nvm will install it on first use"
fi

echo "==> Done"
