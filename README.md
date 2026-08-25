# dotfiles

![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)

Personal dotfiles for macOS. This repository contains configuration for Zsh,
Sheldon, Starship, tmux, Vim, and Neovim.

## Contents

| Path | Description |
| --- | --- |
| `.editorconfig` | Shared editor formatting rules for this repository |
| `.vscode/extensions.json` | Recommended VS Code extensions for this repository |
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
brew install neovim sheldon starship tmux tree-sitter-cli vim
```

These optional tools enable additional shell and Neovim features:

```bash
brew install eza fd fzf gh lazygit ripgrep
```

| Tool | Used by |
| --- | --- |
| [eza](https://eza.rocks/) | `ll` and `lt` Zsh aliases |
| [fd](https://github.com/sharkdp/fd) | Fast file discovery in Snacks pickers |
| [fzf](https://github.com/junegunn/fzf) | Interactive completion through `fzf-tab` |
| [gh](https://cli.github.com/) | GitHub Issue and pull request pickers in Neovim |
| [lazygit](https://github.com/jesseduffield/lazygit) | `<leader>gg` in Neovim |
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
mkdir -p ~/.config/sheldon

ln -s "${DOTFILES_DIR}/zsh/.zshrc" ~/.zshrc
ln -s "${DOTFILES_DIR}/sheldon/plugins.toml" ~/.config/sheldon/plugins.toml
ln -s "${DOTFILES_DIR}/starship/starship.toml" ~/.config/starship.toml
ln -s "${DOTFILES_DIR}/tmux/.tmux.conf" ~/.tmux.conf
ln -s "${DOTFILES_DIR}/vim/.vimrc" ~/.vimrc
ln -s "${DOTFILES_DIR}/neovim" ~/.config/nvim
```

## Zsh, Sheldon, and Starship

The Zsh configuration loads Sheldon and Starship only when their executables
are available. After linking the files, install the Sheldon plugins and reload
the shell:

```bash
sheldon lock
exec zsh
```

Sheldon installs completions, `fzf-tab`, autosuggestions, and syntax
highlighting from `sheldon/plugins.toml`. Starship automatically reads
`~/.config/starship.toml`.

## tmux

Install [TPM](https://github.com/tmux-plugins/tpm) before starting tmux with this
configuration:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux
```

Inside tmux, press `prefix` + <kbd>I</kbd> to install the configured plugins.
The default prefix is <kbd>Ctrl-b</kbd>.

## Vim

Install [vim-plug](https://github.com/junegunn/vim-plug):

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Install the molokai colorscheme used by `.vimrc`:

```bash
mkdir -p ~/.vim/colors
git clone https://github.com/tomasr/molokai ~/.vim/molokai
mv ~/.vim/molokai/colors/molokai.vim ~/.vim/colors/
rm -rf ~/.vim/molokai
```

Launch Vim and run `:PlugInstall` to install the plugins.

## Neovim

The Neovim configuration requires Neovim 0.12 or later. On the first launch,
[lazy.nvim](https://github.com/folke/lazy.nvim) bootstraps itself and installs
the plugins pinned in `neovim/lazy-lock.json`.

```bash
nvim
```

`tree-sitter-cli` is required to build the parsers configured for C, C++, Go,
Lua, Rust, Terraform, Vim, and Vim documentation.

The following language servers are enabled. Install only the servers needed for
the languages you use.

| Neovim config | Executable | Language |
| --- | --- | --- |
| `clangd` | `clangd` | C and C++ |
| `rust_analyzer` | `rust-analyzer` | Rust |
| `gopls` | `gopls` | Go |
| `terraformls` | `terraform-ls` | Terraform |
| `intelephense` | `intelephense` | PHP |
| `basedpyright` | `basedpyright-langserver` | Python |

The custom clangd arguments are defined in `neovim/after/lsp/clangd.lua`.

## License

This software is released under the MIT License. See [LICENSE](LICENSE).
