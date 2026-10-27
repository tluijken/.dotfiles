hl.on("hyprland.start", function()
    -- waybar and swaync run as systemd user services (programs.waybar.systemd, services.swaync)
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("bash ~/.dotfiles/hypr/wallpaper.sh")
end)

hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')
hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3"')
