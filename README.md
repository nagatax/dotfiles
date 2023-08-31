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

1. Clone this repository

```bash
git clone https://github.com/nagatax/dotfiles.git
```

2. Install vim-plug

```bash
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

3. Create init.vim

```bash
mkdir -p ~/.config/nvim \
&& ln -s ~/Documents/dotfiles/vim/.vimrc ~/.config/nvim/init.vim
```

4. Install molokai

```bash
mkdir -p ~/.config/nvim/colors \
&& git clone https://github.com/tomasr/molokai ~/.config/nvim/molokai \
&& mv ~/.config/nvim/molokai/colors/molokai.vim ~/.config/nvim/colors/ \
&& rm -rf ~/.config/nvim/molokai
```

5. Reload init.vim and :PlugInstall to install plugins.

## License

This software is released under the MIT License, see [LICENSE](https://github.com/nagatax/dotfiles/blob/master/LICENSE).
