# dotfiles

![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)

Personal dotfiles for macOS. This repository contains configuration for Git,
Ghostty, Herdr, Zsh, Sheldon, Starship, tmux, Vim, and Neovim.

## Contents

| Path | Description |
| --- | --- |
| `.gitattributes` | Git-managed text-file line-ending rules |
| `.editorconfig` | Shared editor formatting rules for this repository |
| `git/config` | Shared Git fetch, push, merge, and conflict-resolution settings |
| `ghostty/config` | Ghostty terminal appearance, integration, and keybindings |
| `herdr/config.toml` | Herdr workspace, agent, notification, and input settings |
| `zsh/.zshrc` | Zsh environment, history, aliases, plugins, and prompt initialization |
| `sheldon/plugins.toml` | Zsh plugins managed by Sheldon |
| `starship/starship.toml` | Starship prompt configuration |
| `tmux/.tmux.conf` | tmux configuration and TPM plugin list |
| `vim/.vimrc` | Vim configuration managed with vim-plug |
| `neovim/` | Neovim 0.12+ configuration managed with lazy.nvim |

## Setup

### 1. Install tools

[Homebrew](https://brew.sh/) is used to install the tools on macOS. Install the
components you want to use; the Zsh configuration skips optional commands that
are not installed.

```bash
brew install herdr neovim sheldon starship tmux tree-sitter-cli vim
brew install --cask ghostty
```

These optional tools enable additional shell and Neovim features:

```bash
brew install eza fd fzf gh lazygit lua-language-server ripgrep
```

| Tool | Used by |
| --- | --- |
| [eza](https://eza.rocks/) | `ll` and `lt` Zsh aliases |
| [fd](https://github.com/sharkdp/fd) | Fast file discovery in Snacks pickers |
| [fzf](https://github.com/junegunn/fzf) | Interactive completion through `fzf-tab` |
| [gh](https://cli.github.com/) | GitHub Issue and pull request pickers in Neovim |
| [lazygit](https://github.com/jesseduffield/lazygit) | `<leader>gg` in Neovim |
| [lua-language-server](https://luals.github.io/) | Lua diagnostics and completion in Neovim |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast text search in Snacks pickers |
| [Nerd Font](https://www.nerdfonts.com/) | Icons in Starship, eza, and Neovim |

### 2. Clone the repository

Set `DOTFILES_DIR` to the directory where you want to keep the repository. It
defaults to `~/dotfiles`.

```bash
export DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/dotfiles}"
git clone https://github.com/nagatax/dotfiles.git "${DOTFILES_DIR}"
```

### 3. Link the configurations

Back up or remove any files that already exist at these destinations before
creating the symbolic links.

```bash
mkdir -p ~/.config/ghostty ~/.config/herdr ~/.config/sheldon

ln -s "${DOTFILES_DIR}/ghostty/config" ~/.config/ghostty/config
ln -s "${DOTFILES_DIR}/herdr/config.toml" ~/.config/herdr/config.toml
ln -s "${DOTFILES_DIR}/zsh/.zshrc" ~/.zshrc
ln -s "${DOTFILES_DIR}/sheldon/plugins.toml" ~/.config/sheldon/plugins.toml
ln -s "${DOTFILES_DIR}/starship/starship.toml" ~/.config/starship.toml
ln -s "${DOTFILES_DIR}/tmux/.tmux.conf" ~/.tmux.conf
ln -s "${DOTFILES_DIR}/vim/.vimrc" ~/.vimrc
ln -s "${DOTFILES_DIR}/neovim" ~/.config/nvim

git config --global --add include.path "${DOTFILES_DIR}/git/config"
```

## Git

The shared Git configuration keeps related local branches aligned when their
commits are rewritten by rebase, except for branches checked out in another
worktree. Failed interactive-rebase `exec` commands are rescheduled so they can
run again after the underlying problem is fixed.

## Ghostty

Ghostty reads its configuration from `~/.config/ghostty/config`. This
configuration uses JetBrains Mono with the Catppuccin Frappe theme and defines
clipboard, cursor, window, shell integration, and split navigation behavior.
Full-screen application backgrounds extend into the balanced window padding,
and unfocused splits fade toward the Frappe Mantle color.

### Split keybindings

Ghostty, Neovim, and tmux use the same action grammar for split management.
These bindings work with the Advantage360 Limited's standard layout and do
not require a SmartSet or ZMK remap.

| Action | Ghostty | Neovim | tmux |
| --- | --- | --- | --- |
| Focus left/down/up/right | `Alt+h/j/k/l` | `Space`, then `h/j/k/l` | `Ctrl-b`, then `h/j/k/l` |
| Split left/down/up/right | `Alt+s`, then `h/j/k/l` | `Space`, `s`, then `h/j/k/l` | `Ctrl-b`, `s`, then `h/j/k/l` |
| Resize left/down/up/right by 5 cells | `Alt+r`, then `h/j/k/l` | `Space`, `r`, then `h/j/k/l` | `Ctrl-b`, `r`, then `h/j/k/l` |
| Toggle zoom | `Alt+z` | `Space`, then `z` | `Ctrl-b`, then `z` |

Ghostty also uses `Alt+n`/`Alt+p` to cycle splits, `Alt+e` to equalize them,
and `Alt+u`/`Alt+d` to jump to the previous or next shell prompt.

## Herdr

Herdr reads its configuration from `~/.config/herdr/config.toml`. The theme
inherits Ghostty's Catppuccin Frappe palette, and background-agent notifications
are delivered through Ghostty. The configuration also enables Japanese input
support for Codex and Claude Code panes without saving pane contents to disk.
Distinct status symbols make agent states recognizable without relying on color
alone, while Frappe surface colors separate the sidebar, active row, and current
selection. A darker panel background separates the tab bar and overlays from
terminal content. The expanded sidebar emphasizes the agent name, then uses
progressively quieter colors for its state, terminal activity, workspace, and
tab. The Spaces list gives workspace names stronger emphasis while preserving
semantic state and Git-status colors. When multiple tabs are visible, the tab
bar shows zoom state and local time in a right-aligned status area.

The default <kbd>Ctrl-b</kbd> prefix keeps pane navigation consistent with tmux:

| Action | Herdr |
| --- | --- |
| Focus left/down/up/right | `Ctrl-b`, then `h/j/k/l` |
| Split right/down | `Ctrl-b`, then `v/-` |
| Resize left/down/up/right | `Ctrl-b`, then `r`, then `h/j/k/l` |
| Toggle zoom | `Ctrl-b`, then `z` |
| Switch tab 1–9 | `Ctrl-b`, then `1–9` |
| Switch workspace 1–9 | `Ctrl-b`, then `Shift+1–9` |
| Focus agent 1–9 | `Ctrl-b`, then `Alt+1–9` |
| Focus previous/next agent | `Ctrl-b`, then `Alt+p/n` |
| Focus the last pane | `Ctrl-b`, then backtick |
| Open Lazygit popup | `Ctrl-b`, then `Alt+g` |
| Open an existing Git worktree | `Ctrl-b`, then `Alt+w` |
| Remove the selected Git worktree after confirmation | `Ctrl-b`, then `Alt+Shift+w` |

Install the optional integrations for installed coding agents to let Herdr
restore their native sessions after a server restart:

```bash
herdr integration install codex
herdr integration install claude
herdr integration status
```

Run `herdr` to start or attach to the persistent session. Reload configuration
changes in a running session with `herdr server reload-config`.

## Zsh, Sheldon, and Starship

The Zsh configuration loads Sheldon and Starship only when their executables
are available. After linking the files, install the Sheldon plugins and reload
the shell:

```bash
sheldon lock
exec zsh
```

Sheldon installs completions, `fzf-tab`, autosuggestions, and syntax
highlighting from `sheldon/plugins.toml`. Standalone fzf and fzf-tab use the
official Catppuccin Frappe colors. Starship automatically reads
`~/.config/starship.toml`. Its battery indicator stays hidden above 20%, warns
in yellow at 20%, and turns red at 10%. Repository root names are highlighted
in mauve, and the right prompt shows local time with a muted Frappe clock icon.
Continued input uses a muted double-arrow prompt. Zsh refuses to overwrite an
existing file with `>`; use `>|` when an overwrite is intentional. Append
redirection with `>>` can still create a missing file. History-listing commands
are omitted from saved history, and ZLE error bells are disabled. Directory
changes are recorded in a duplicate-free stack; inspect it with `dirs -v` and
jump to an older entry with commands such as `cd -2`.

## tmux

This configuration requires tmux 3.7 or later for copy-mode line numbers. Its
status line, active window, pane borders, messages, and copy mode use the same
Catppuccin Frappe palette as Ghostty. Activity in background windows is
highlighted in yellow without displaying an additional message. Copy-mode
search matches and line numbers use distinct Frappe colors. Rounded session and
active-window pills frame the status line, while menus, popups, command prompts,
and the session tree use matching Frappe surfaces and selection colors. Each
pane border shows its index and title, with color and arrow indicators making
the active pane easier to identify. The right status area is reserved for the
date and time because pane titles are displayed on their borders.

Install [TPM](https://github.com/tmux-plugins/tpm) before starting tmux with this
configuration:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins
tmux
```

The command-line installer fetches the configured plugins without requiring a
running tmux server. Inside tmux, `prefix` + <kbd>I</kbd> installs any plugins
added later. The default prefix is <kbd>Ctrl-b</kbd>. The window list stays
centered and uses padded, contiguous tabs. Pane-number overlays use Frappe
colors to distinguish the active pane.

## Vim

Install [vim-plug](https://github.com/junegunn/vim-plug):

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Launch Vim and run `:PlugInstall` to install the plugins. When clipboard
support is available, Vim connects unnamed register operations to the macOS
system clipboard. Line numbers use a hybrid display: the current line is
absolute and surrounding lines are relative. Long lines wrap at word boundaries
while preserving their visual indentation and display a continuation marker.
End-of-buffer tildes are hidden, similar lines in larger diff hunks are aligned,
and unmodified files are reloaded when they change outside Vim. Catppuccin
Frappe provides full RGB colors for Vim, lightline, and the alternating
indent-guide backgrounds. Lightline uses rounded separators that match Neovim.

## Neovim

The Neovim configuration requires Neovim 0.12 or later. On the first launch,
[lazy.nvim](https://github.com/folke/lazy.nvim) bootstraps itself and installs
the plugins pinned in `neovim/lazy-lock.json`. The unnamed register uses the
macOS system clipboard for yank, delete, change, and put operations. Line
numbers use a hybrid display: the current line is absolute and surrounding
lines are relative. Long lines wrap at word boundaries while preserving their
visual indentation and display a continuation marker. End-of-buffer tildes are
hidden, and diff mode uses histogram matching with a larger line-alignment
window. Embedded terminals use the Catppuccin Frappe ANSI palette, and inactive
editor splits use restrained background dimming to keep the active split clear.
Solid rounded floating windows, rounded lualine separators, and Nerd Font fold
markers keep editor chrome visually consistent. LSP inlay hints retain their
muted text color without drawing a background block over the code. Diagnostic
virtual text appears only on the cursor line, while signs and underlines remain
visible elsewhere. Completion labels use Tree-sitter colors, and the active
indent scope uses rounded chunk markers. Python debugging uses Catppuccin-aware
breakpoint and log-point symbols plus rounded floating windows.
Starting Neovim without a file opens a single-column Snacks dashboard with
keymaps, recent files, projects, repository status, and startup time. Neovim
started from Zsh writes its general log to
`~/.local/state/nvim/nvim.log` by default, or to the corresponding directory
under `$XDG_STATE_HOME` when that variable is set.

```bash
nvim
```

`tree-sitter-cli` is required to build the parsers configured for C, C++, Git
attributes, Git commits, Git ignore files, Go, Go templates, JSON, Lua,
Markdown, PHP, Python, regular expressions, Rust, Terraform, TOML, Vim, Vim
documentation, and Zsh.

The following language servers are enabled. Install only the servers needed for
the languages you use.

| Neovim config | Executable | Language |
| --- | --- | --- |
| `clangd` | `clangd` | C and C++ |
| `rust_analyzer` | `rust-analyzer` | Rust |
| `gopls` | `gopls` | Go |
| `lua_ls` | `lua-language-server` | Lua |
| `terraformls` | `terraform-ls` | Terraform |
| `intelephense` | `intelephense` | PHP |
| `basedpyright` | `basedpyright-langserver` | Python |

The custom clangd arguments are defined in `neovim/after/lsp/clangd.lua`.

## License

This software is released under the MIT License. See [LICENSE](LICENSE).
