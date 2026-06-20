{ config, pkgs, ... }:
{
  programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      sessionVariables = {
          EDITOR = "nvim";
          FLAKE = "$HOME/.dotfiles";
      };
      shellAliases = {
          vim = "nvim";
          vi = "nvim";
          ll = "ls -l";
          ls = "lsd";
          l = "ls -l";
          la = "ls -a";
          lla = "ls -la";
          lt = "ls --tree";
          c = "clear";
          cat = "bat";
          open = "xdg-open";
          lg = "lazygit";
          gl = "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
          ports = "sudo netstat -tulpn | grep LISTEN";
          clean-local-git-branches = "git fetch -p ; git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -d";
          tf = "terraform";
          getip = "curl -4 ifconfig.co";
          update  = "nh os switch ~/.dotfiles";
          upgrade = "nh os switch --update ~/.dotfiles";
          debugk8s = "nix-shell -p kubectl --run \"kubectl run -i --tty --rm debug --image=alpine --restart=Never -- sh\"";
      };
      history = {
          size = 10000;
          path = "${config.xdg.dataHome}/zsh/history";
      };
      profileExtra = ''
        if command -v keychain > /dev/null 2>&1; then eval $(keychain --eval --nogui ~/.ssh/github --quiet); fi
        if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = "1" ]; then
          exec start-hyprland
        fi
      '';
      initContent = ''
        PROMPT="%B%F{red}[%F{yellow}%n%F{green}@%F{blue}%M %F{magenta}%~%F{red}]%f%b$ "
      '';
  };

  programs.fzf = {
      enable = true;
      enableZshIntegration = true;
  };

  programs.atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
          style = "compact";
          inline_height = 20;
          show_preview = true;
      };
  };

  programs.bat = {
      enable = true;
      config = {
          theme = "gruvbox-dark";
          style = "numbers,changes,header";
      };
  };

  programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
  };

  programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
  };
}
