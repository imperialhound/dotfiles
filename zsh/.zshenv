# zsh location
export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="robbyrussell"

# Set Kubeconfig path
export KUBECONFIG=$HOME/.kube/config

# age
# SOPS AGE key encryption
export SOPS_AGE_KEY_FILE=$HOME/.config/sops/age/key.txt
export SOPS_AGE_RECIPIENTS=""

# K9s Path
export K9S_CONFIG_DIR=$HOME/.config/k9s 

# Set Editor
export EDITOR=nvim

# fuzzy clone
export FUZZY_CLONE_ROOT=$HOME/src
export CLONE_TO_PATH_DIR=$HOME/src

# All the paths
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$SCRIPTS/bin
export PATH=$HOME/.joplin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/.local/bin
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Add Secrets
source $HOME/.secrets/secretkeys

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

