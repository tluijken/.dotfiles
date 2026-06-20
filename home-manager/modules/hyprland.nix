{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
   
    # plugins = [
    #   pkgs.hyprlandPlugins.hyprscrolling
    # ];
  
    configType = "lua";

    extraConfig = ''
      dofile(os.getenv("HOME") .. "/.dotfiles/hypr/hyprland.lua")
    '';
  };
  
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        before_sleep_cmd = "pidof hyprlock || hyprlock";
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
  
          # Catppuccin Mocha
          font_color = "rgb(205, 214, 244)";   # text
          inner_color = "rgb(49, 50, 68)";     # surface0
          outer_color = "rgb(203, 166, 247)";  # mauve
          check_color = "rgb(166, 227, 161)";  # green
          fail_color = "rgb(243, 139, 168)";   # red
          fail_text = "wrong password";

          outline_thickness = 4;
          placeholder_text = "<span foreground=\"##a6adc8\">🔒 password</span>";
          shadow_passes = 3;
          shadow_color = "rgb(17, 17, 27)";    # crust
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
          color = "rgba(205, 214, 244, 0.9)";  # text
          position = "0, 200";
          valign = "center";
          halign = "center";
          shadow_passes = 3;
          shadow_color = "rgb(17, 17, 27)";
          shadow_boost = 1.2;
        }

        # Date
        {
          monitor = "";
          text = ''cmd[update:60000] date +"%-A, %-d %B %Y"'';
          font_size = 24;
          font_family = "JetBrains Mono";
          color = "rgba(166, 173, 200, 0.9)";  # subtext0
          position = "0, 100";
          valign = "center";
          halign = "center";
          shadow_passes = 3;
          shadow_color = "rgb(17, 17, 27)";
          shadow_boost = 1.2;
        }

        # Username
        {
          monitor = "";
          text = "$USER";
          font_size = 18;
          font_family = "JetBrains Mono";
          color = "rgba(203, 166, 247, 0.9)";  # mauve
          position = "0, -50";
          valign = "center";
          halign = "center";
          shadow_passes = 2;
          shadow_color = "rgb(17, 17, 27)";
        }
      ];
    };
  };
}
