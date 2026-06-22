{ ... }:
{
  programs.wlogout = {
    enable = true;

    layout = [
      {
        label = "lock";
        action = "loginctl lock-session";
        text = "󰌾";
        keybind = "l";
      }
      {
        label = "logout";
        action = "loginctl terminate-user $USER";
        text = "󰍃";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "󰤄";
        keybind = "u";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "󰐥";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "󰑓";
        keybind = "r";
      }
    ];

    style = builtins.readFile ../../wlogout/style.css;
  };
}
