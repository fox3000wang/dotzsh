bindkey -e

autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line

setopt transient_rprompt
