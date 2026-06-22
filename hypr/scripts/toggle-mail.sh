#!/bin/sh
if ! pgrep thunderbird >/dev/null; then
    thunderbird &
    exit 0
fi

hyprctl dispatch "hl.dsp.workspace.toggle_special('mail')"
