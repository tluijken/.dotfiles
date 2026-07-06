{ ... }:
{
  programs.waybar = {
    enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";
      margin-top = 12;
      margin-left = 16;
      margin-right = 16;

      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [
        "custom/mpris"
        "pulseaudio#microphone"
        "pulseaudio"
        "bluetooth"
        "network"
        "battery"
        "tray"
        "custom/notification"
      ];

      "hyprland/workspaces" = {
        format = "{name}";
        tooltip = false;
        all-outputs = true;
        persistent-workspaces = {
          "*" = [ 1 2 3 4 5 ];
        };
      };

      clock = {
        interval = 60;
        format = "{:%H:%M}";
        format-alt = "{:%A, %d %B %Y}";
        tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
      };

      "pulseaudio#microphone" = {
        format = "{format_source}";
        format-source = "󰍬";
        format-source-muted = "󰍭";
        on-click = "swayosd-client --input-volume mute-toggle";
        tooltip = true;
        tooltip-format = "Mic: {source_desc}  {source_volume}%";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰖁";
        format-icons = {
          headphone = "󰋋";
          headset = "󰋎";
          default = [ "󰕿" "󰖀" "󰕾" ];
        };
        on-click = "pavucontrol";
        on-scroll-up = "swayosd-client --output-volume raise";
        on-scroll-down = "swayosd-client --output-volume lower";
        tooltip = true;
        tooltip-format = "{volume}%  {desc}";
      };

      bluetooth = {
        format = "󰂯";
        format-connected = "󰂱";
        format-disabled = "󰂲";
        tooltip-format = "{controller_alias}  {controller_address}";
        tooltip-format-connected = "{controller_alias}\n\n{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}  {device_address}";
        on-click = "blueman-manager";
      };

      network = {
        format-wifi = "󰖩";
        format-ethernet = "󰛳";
        format-disconnected = "󰖪";
        on-click = "nm-connection-editor";
        tooltip-format-wifi = "{essid}  {signalStrength}%\n{ipaddr}/{cidr}";
        tooltip-format-ethernet = "{ifname}  {ipaddr}/{cidr}";
        tooltip-format-disconnected = "Disconnected";
      };

      battery = {
        format = "{icon}";
        format-charging = "󰚥 {capacity}%";
        format-plugged = "󰚥";
        format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        states = {
          warning = 30;
          critical = 15;
        };
        tooltip = true;
        tooltip-format = "{capacity}%  {time}";
      };

      tray = {
        icon-size = 16;
        spacing = 8;
      };

      "custom/mpris" = {
        return-type = "json";
        exec = ''playerctl -a metadata --format '{"text": "{{artist}} — {{title}}", "tooltip": "{{playerName}}: {{artist}} — {{title}}", "alt": "{{status}}"}' -F 2>/dev/null'';
        format = "  {}";
        on-click = "playerctl play-pause";
        on-scroll-up = "playerctl next";
        on-scroll-down = "playerctl previous";
        escape = true;
        max-length = 35;
      };

      "custom/notification" = {
        tooltip = false;
        format = "{icon}";
        format-icons = {
          notification = "󰂚";
          none = "󰂜";
          dnd-notification = "󰂛";
          dnd-none = "󰂛";
        };
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
        escape = true;
      };
    };

    style = builtins.readFile ../../waybar/style.css;
  };
}
