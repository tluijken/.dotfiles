# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

export EDITOR='nvim'
export VISUAL='nvim'
. "$HOME/.cargo/env"
export _JAVA_AWT_WM_NONREPARENTING=1
export EDITOR=nvim

complete -C /usr/bin/terraform terraform

if [[ -f /run/.containerenv && -f /run/.toolboxenv ]]; then
  # Display diamond when in a toolbox: ⬢ user@host.
  # typeset -g DRACULA_ARROW_ICON="⬢"
  # When in a toolbox, forward aliasses to the host machine.
  alias docker="flatpak-spawn --host podman"
  alias docker-compose="flatpak-spawn --host podman-compose"
  alias jb="nohup /opt/idea-IU-233.13135.103/bin/idea.sh  > /dev/null 2>&1 &"
  alias rider="nohup /opt/JetBrains\ Rider-2023.3.2/bin/rider.sh > /dev/null 2>&1 &"
#  alias vim="flatpak-spawn --host nvim"
 # alias nvim="flatpak-spawn --host nvim"
 # alias vi="flatpak-spawn --host nvim"
else
  # When not in a toolbox, use native aliasses.
  alias docker="podman"
  alias docker-compose="podman-compose"
fi
