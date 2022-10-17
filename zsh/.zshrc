eval "$(starship init zsh)"

autoload -Uz compinit
compinit
_comp_options+=(globdots)

export VISUAL=nvim
export EDITOR="$VISUAL"

Development="/mnt/c/Users/davep/Development"
