# Render Starship's right prompt without delaying command-line input.

[[ -o interactive ]] || return 0
(( ${+functions[async_start_worker]} )) || return 0

typeset -g DOTFILES_STARSHIP_ASYNC_WORKER='dotfiles_starship_rprompt'

# Preserve Starship's generated prompt definitions for reloads and fallback.
if (( ! ${+DOTFILES_STARSHIP_SYNC_PROMPT} )); then
  typeset -g DOTFILES_STARSHIP_SYNC_PROMPT="${PROMPT}"
  typeset -g DOTFILES_STARSHIP_SYNC_RPROMPT="${RPROMPT}"
fi

# Remove the previous async integration before reloading its functions.
autoload -Uz add-zsh-hook
add-zsh-hook -d precmd _dotfiles_starship_async_precmd 2>/dev/null
add-zsh-hook -d preexec _dotfiles_starship_async_preexec 2>/dev/null
add-zsh-hook -d zshexit _dotfiles_starship_async_cleanup 2>/dev/null
async_stop_worker "${DOTFILES_STARSHIP_ASYNC_WORKER}" 2>/dev/null

typeset -g DOTFILES_STARSHIP_BIN="${commands[starship]}"
typeset -g DOTFILES_STARSHIP_LEFT_PROMPT=''
typeset -gi DOTFILES_STARSHIP_PROMPT_GENERATION=0

# Keep the left prompt static between redraws so an async result does not rerun it.
PROMPT='${DOTFILES_STARSHIP_LEFT_PROMPT}'
RPROMPT=''

_dotfiles_starship_render_left() {
  DOTFILES_STARSHIP_LEFT_PROMPT="$(
    "${DOTFILES_STARSHIP_BIN}" prompt \
      --terminal-width="${COLUMNS}" \
      --keymap="${KEYMAP:-}" \
      --status="${STARSHIP_CMD_STATUS:-}" \
      --pipestatus="${STARSHIP_PIPE_STATUS[*]:-}" \
      --cmd-duration="${STARSHIP_DURATION:-}" \
      --jobs="${STARSHIP_JOBS_COUNT:-0}"
  )"
}

# This function runs inside a freshly started worker that inherits the current
# directory and environment. The first output line identifies the prompt cycle.
_dotfiles_starship_async_render() {
  local generation=$1
  local starship_bin=$2
  local terminal_width=$3
  local keymap=$4
  local command_status=$5
  local pipestatus_value=$6
  local duration=$7
  local jobs=$8

  print -r -- "${generation}"
  "${starship_bin}" prompt --right \
    --terminal-width="${terminal_width}" \
    --keymap="${keymap}" \
    --status="${command_status}" \
    --pipestatus="${pipestatus_value}" \
    --cmd-duration="${duration}" \
    --jobs="${jobs}"
}

_dotfiles_starship_async_callback() {
  local job=$1
  local code=$2
  local output=$3

  [[ "${job}" == '_dotfiles_starship_async_render' && ${code} -eq 0 ]] || return 0

  local result_generation="${output%%$'\n'*}"
  [[ "${result_generation}" == "${DOTFILES_STARSHIP_PROMPT_GENERATION}" ]] || return 0

  if [[ "${output}" == *$'\n'* ]]; then
    RPROMPT="${output#*$'\n'}"
  else
    RPROMPT=''
  fi

  # Redraw only while the line editor is active, preserving the input buffer.
  zle && zle reset-prompt
}

_dotfiles_starship_start_right_prompt() {
  RPROMPT=''
  async_stop_worker "${DOTFILES_STARSHIP_ASYNC_WORKER}" 2>/dev/null

  if ! async_start_worker "${DOTFILES_STARSHIP_ASYNC_WORKER}" -n; then
    RPROMPT="${DOTFILES_STARSHIP_SYNC_RPROMPT}"
    return 1
  fi

  async_register_callback \
    "${DOTFILES_STARSHIP_ASYNC_WORKER}" \
    _dotfiles_starship_async_callback

  if ! async_job \
    "${DOTFILES_STARSHIP_ASYNC_WORKER}" \
    _dotfiles_starship_async_render \
    "${DOTFILES_STARSHIP_PROMPT_GENERATION}" \
    "${DOTFILES_STARSHIP_BIN}" \
    "${COLUMNS}" \
    "${KEYMAP:-}" \
    "${STARSHIP_CMD_STATUS:-}" \
    "${STARSHIP_PIPE_STATUS[*]:-}" \
    "${STARSHIP_DURATION:-}" \
    "${STARSHIP_JOBS_COUNT:-0}"; then
    async_stop_worker "${DOTFILES_STARSHIP_ASYNC_WORKER}" 2>/dev/null
    RPROMPT="${DOTFILES_STARSHIP_SYNC_RPROMPT}"
    return 1
  fi
}

_dotfiles_starship_async_precmd() {
  (( ++DOTFILES_STARSHIP_PROMPT_GENERATION ))
  _dotfiles_starship_render_left
  _dotfiles_starship_start_right_prompt
}

_dotfiles_starship_async_preexec() {
  (( ++DOTFILES_STARSHIP_PROMPT_GENERATION ))
  RPROMPT=''
  async_stop_worker "${DOTFILES_STARSHIP_ASYNC_WORKER}" 2>/dev/null
}

_dotfiles_starship_async_cleanup() {
  async_stop_worker "${DOTFILES_STARSHIP_ASYNC_WORKER}" 2>/dev/null
}

# Starship's registered widget calls this function by name. Re-rendering here
# preserves its vi-mode character behavior without affecting async callbacks.
starship_zle-keymap-select() {
  _dotfiles_starship_render_left
  zle reset-prompt
}

add-zsh-hook precmd _dotfiles_starship_async_precmd
add-zsh-hook preexec _dotfiles_starship_async_preexec
add-zsh-hook zshexit _dotfiles_starship_async_cleanup
