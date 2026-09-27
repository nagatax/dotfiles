# Render Starship's right prompt and Git status without delaying command-line
# input, and draw the prompt character in Zsh so vi mode switches stay instant.

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
typeset -g DOTFILES_STARSHIP_GIT_STATUS=''
typeset -g DOTFILES_STARSHIP_GIT_STATUS_DIR=''
typeset -g DOTFILES_PROMPT_CHAR=''
typeset -gi DOTFILES_STARSHIP_PROMPT_GENERATION=0

# Keep the left prompt static between redraws so an async result does not rerun it.
# Command substitution strips trailing newlines, so Zsh adds the line break.
PROMPT=$'${DOTFILES_STARSHIP_LEFT_PROMPT}${DOTFILES_STARSHIP_GIT_STATUS}\n${DOTFILES_PROMPT_CHAR}'
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

# Match Starship's default character module with the Frappe palette.
_dotfiles_starship_update_char() {
  if [[ "${KEYMAP:-}" == vicmd ]]; then
    DOTFILES_PROMPT_CHAR='%B%F{#a6d189}❮%f%b '
  elif [[ "${STARSHIP_CMD_STATUS:-0}" == 0 ]]; then
    DOTFILES_PROMPT_CHAR='%B%F{#a6d189}❯%f%b '
  else
    DOTFILES_PROMPT_CHAR='%B%F{#e78284}❯%f%b '
  fi
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

_dotfiles_starship_async_git_status() {
  local generation=$1
  local starship_bin=$2

  print -r -- "${generation}"
  "${starship_bin}" module git_status
}

# starship module does not mark escape sequences as zero-width for Zsh, so wrap
# them and return the prompt-ready text in REPLY without starting a subshell.
_dotfiles_starship_format_git_status() {
  setopt local_options extended_glob
  REPLY="${1%%[[:space:]]#}"
  REPLY="${REPLY//\%/%%}"
  REPLY="${REPLY//(#m)$'\e'\[[0-9;]#m/%{${MATCH}%\}}"
  [[ -n "${REPLY}" ]] && REPLY+=' '
}

_dotfiles_starship_async_callback() {
  local job=$1
  local code=$2
  local output=$3

  [[ ${code} -eq 0 ]] || return 0

  local result_generation="${output%%$'\n'*}"
  [[ "${result_generation}" == "${DOTFILES_STARSHIP_PROMPT_GENERATION}" ]] || return 0

  local result=''
  [[ "${output}" == *$'\n'* ]] && result="${output#*$'\n'}"

  case "${job}" in
    _dotfiles_starship_async_render)
      [[ "${RPROMPT}" != "${result}" ]] || return 0
      RPROMPT="${result}"
      ;;
    _dotfiles_starship_async_git_status)
      local REPLY
      _dotfiles_starship_format_git_status "${result}"
      result="${REPLY}"
      [[ "${DOTFILES_STARSHIP_GIT_STATUS}" != "${result}" ]] || return 0
      DOTFILES_STARSHIP_GIT_STATUS="${result}"
      ;;
    *)
      return 0
      ;;
  esac

  # Redraw only while the line editor is active, preserving the input buffer.
  zle && zle reset-prompt
}

_dotfiles_starship_render_sync_fallback() {
  RPROMPT="${DOTFILES_STARSHIP_SYNC_RPROMPT}"
  local REPLY
  _dotfiles_starship_format_git_status "$("${DOTFILES_STARSHIP_BIN}" module git_status)"
  DOTFILES_STARSHIP_GIT_STATUS="${REPLY}"
}

_dotfiles_starship_start_async_prompt() {
  RPROMPT=''
  async_stop_worker "${DOTFILES_STARSHIP_ASYNC_WORKER}" 2>/dev/null

  if ! async_start_worker "${DOTFILES_STARSHIP_ASYNC_WORKER}" -n; then
    _dotfiles_starship_render_sync_fallback
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
    "${STARSHIP_JOBS_COUNT:-0}" ||
    ! async_job \
    "${DOTFILES_STARSHIP_ASYNC_WORKER}" \
    _dotfiles_starship_async_git_status \
    "${DOTFILES_STARSHIP_PROMPT_GENERATION}" \
    "${DOTFILES_STARSHIP_BIN}"; then
    async_stop_worker "${DOTFILES_STARSHIP_ASYNC_WORKER}" 2>/dev/null
    _dotfiles_starship_render_sync_fallback
    return 1
  fi
}

_dotfiles_starship_async_precmd() {
  (( ++DOTFILES_STARSHIP_PROMPT_GENERATION ))
  _dotfiles_starship_update_char
  _dotfiles_starship_render_left

  # Keep the previous Git status in the same directory until the new one arrives.
  if [[ "${DOTFILES_STARSHIP_GIT_STATUS_DIR}" != "${PWD}" ]]; then
    DOTFILES_STARSHIP_GIT_STATUS=''
    DOTFILES_STARSHIP_GIT_STATUS_DIR="${PWD}"
  fi

  _dotfiles_starship_start_async_prompt
}

_dotfiles_starship_async_preexec() {
  (( ++DOTFILES_STARSHIP_PROMPT_GENERATION ))
  RPROMPT=''
  async_stop_worker "${DOTFILES_STARSHIP_ASYNC_WORKER}" 2>/dev/null
}

_dotfiles_starship_async_cleanup() {
  async_stop_worker "${DOTFILES_STARSHIP_ASYNC_WORKER}" 2>/dev/null
}

# Starship's registered widget calls this function by name. Only the prompt
# character depends on the keymap, so switching modes does not run Starship.
starship_zle-keymap-select() {
  _dotfiles_starship_update_char
  zle reset-prompt
}

add-zsh-hook precmd _dotfiles_starship_async_precmd
add-zsh-hook preexec _dotfiles_starship_async_preexec
add-zsh-hook zshexit _dotfiles_starship_async_cleanup
