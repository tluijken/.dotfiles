#!/usr/bin/env bash
# Wallpapers are stored directly in this repo under per-theme subdirectories.
# To add more wallpapers: drop image files into the relevant theme folder and commit.
#
# Theme folders match stylix base16 scheme names, e.g.:
#   catppuccin-mocha, gruvbox-dark, nord, rose-pine, dracula, ...
#
# The active theme is read from ~/.config/current-theme (written by home-manager).

echo "Wallpaper folders:"
for dir in "$(dirname "$0")"/*/; do
    count=$(find "$dir" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) | wc -l)
    echo "  $(basename "$dir"): $count images"
done
