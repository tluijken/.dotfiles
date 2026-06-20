#!/usr/bin/env bash

awww-daemon &
sleep 0.5

while true; do
    bash "$HOME/.dotfiles/hypr/next-wallpaper.sh"
    sleep 600
done
