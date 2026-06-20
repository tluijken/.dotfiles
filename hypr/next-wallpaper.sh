#!/usr/bin/env bash

WALLPAPER_BASE="$HOME/.dotfiles/wallpaper"
THEME=$(cat "$HOME/.config/current-theme" 2>/dev/null || echo "gruvbox-dark")
WALLPAPER_DIR="$WALLPAPER_BASE/$THEME"

# Fallback to gruvbox-dark if theme folder is missing or empty
if [ ! -d "$WALLPAPER_DIR" ] || [ -z "$(find "$WALLPAPER_DIR" -maxdepth 3 -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) -print -quit 2>/dev/null)" ]; then
    WALLPAPER_DIR="$WALLPAPER_BASE/gruvbox-dark"
fi

TRANSITIONS=(
    "grow --transition-pos top-left"
    "grow --transition-pos top-right"
    "grow --transition-pos bottom-left"
    "grow --transition-pos bottom-right"
    "wipe"
    "wave"
    "fade"
)

WALL=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) | shuf -n1)
TRANSITION=${TRANSITIONS[$RANDOM % ${#TRANSITIONS[@]}]}

awww img "$WALL" \
    --transition-type $TRANSITION \
    --transition-duration 2 \
    --transition-fps 60
