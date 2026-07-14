{ pkgs, dotfilesPath, ... }:
{
  home.packages = with pkgs; [ chafa imagemagick imv ];

  home.file.".config/ranger/scope.sh" = {
    source = "${dotfilesPath}/ranger/scope.sh";
    executable = true;
  };

  programs.ranger.rifle = [
    { condition = "mime ^image, has imv, X, flag f"; command = ''imv -- "$@"''; }
    { condition = "mime ^image, X, flag f";          command = ''xdg-open -- "$@"''; }
    { condition = "mime ^text, has nvim, flag f";    command = ''nvim -- "$@"''; }
    { condition = "ext xml|json|csv, has nvim, flag f"; command = ''nvim -- "$@"''; }
  ];

  programs.ranger = {
    enable = true;
    mappings = {
      gd = "shell git rm %f";
    };
    extraConfig = ''
      set preview_images true
      set preview_images_method sixel
      set use_preview_script true
    '';
  };
}
