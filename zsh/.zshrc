# Configuring Rust
. "$HOME/.cargo/env"

# Configuring Sheldon
eval "$(sheldon source)"

# Configuring Completions
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit