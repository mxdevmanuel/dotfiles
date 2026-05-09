#!/usr/bin/env bash

TMPDIR="${XDG_RUNTIME_DIR:-/tmp}"
SCREENSHOT="$TMPDIR/screenshot-$(date +%Y%m%d-%H%M%S).png"

hyprshot -m region --silent -o "$TMPDIR" -f "$(basename "$SCREENSHOT")"

[ -f "$SCREENSHOT" ] || exit 0

wl-copy < "$SCREENSHOT"

ACTION=$(notify-send "Screenshot captured" \
    "Copied to clipboard" \
    --icon=camera \
    --expire-time=8000 \
    --action="edit=Edit in Swappy")

if [ "$ACTION" = "edit" ]; then
    swappy -f "$SCREENSHOT"
fi

rm -f "$SCREENSHOT"
