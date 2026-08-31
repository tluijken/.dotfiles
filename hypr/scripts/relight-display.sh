#!/usr/bin/env bash
# Re-enable the internal panel after resume. Across a suspend->resume cycle
# Hyprland/aquamarine re-inits DRM outputs and drops eDP-1 into
# enabled=disabled / dpms=Off at a variable point in the first ~5s, without
# reliably restoring it (black screen). This is a resume artifact, not lid
# handling: a lid close/open with suspend inhibited never disables the panel.
#
# `hyprctl keyword monitor` can't fix it (the lua parser rejects legacy
# keywords) and hl.monitor/hl.keyword aren't reachable via dispatch, so
# `hyprctl reload` (re-runs hyprland.lua, re-applying the monitor line) is the
# lever. Poll the DRM connector's real state and, whenever it is bad, reload
# and force DPMS on. Bounded to ~8s to cover the variable disable timing.
#
# Runs from both hypridle's after_sleep_cmd (fires on every resume) and the
# lid-open switch bind; the lock keeps the two from running concurrently.
lock=/tmp/relight-display.lock
mkdir "$lock" 2>/dev/null || exit 0
trap 'rmdir "$lock"' EXIT

conn=$(ls -d /sys/class/drm/card*-eDP-1 2>/dev/null | head -1)
[ -n "$conn" ] || exit 0

for _ in $(seq 1 40); do
  if [ "$(cat "$conn/enabled" 2>/dev/null)" != enabled ] \
     || [ "$(cat "$conn/dpms" 2>/dev/null)" != On ]; then
    hyprctl reload >/dev/null 2>&1
    hyprctl dispatch 'hl.dsp.dpms("on")' >/dev/null 2>&1
  fi
  sleep 0.2
done
