# ==================================================
# Environment / PATH
# Configure environment variables and command search paths.
# ==================================================

# Keep command and completion search paths idempotent when reloading this file.
typeset -U path fpath

# Configure Homebrew-provided completion and tool paths.
if type brew &>/dev/null; then
  brew_prefix="$(brew --prefix)"

  # Make Homebrew-installed Zsh completion functions available.
  FPATH="${brew_prefix}/share/zsh/site-functions:${FPATH}"

  # Add Rustup-managed toolchains installed through Homebrew to PATH.
  export PATH="${brew_prefix}/opt/rustup/bin:${PATH}"
fi

# Add user-installed Go binaries to PATH.
export PATH="${HOME}/go/bin:${PATH}"

# ==================================================
# History
# Configure command history behavior.
# ==================================================

# Store command history in ZDOTDIR when set, otherwise in the home directory.
HISTFILE="${ZDOTDIR:-${HOME}}/.zsh_history"

# Keep up to 10,000 history entries in memory and on disk.
HISTSIZE=10000
SAVEHIST=10000

# Save additional information, such as timestamps, in the history file.
setopt extended_history

# Do not save consecutive duplicate commands.
setopt hist_ignore_dups

# Append history on shell exit so concurrent shells do not overwrite each other.
setopt append_history

# Show timestamps when displaying command history.
alias history='history -i'

# ==================================================
# Shell options
# Configure Zsh's interactive shell behavior.
# ==================================================

# ==================================================
# Aliases
# Define shortcuts for frequently used commands.
# ==================================================

alias ls='ls -G'

# Define enhanced directory-listing aliases when eza is available.
if type eza &>/dev/null; then
  alias ll='eza -la --icons --git --group-directories-first'
  alias lt='eza --tree --icons --level=2'
fi

# ==================================================
# Sheldon / plugins
# Load Zsh plugins and initialize completion in the configured order.
# ==================================================

if type sheldon &>/dev/null; then
  eval "$(sheldon source)"
fi

# ==================================================
# Functions
# Define custom shell functions.
# ==================================================

# ==================================================
# Prompt
# Configure the shell prompt.
# ==================================================

if type starship &>/dev/null; then
  eval "$(starship init zsh)"
fi
