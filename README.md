# dotfiles

![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)

## How to use

1. Install NeoBundle

```bash
mkdir -p ~/.vim/bundle \
&& git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
```

2. Install molokai

```bash
mkdir -p ~/.vim/colors \
&& git clone https://github.com/tomasr/molokai ~/.vim/molokai \
&& mv ~/.vim/molokai/colors/molokai.vim ~/.vim/colors/ \
&& rm -rf ~/.vim/molokai
```

3. Set up vim-go

```bash
vim -c GoInstallBinaries -c q
```

## License

This software is released under the MIT License, see [LICENSE](https://github.com/nagatax/dotfiles/blob/master/LICENSE).
