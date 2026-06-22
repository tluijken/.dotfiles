{ pkgs, dotfilesPath, ... }:
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    image = "${dotfilesPath}/wallpaper/catppuccin-mocha/wallhaven-mlgqv8.png";

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 22;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      sizes = {
        terminal = 10;
        applications = 12;
      };
    };

    targets = {
      # Keep manual configs for these
      waybar.enable = true;
      neovim.enable = false;
      hyprland.enable = false;
      hyprlock.enable = false;
    };
  };
}
