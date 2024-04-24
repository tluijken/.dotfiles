export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"
# export TERM="xterm-256color"

# Enable colors and change prompt:
autoload -U colors && colors

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
if [[ -f /run/.containerenv && -f /run/.toolboxenv ]]; then
  # Display diamond when in a toolbox: ⬢ user@host.
  # typeset -g DRACULA_ARROW_ICON="⬢"
  # When in a toolbox, forward aliasses to the host machine.
  alias docker="flatpak-spawn --host podman"
  #alias docker-compose="flatpak-spawn --host podman-compose"
  alias jb="nohup /opt/idea-IU-233.13135.103/bin/idea.sh  > /dev/null 2>&1 &"
  alias rider="nohup /opt/JetBrains\ Rider-2023.3.2/bin/rider.sh > /dev/null 2>&1 &"
#  alias vim="flatpak-spawn --host nvim"
 # alias nvim="flatpak-spawn --host nvim"
 # alias vi="flatpak-spawn --host nvim"
else
  # When not in a toolbox, use native aliasses.
  alias docker="podman"
  # alias docker-compose="podman-compose"
fi
alias vim="nvim"
alias vi="nvim"
alias oldvim="vim"
# If you come from bash you might have to change your $PATH.
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="/home/thomas/.oh-my-zsh"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git
	  zsh-syntax-highlighting
	  zsh-autosuggestions
	  dnf
	  docker
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

export _JAVA_AWT_WM_NONREPARENTING=1
alias change-cluster=~/.config/kube-switch
alias c="clear"
#alias cat="bat"
#alias ls="lsd -l"
alias open="xdg-open"
alias :q="exit"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias ports="sudo netstat -tulpn | grep LISTEN"
alias dap="dotnet new $1 -n $2 -o $2"
alias clean-local-git-branches="git fetch -p ; git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -d"
alias tf="terraform"
alias getip="curl -4 ifconfig.co"
alias j="autojump"
# alias dive=" docker run --rm -it \
#     -v /var/run/docker.sock:/var/run/docker.sock \
#     wagoodman/dive:latest $1"

# alias k9s="docker run --rm -it -v ~/.kube/config:/root/.kube/config -v ~/.config/k9s:/root/.config/k9s k9s-docker:latest"
alias debug-kubectl="kubectl run -i --tty --rm debug --image=busybox --restart=Never -- sh"
alias update="sudo nixos-rebuild switch -I nixos-config=$HOME/.dotfiles/nixos/configuration.nix"

# folder shortcuts
alias iv="cd ~/projects/unicon/source/ivenza"
alias un="cd ~/projects/unicon"
alias ivd="cd ~/projects/unicon/source/ivenza-deployment"
alias stellar= "cd ~/projects/baseflow/stellar-rust-sdk"
alias baseflow="cd ~/projects/baseflow"
alias vsm="cd ~/projects/voortman"
alias pds="cd ~/projects/voortman/source/plate-sorter-management-system"


ffile() {find . -path ./.git -prune -o -iname "*$*"; }
mkd() { mkdir -p "$1" ^ cd "$1"}



# Use lf to switch directories and bind it to ctrl-o
rangercd () {
    tmp="$(mktemp)"
    ranger --choosedir="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ --datadir "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"                                               
    fi
}

bindkey -s '^o' 'rangercd\n'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH=${HOME}/.local/bin:"$PATH"
export PATH=${HOME}/gn:"$PATH"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform
