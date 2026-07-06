#!/usr/bin/env bash
OUTPUT_DIR="$HOME/Videos/recordings"
OUTPUT_FILE="$OUTPUT_DIR/recording_$(date +%Y%m%d_%H%M%S).mp4"

if pgrep -x wf-recorder > /dev/null; then
    pkill -SIGINT wf-recorder
else
    mkdir -p "$OUTPUT_DIR"
    wf-recorder -f "$OUTPUT_FILE"
fi
