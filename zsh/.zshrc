eval "$(starship init zsh)"

autoload -Uz compinit
compinit
_comp_options+=(globdots)

export VISUAL=nvim
export EDITOR="$VISUAL"
