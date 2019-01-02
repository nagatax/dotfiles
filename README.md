# Description of dotfiles project

![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)

## Overview

ドットファイルをまとめました。

## How to use

NeoBundleとmolokaiがインストール済みであること。

1. NeoBundleがインストールする

```bash
mkdir -p ~/.vim/bundle
git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
```

2. 背景スキーマをインストールする

```bash
mkdir -p ~/.vim/colors
cd .vim
git clone https://github.com/tomasr/molokai
mv ~/.vim/molokai/colors/molokai.vim ~/.vim/colors/
rm -rf ~/.vim/molokai
```

## License

This software is released under the MIT License, see [LICENSE](https://github.com/nagatax/dotfiles/blob/master/LICENSE).
