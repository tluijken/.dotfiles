#!/bin/sh
if ! pgrep slack >/dev/null; then
    slack &
    exit 0
fi

hyprctl dispatch "hl.dsp.workspace.toggle_special('slack')"
