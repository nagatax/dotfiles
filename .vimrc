" ##### nocompatible #####
set nocompatible

" ##### Backspace #####
set backspace=indent,eol,start

" ##### whichwrap #####
set whichwrap=b,s,[,],<,>,~

" ##### mouse #####
set mouse=

" ##### 検索 #####
set hlsearch

" ##### cursorlineの有効化 #####
set cursorline

" ##### タブをスペースにする #####
set expandtab

" ##### タブ長 #####
set tabstop=4

" ##### オートインデント #####
"set autoindent

" ##### オートインデントの長さ #####
set shiftwidth=4

" ##### 行番号を表示する #####
set number

" ##### Molokai #####
syntax on
colorscheme molokai
set t_Co=256

" ##### NeoBundle #####
" vim起動時のみruntimeにneobundle.vimを追加
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
endif

" neobundle.vimの初期化と設定開始
call neobundle#begin(expand('~/.vim/bundle'))

" # bundle
" neobundle.vimを更新するための設定
NeoBundleFetch 'Shougo/neobundle.vim'

" # lightline
NeoBundle 'itchyny/lightline.vim'
set laststatus=2

" # vim indent guides
NeoBundle 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4

" # vim trailing whitespace
NeoBundle 'bronson/vim-trailing-whitespace'
if neobundle#tap('vim-trailing-whitespace')
" uniteでスペースが表示されるので、設定でOFFにする
  let g:extra_whitespace_ignored_filetypes = ['unite']
endif

" # tcomment vim
NeoBundle 'tomtom/tcomment_vim'

" # emmet-vim
NeoBundle 'mattn/emmet-vim'

" vim css3 syntax
NeoBundle 'hail2u/vim-css3-syntax'

" # NERDtree
NeoBundle 'scrooloose/nerdtree'

" # Markdown
NeoBundle 'tpope/vim-markdown'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'thinca/vim-quickrun'

NeoBundle 'Shougo/vimproc.vim'
NeoBundle 'Shougo/vimshell.vim'

" neobundle.vimの設定終了
call neobundle#end()

" 読み込んだプラグインを含め、ファイルタイプの検出、
" ファイルタイプ別プラグイン/インデントを有効化する
filetype plugin indent on

NeoBundleCheck

if !has('vim_starting')
    call neobundle#call_hook('on_source')
endif
