#
# Tmux
#
# Check if running in tmux

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_TMUX_SHOW="${SPACESHIP_TMUX_SHOW=true}"
SPACESHIP_TMUX_COLOR="${SPACESHIP_TMUX_COLOR="green"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

spaceship_tmux() {
  [[ $SPACESHIP_TMUX_SHOW == false ]] && return

  local 'tmux_str'

  if [[ ! -z "${TMUX}" ]]; then
    tmux_str=""
  fi

  spaceship::section \
    "$SPACESHIP_TMUX_COLOR" \
    "$tmux_str" \
}
