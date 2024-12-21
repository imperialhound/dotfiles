source $ZSH/oh-my-zsh.sh

[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

eval "$(starship init zsh)"

eval "$(zoxide init zsh)"

eval "$(fuzzy-clone init zsh)"
eval $(thefuck --alias)


source /$HOME/.antidote/antidote.zsh
source /opt/homebrew/opt/autoenv/activate.sh
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt
