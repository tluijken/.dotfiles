{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
   
    plugins = [
      pkgs.hyprlandPlugins.hyprscrolling
    ];
  
    extraConfig = ''
      source = ${config.home.homeDirectory}/.dotfiles/hypr/hyprland.conf
    '';
  };
  
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock";
      };
  
      listener = [
        {
          timeout = 300;  # 5 min
          on-timeout = "pidof hyprlock || hyprlock";
        }
        {
          timeout = 600;  # 10 min
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;  # 30 min
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
  
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = false;
        grace = 5;
        hide_cursor = true;
        no_fade_in = false;
      };
  
      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
          brightness = 0.6;  # darken slightly so text pops
        }
      ];
  
      input-field = [
        {
          size = "250, 55";
          position = "0, -100";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
  
          # Gruvbox dark colors
          font_color = "rgb(235, 219, 178)";   # fg1 - warm cream
          inner_color = "rgb(60, 56, 54)";     # bg2 - dark warm grey
          outer_color = "rgb(214, 93, 14)";    # orange accent
          check_color = "rgb(184, 187, 38)";   # yellow-green
          fail_color = "rgb(204, 36, 29)";     # bright red
          fail_text = "wrong password";
  
          outline_thickness = 4;
          placeholder_text = "<span foreground=\"##a89984\">🔒 password</span>";
          shadow_passes = 3;
          shadow_color = "rgb(29, 32, 33)";    # bg hard shadow
          shadow_boost = 1.2;
        }
      ];
  
      label = [
        # Clock
        {
          monitor = "";
          text = "$TIME";
          font_size = 96;
          font_family = "JetBrains Mono Bold";
          color = "rgba(235, 219, 178, 0.9)";  # fg1 - warm cream
          position = "0, 200";
          valign = "center";
          halign = "center";
          shadow_passes = 3;
          shadow_color = "rgb(29, 32, 33)";
          shadow_boost = 1.2;
        }
  
        # Date
        {
          monitor = "";
          text = ''cmd[update:60000] date +"%-A, %-d %B %Y"'';
          font_size = 24;
          font_family = "JetBrains Mono";
          color = "rgba(168, 153, 132, 0.9)";  # fg4 - muted warm grey
          position = "0, 100";
          valign = "center";
          halign = "center";
          shadow_passes = 3;
          shadow_color = "rgb(29, 32, 33)";
          shadow_boost = 1.2;
        }
  
        # Username
        {
          monitor = "";
          text = "$USER";
          font_size = 18;
          font_family = "JetBrains Mono";
          color = "rgba(214, 93, 14, 0.9)";    # orange accent
          position = "0, -50";
          valign = "center";
          halign = "center";
          shadow_passes = 2;
          shadow_color = "rgb(29, 32, 33)";
        }
      ];
    };
  };
}
