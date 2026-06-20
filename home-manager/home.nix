{ config, pkgs, lib, dotfilesPath, ... }:
let
  # Add the tool you want to use here
  myMergeTool = pkgs.kdiff3;
in
{

  imports = [
    ./modules/hyprland.nix
    ./modules/shell.nix
    ./modules/git.nix
    ./modules/stylix.nix
    ./modules/foot.nix
    ./modules/audio.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "thomas";
  home.homeDirectory = "/home/thomas";

  # Stylix's homeModule adds overlays internally, but nixosModules.stylix already
  # applies them at the system level. Clear them here to avoid the useGlobalPkgs warning.
  nixpkgs.overlays = lib.mkForce [];

  fonts.fontconfig.enable = true;


  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Disable version check...
  home.enableNixpkgsReleaseCheck = false;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
     slack
     thunderbird
     lua-language-server
     ripgrep
     wdisplays
     obsidian
     nodejs
     pkg-config
     openssl
     nautilus
     insomnia
     proton-pass
     mpv
     awww
     swaynotificationcenter
     swayosd
     networkmanagerapplet
     playerctl
     lsd
     myMergeTool
     lazygit
     fd
     nh
     proton-vpn
     pear-desktop
     wofi
     waybar
     rocketchat-desktop
     jetbrains.datagrip
     crosspipe 
     reaper
     obs-studio
     tuxguitar
     nerd-fonts.jetbrains-mono
     wlogout
     grim
     slurp
  ];


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    ".config/current-theme".text             = lib.removeSuffix ".yaml" (builtins.baseNameOf config.stylix.base16Scheme);
    ".config/nvim".source                    = "${dotfilesPath}/nvim/.config/nvim";
    ".config/swaync/config.json".source      = "${dotfilesPath}/swaync/config.json";
    ".config/swaync/style.css".source        = "${dotfilesPath}/swaync/style.css";
    ".config/wlogout/layout".source          = "${dotfilesPath}/wlogout/layout";
    ".config/wlogout/style.css".source       = "${dotfilesPath}/wlogout/style.css";
    ".config/waybar/config.jsonc".source     = "${dotfilesPath}/waybar/config.jsonc";
    ".config/waybar/configTaskBar.jsonc".source = "${dotfilesPath}/waybar/configTaskBar.jsonc";
    ".config/waybar/styleTaskBar.css".source = "${dotfilesPath}/waybar/styleTaskBar.css";
    ".config/waybar/mediaplayer.py".source   = "${dotfilesPath}/waybar/mediaplayer.py";
    ".config/waybar/updates.sh".source       = "${dotfilesPath}/waybar/updates.sh";
    ".config/wofi".source                    = "${dotfilesPath}/wofi";
  };

  programs.waybar = {
    enable = true;
    style = builtins.readFile "${dotfilesPath}/waybar/style.css";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];
    config = {
      common = {
        default = [ "gtk" ];
        # This ensures that "Open URI" requests (links) 
        # are handled by the portal rather than a raw fork/exec
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
      };
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/msteams" = "teams-for-linux.desktop";
      "text/html" = "app.zen_browser.zen.desktop";

      "x-scheme-handler/http" = "app.zen_browser.zen.desktop";
      "x-scheme-handler/https" = "app.zen_browser.zen.desktop";
      "x-scheme-handler/ftp" = "app.zen_browser.zen.desktop";
      "x-scheme-handler/about" = "app.zen_browser.zen.desktop";
    };
  };


  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/thomas/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    WALLPAPER_THEME = lib.removeSuffix ".yaml" (builtins.baseNameOf config.stylix.base16Scheme); # kept for shell convenience
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
