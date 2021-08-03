export FIRSTRUN=1
export EMOJI_SELECT_MENU="bemenu"
export EMOJI_COPY_TOOL="wl-copy"

if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
  exec sway
fi

