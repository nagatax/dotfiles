# dotfiles

![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)

## How to use

### vim

1. Clone this repository

```bash
git clone https://github.com/nagatax/dotfiles.git
```

2. Install vim-plug

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

3. Create .vimrc

```bash
ln -s ~/Documents/dotfiles/vim/.vimrc ~/.vimrc
```

4. Install molokai

```bash
mkdir -p ~/.vim/colors \
&& git clone https://github.com/tomasr/molokai ~/.vim/molokai \
&& mv ~/.vim/molokai/colors/molokai.vim ~/.vim/colors/ \
&& rm -rf ~/.vim/molokai
```

5. Reload .vimrc and :PlugInstall to install plugins.

### neovim

Requires Neovim 0.11 or later (uses `vim.lsp.enable()` and the `lsp/` directory layout).

1. Clone this repository

```bash
git clone https://github.com/nagatax/dotfiles.git
```

2. Link the config directory

```bash
mkdir -p ~/.config \
&& ln -s ~/Documents/dotfiles/neovim ~/.config/nvim
```

3. Launch nvim

[lazy.nvim](https://github.com/folke/lazy.nvim) bootstraps itself on the first
launch and installs the plugins pinned in `neovim/lazy-lock.json`.

```bash
nvim
```

#### Optional dependencies

| Tool | Used by |
| --- | --- |
| [clangd](https://clangd.llvm.org/) | C/C++ LSP (`neovim/lsp/clangd.lua`) |
| [gh](https://cli.github.com/) | `<leader>gi` / `<leader>gp` GitHub pickers |

## License

This software is released under the MIT License, see [LICENSE](https://github.com/nagatax/dotfiles/blob/master/LICENSE).
