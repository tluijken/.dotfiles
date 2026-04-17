{ config, pkgs, ... }:
{
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
          clean-local-git-branches = "git fetch -p ; git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -d";
          tf = "terraform";
          getip = "curl -4 ifconfig.co";
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
}
