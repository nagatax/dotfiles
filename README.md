# 設定ファイル集

# はじめに

ドットファイルをまとめました。

# 前提条件

NeoBundleとmolokaiがインストール済みであること。

1. NeoBundleがインストールする

```bash
mkdir -p ~/.vim/bundle
git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
```

2. 背景スキーマをインストールする

```bash
mkdir -p ~/.vim/colors
git clone https://github.com/tomasr/molokai
mv ~/.vim/molokai/colors/molokai.vim ~/.vim/colors/
rm -rf ~/.vim/molokai
```
