{ ... }:
{
  programs.wofi = {
    enable = true;

    settings = {
      show = "drun";
      width = 600;
      height = 350;
      always_parse_args = true;
      show_all = true;
      print_command = true;
      layer = "overlay";
      insensitive = true;
      prompt = "";
    };

    style = builtins.readFile ../../wofi/style.css;
  };
}
