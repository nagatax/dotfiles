##################################################
# Environment / PATH
# Environment variables and command search paths.
##################################################

# Homebrew
# Add Homebrew's Zsh completions to the function search path.
if type brew &>/dev/null
then
  BREW_PREFIX="$(brew --prefix)"

  # Make Homebrew-installed Zsh completion functions available.
  FPATH="${BREW_PREFIX}/share/zsh/site-functions:${FPATH}"
fi

##################################################
# History
# Configure command history behavior.
##################################################

# History file
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history

# Maximum number of history entries kept in memory and saved to disk.
HISTSIZE=10000
SAVEHIST=10000

# Save additional information, such as timestamps, in the history file.
setopt extended_history

# Do not save consecutive duplicate commands.
setopt hist_ignore_dups

# Show timestamps when displaying command history.
alias history='history -i'

##################################################
# Shell options
# Configure Zsh's interactive shell behavior.
##################################################

##################################################
# Aliases
# Define shortcuts for frequently used commands.
##################################################

alias ls='ls -G'

##################################################
# Sheldon / plugins
# Load Zsh plugins managed by Sheldon.
##################################################

if type sheldon &>/dev/null
then
  eval "$(sheldon source)"
fi

##################################################
# Completion
# Enable Zsh's command and argument completion.
##################################################

autoload -Uz compinit
compinit

##################################################
# Functions
# Define custom shell functions.
##################################################

##################################################
# Prompt
# Configure the shell prompt.
##################################################

if type starship &>/dev/null
then
  eval "$(starship init zsh)"
fi
