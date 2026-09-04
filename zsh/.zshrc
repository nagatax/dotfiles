# ==================================================
# Ghostty shell integration
# Load Ghostty features in shells started by tmux, Herdr, or another Zsh.
# ==================================================

if [[ -n "${GHOSTTY_RESOURCES_DIR}" ]]; then
  source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi

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
  # Create the standard state directory before Neovim selects its log file.
  nvim_state_dir="${XDG_STATE_HOME:-${HOME}/.local/state}/nvim"
  mkdir -p "${nvim_state_dir}"
  export NVIM_LOG_FILE="${nvim_state_dir}/nvim.log"
  unset nvim_state_dir

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

# Exclude commands deliberately prefixed with a space from history.
setopt hist_ignore_space

# Remove duplicate history entries before unique entries when trimming.
setopt hist_expire_dups_first

# Save history after each command finishes while retaining command durations.
setopt inc_append_history_time

# Use the operating system's file lock when writing shared history.
setopt hist_fcntl_lock

# Hide duplicate entries while searching command history.
setopt hist_find_no_dups

# Remove unnecessary whitespace from saved commands.
setopt hist_reduce_blanks

# Omit older duplicate commands when rewriting the history file.
setopt hist_save_no_dups

# Do not save history-listing commands in the history itself.
setopt hist_no_store

# Review expanded history commands before executing them.
setopt hist_verify

# Show timestamps when displaying command history.
alias history='history -i'

# ==================================================
# Shell options
# Configure Zsh's interactive shell behavior.
# ==================================================

# Allow comments in commands entered at the interactive prompt.
setopt interactive_comments

# Wait before expanding a wildcard that would remove every file in a directory.
setopt rm_star_wait

# Complete around the cursor instead of moving it to the end of the word.
setopt complete_in_word

# Keep ZLE errors and exhausted history navigation silent.
setopt no_beep

# Keep a quiet, duplicate-free history of visited directories.
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent
setopt pushd_minus

# Refuse accidental overwrites while allowing append redirection to create files.
setopt no_clobber
setopt append_create

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

# Retry completion without letter-case distinctions when exact matching fails.
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# Preserve Git's branch ordering when completing checkout targets.
zstyle ':completion:*:git-checkout:*' sort false

# Group completion candidates by their descriptions in fzf-tab.
zstyle ':completion:*:descriptions' format '[%d]'

# Separate completion candidates into groups based on their tags.
zstyle ':completion:*' group-name ''

# Let fzf-tab display ambiguous completion candidates.
zstyle ':completion:*' menu no

# Match standalone fzf and fzf-tab to Catppuccin Frappe.
typeset -a fzf_catppuccin_frappe=(
  '--border=rounded'
  '--color=bg+:#414559,bg:#303446,spinner:#F2D5CF,hl:#E78284'
  '--color=fg:#C6D0F5,header:#E78284,info:#CA9EE6,pointer:#F2D5CF'
  '--color=marker:#BABBF1,fg+:#C6D0F5,prompt:#CA9EE6,hl+:#E78284'
  '--color=selected-bg:#51576D'
  '--color=border:#737994,label:#C6D0F5'
)
export FZF_DEFAULT_OPTS="${(j: :)fzf_catppuccin_frappe}"
zstyle ':fzf-tab:*' fzf-flags "${fzf_catppuccin_frappe[@]}"
unset fzf_catppuccin_frappe

# Reserve the two extra rows used by the rounded border.
zstyle ':fzf-tab:*' fzf-pad 4

# Match all 16 completion-group colors to Frappe's accents and light text colors.
typeset -a fzf_tab_group_colors=(
  $'\033[38;2;140;170;238m' # blue
  $'\033[38;2;166;209;137m' # green
  $'\033[38;2;229;200;144m' # yellow
  $'\033[38;2;202;158;230m' # mauve
  $'\033[38;2;231;130;132m' # red
  $'\033[38;2;133;193;220m' # sapphire
  $'\033[38;2;129;200;190m' # teal
  $'\033[38;2;239;159;118m' # peach
  $'\033[38;2;186;187;241m' # lavender
  $'\033[38;2;234;153;156m' # maroon
  $'\033[38;2;153;209;219m' # sky
  $'\033[38;2;238;190;190m' # flamingo
  $'\033[38;2;242;213;207m' # rosewater
  $'\033[38;2;244;184;228m' # pink
  $'\033[38;2;181;191;226m' # subtext1
  $'\033[38;2;198;208;245m' # text
)
zstyle ':fzf-tab:*' group-colors "${fzf_tab_group_colors[@]}"
unset fzf_tab_group_colors

# Switch between fzf-tab completion groups with angle brackets.
zstyle ':fzf-tab:*' switch-group '<' '>'

# Preview directory contents when completing cd arguments.
if type eza &>/dev/null; then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
fi

if type sheldon &>/dev/null; then
  eval "$(sheldon source)"
fi

# Keep suggestions and comments readable with Frappe's muted overlay color.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#838ba7'
if (( ${+ZSH_HIGHLIGHT_STYLES} )); then
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#838ba7'
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
