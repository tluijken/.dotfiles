hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("bash ~/.dotfiles/hypr/wallpaper.sh")
end)

hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')
hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3"')
