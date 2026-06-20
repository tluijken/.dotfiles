{ ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font Mono:size=10";
        dpi-aware = "yes";
        pad = "20x20";
      };
      url = {
        # ''${ is nix's escape for a literal ${ in ''...'' strings
        launch = ''xdg-open ''${url}'';
      };
      colors = {
        # Stylix sets the palette; keep transparency
        alpha = "0.95";
      };
    };
  };
}
