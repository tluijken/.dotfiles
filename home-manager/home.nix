{ config, pkgs, ... }:
let
  # Add the tool you want to use here
  myMergeTool = pkgs.kdiff3;
in
{

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "slack"
      "obsidian"
      "datagrip"
    ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "thomas";
  home.homeDirectory = "/home/thomas";

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

  programs.git = {
    enable = true;
    # Custom git configuration
    settings = {
        user = {
            name = "Thomas Luijken";
            email = "thomas@luijken.dev";
        };
        # core.editor = "nvim";
        # merge.tool = {
        #     kdiff3 = {
        #         cmd = "${myMergeTool}/bin/kdiff3 --auto --L1 $LOCAL --L2 $BASE --L3 $REMOTE -o $MERGED";
        #         trustExitCode = true;
        #     };
        # };
    };
  };


  programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      sessionVariables = {
          EDITOR = "nvim";
      };
      shellAliases = {
          vim = "nvim";
          vi = "nvim";
          ll = "ls -l";
          ls = "lsd";
          l="ls -l";
          la="ls -a";
          lla="ls -la";
          lt="ls --tree";
          update = "sudo nixos-rebuild switch";
          c = "clear";
          open = "xdg-open";
          gl = "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
          ports = "sudo netstat -tulpn | grep LISTEN";
          dap = "dotnet new $1 -n $2 -o $2";
          clean-local-git-branches = "git fetch -p ; git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -d";
          tf = "terraform";
          getip = "curl -4 ifconfig.co";
          iv = "cd ~/projects/unicon/source/ivenza";
          un = "cd ~/projects/unicon";
          ivd = "cd ~/projects/unicon/source/ivenza-deployment";
          stellar = "cd ~/projects/baseflow/stellar-rust-sdk";
          baseflow = "cd ~/projects/baseflow";
          vsm = "cd ~/projects/voortman";
          pds = "cd ~/projects/voortman/source/plate-sorter-management-system";
          updateNix = "sudo nixos-rebuild switch";
          updateHome = "sudo -i nix-channel --update && home-manager switch";
          debugk8s = "nix-shell -p kubectl --run \"kubectl run -i --tty --rm debug --image=alpine --restart=Never -- sh\"";
      };
      history = {
          size = 10000;
          path = "${config.xdg.dataHome}/zsh/history";
      };
      initContent = ''
            PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
            if command -v keychain > /dev/null 2>&1; then eval $(keychain --eval --nogui ~/.ssh/github.com --quiet); fi
          '';
      oh-my-zsh = {
          enable = true;
          plugins = [ 
              "git" 
              "z"
              "docker"
              "direnv"
          ];
          theme = "robbyrussell";
      };
  };
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
     slack
     thunderbird
     lua-language-server
     ripgrep
     wdisplays
     obsidian
     swaylock
     nodejs
     pkg-config
     openssl
     nautilus
     insomnia
     dmenu
     proton-pass
     kanshi
     workstyle
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


    # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    ".config/nvim".source = ~/.dotfiles/nvim/.config/nvim;
    ".config/mako".source = ~/.dotfiles/mako;
    # ".zshrc".source = ~/.dotfiles/zsh/.zshrc;
    ".local/share/fonts".source = ~/.dotfiles/fonts;
    # ".screenrc".source = dotfiles/screenrc;

    ".config/kanshi".source = ~/.dotfiles/kanshi;
    ".config/workstyle".source = ~/.dotfiles/workstyle;
    ".config/neofetch".source = ~/.dotfiles/neofetch;
    ".config/sway".source = ~/.dotfiles/sway;
    ".config/hypr".source = ~/.dotfiles/hypr;
    ".config/waybar".source = ~/.dotfiles/waybar;
    ".config/wofi".source = ~/.dotfiles/wofi;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
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
      # Add other URL schemes if needed, like mailto, etc.
      # "x-scheme-handler/mailto" = "com.zen.ZenBrowser.desktop";
      # "x-scheme-handler/gemini" = "com.zen.ZenBrowser.desktop";
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
