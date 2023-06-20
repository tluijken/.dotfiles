# -*- sh -*- vim:set ft=sh ai et sw=4 sts=4:
# It might be bash like, but I can't have my co-workers knowing I use zsh
# Based of Luke Smith's prompt
PROMPT='%{$fg[red][$fg[yellow]%}%n$fg[green]@$fg[blue]%m %{$fg_bold[magenta]%}%2~% $fg[red]]$reset_color%}%(!.#.$) '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="›%{$reset_color%}"
