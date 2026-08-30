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
  path=("${brew_prefix}/opt/rustup/bin" "${path[@]}")
fi

# Add user-installed Go binaries to PATH.
path=("${HOME}/go/bin" "${path[@]}")

# Use Neovim as the default terminal editor when available.
if type nvim &>/dev/null; then
  export EDITOR='nvim'
  export VISUAL="${EDITOR}"
fi

# ==================================================
# History
# Configure command history behavior.
# ==================================================

# Store command history in ZDOTDIR when set, otherwise in the home directory.
HISTFILE="${ZDOTDIR:-${HOME}}/.zsh_history"

# Keep extra in-memory history so duplicate entries expire before unique ones.
HISTSIZE=20000
SAVEHIST=10000

# Save additional information, such as timestamps, in the history file.
setopt extended_history

# Do not save consecutive duplicate commands.
setopt hist_ignore_dups

# Remove duplicate history entries before unique entries when trimming.
setopt hist_expire_dups_first

# Save history after each command finishes while retaining command durations.
setopt inc_append_history_time

# Hide duplicate entries while searching command history.
setopt hist_find_no_dups

# Remove unnecessary whitespace from saved commands.
setopt hist_reduce_blanks

# Omit older duplicate commands when rewriting the history file.
setopt hist_save_no_dups

# Show timestamps when displaying command history.
alias history='history -i'

# ==================================================
# Shell options
# Configure Zsh's interactive shell behavior.
# ==================================================

# Allow comments in commands entered at the interactive prompt.
setopt interactive_comments

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

# Group completion candidates by their descriptions in fzf-tab.
zstyle ':completion:*:descriptions' format '[%d]'

# Let fzf-tab display ambiguous completion candidates.
zstyle ':completion:*' menu no

# Preview directory contents when completing cd arguments.
if type eza &>/dev/null; then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
fi

if type sheldon &>/dev/null; then
  eval "$(sheldon source)"
fi

# ==================================================
# Functions
# Define custom shell functions.
# ==================================================

# Edit the current command line in the configured external editor.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# ==================================================
# Prompt
# Configure the shell prompt.
# ==================================================

if type starship &>/dev/null; then
  eval "$(starship init zsh)"
fi
