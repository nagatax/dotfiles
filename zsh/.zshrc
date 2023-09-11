# Configuring Rust
. "$HOME/.cargo/env"

# Configuring Sheldon
eval "$(sheldon source)"

# Configuring Completions
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

# Configuring zsh history
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt extended_history
alias history="history -i"