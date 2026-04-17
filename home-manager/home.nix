{ config, pkgs, dotfilesPath, ... }:
let
  # Add the tool you want to use here
  myMergeTool = pkgs.kdiff3;
in
{

  imports = [
    ./modules/hyprland.nix
    ./modules/shell.nix
    ./modules/git.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "slack"
      "obsidian"
      "datagrip"
      "reaper"
    ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "thomas";
  home.homeDirectory = "/home/thomas";

  fonts.fontconfig.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors; # Or another cursor theme package
    name = "Bibata-Modern-Ice";
    size = 22; # Adjust this value
  };


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
     dmenu
     proton-pass
     mpv
     swaybg
     lsd
     feh
     direnv
     myMergeTool
     firefox
     protonvpn-gui
     youtube-music
     wofi
     waybar
     rocketchat-desktop
     jetbrains.datagrip
     helvum
     reaper
     obs-studio
     tuxguitar
     nerd-fonts.jetbrains-mono
  ];


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    ".config/nvim".source    = "${dotfilesPath}/nvim/.config/nvim";
    ".config/mako".source    = "${dotfilesPath}/mako";
    ".config/neofetch".source = "${dotfilesPath}/neofetch";
    ".config/sway".source    = "${dotfilesPath}/sway";
    ".config/waybar".source  = "${dotfilesPath}/waybar";
    ".config/wofi".source    = "${dotfilesPath}/wofi";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
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
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
