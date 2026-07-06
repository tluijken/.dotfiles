#!/bin/sh
if ! pgrep thunderbird >/dev/null; then
    thunderbird &
fi
hyprctl dispatch "hl.dsp.workspace.toggle_special('mail')"
