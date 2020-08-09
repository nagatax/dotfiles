# dotfiles

![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)

## How to use

### vim

1. Clone this repository

```bash
git clone https://github.com/nagatax/dotfiles.git
```

2. Install NeoBundle

```bash
mkdir -p ~/.vim/bundle \
&& git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
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

5. Set up vim-go

```bash
vim -c GoInstallBinaries -c q
```

### neovim

1. Clone this repository

```bash
git clone https://github.com/nagatax/dotfiles.git
```

2. Install dein.vim

```bash
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh \
&& sh ./installer.sh ~/.cache/dein \
&& rm installer.sh 
```

3. Create init.vim

```bash
mkdir -p ~/.config/nvim \
&& ln -s ~/Documents/dotfiles/neovim/init.vim ~/.config/nvim/init.vim
```

4. Set up vim-go

```bash
nvim -c GoInstallBinaries -c q
```

## License

This software is released under the MIT License, see [LICENSE](https://github.com/nagatax/dotfiles/blob/master/LICENSE).
