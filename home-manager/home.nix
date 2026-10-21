{ config, pkgs, lib, dotfilesPath, zen-browser, ... }:
let
  themeName = lib.removeSuffix ".yaml" (builtins.baseNameOf config.stylix.base16Scheme);
in
{

  imports = [
    ./modules/hyprland.nix
    ./modules/thunderbird.nix
    ./modules/aerc.nix
    ./modules/protonmail.nix
    ./modules/shell.nix
    ./modules/git.nix
    ./modules/claude-code.nix
    ./modules/stylix.nix
    ./modules/foot.nix
    ./modules/kitty.nix
    ./modules/audio.nix
    ./modules/waybar.nix
    ./modules/wofi.nix
    ./modules/swaync.nix
    ./modules/wlogout.nix
    ./modules/ranger.nix
    ./modules/google-drive.nix
    ./modules/cloudbox.nix
    ./modules/flatpak.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "thomas";
  home.homeDirectory = "/home/thomas";

  # The stylix home module sets nixpkgs.overlays, which home-manager ignores under
  # useGlobalPkgs but still warns about. Force it back to null (the unset value the
  # warning checks for); the overlays are already applied at the system level.
  nixpkgs.overlays = lib.mkForce null;

  fonts.fontconfig.enable = true;


  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
     slack
     sops
     age
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
     swayosd
     networkmanagerapplet
     playerctl
     lsd
     lazygit
     fd
     nh
     proton-vpn
     pear-desktop
     rocketchat-desktop
     jetbrains.datagrip
     crosspipe
     reaper
     obs-studio
     tuxguitar
     nerd-fonts.jetbrains-mono
     inter
     noto-fonts
     wf-recorder
     zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    ".config/current-theme".text             = themeName;
    ".config/nvim".source                    = "${dotfilesPath}/nvim/.config/nvim";
    # waybar, wofi, swaync, wlogout are now managed by their home-manager modules
    # (see ./modules/{waybar,wofi,swaync,wlogout}.nix)
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/msteams" = "teams-for-linux.desktop";
      "text/html" = "zen-beta.desktop";

      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/ftp" = "zen-beta.desktop";
      "x-scheme-handler/about" = "zen-beta.desktop";
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
    WALLPAPER_THEME = themeName; # kept for shell convenience
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
