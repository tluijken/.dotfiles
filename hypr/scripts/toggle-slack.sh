#!/bin/sh
if ! pgrep slack >/dev/null; then
    slack &
fi
hyprctl dispatch "hl.dsp.workspace.toggle_special('slack')"
