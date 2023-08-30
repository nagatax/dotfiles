" ##### encoding #####
if has('win32')
    set encoding=cp932
else
    set encoding=utf-8
endif
scriptencoding utf-8

unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

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

" すべてのswapファイルを同じディレクトリに出力する
if !isdirectory(expand("$HOME/.vim/swap"))
    call mkdir(expand("$HOME/.vim/swap"), "p")
endif
set directory=$HOME/.vim/swap//

" すべてのファイルの永続アンドゥを有効にする
set undofile
if !isdirectory(expand("$HOME/.vim/undodir"))
    call mkdir(expand("$HOME/.vim/undodir"), "p")
endif
set undodir=$HOME/.vim/undodir

" wildmenuの有効化
set wildmenu
set wildmode=list:longest,full

" ##### vim-plug #####

" vim-plugの初期化と設定開始
call plug#begin()

" # lightline
Plug 'itchyny/lightline.vim'
set laststatus=2

" # vim indent guides
Plug 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4

" # vim trailing whitespace
Plug 'bronson/vim-trailing-whitespace'
" uniteでスペースが表示されるので、設定でOFFにする
let g:extra_whitespace_ignored_filetypes = ['unite']

" # tcomment vim
Plug 'tomtom/tcomment_vim'

" # emmet-vim
Plug 'mattn/emmet-vim'

" # vim-css3-syntax
Plug 'hail2u/vim-css3-syntax'

" # NERDtree
Plug 'scrooloose/nerdtree'
" 起動時にブックマークを表示
" let NERDTreeShowBookmarks = 1
" 起動時にNERDTreeを開く
" autocmd VimEnter * NERDTree

" # Markdown
Plug 'tpope/vim-markdown'
Plug 'tyru/open-browser.vim'
Plug 'thinca/vim-quickrun'

" # vimproc
Plug 'Shougo/vimproc.vim'

" # vimshell
Plug 'Shougo/vimshell.vim'

" # Editorconfig
Plug 'editorconfig/editorconfig-vim'

" # TypeScript
Plug 'leafgarland/typescript-vim'

" # vim-go
Plug 'fatih/vim-go'

" # vim-toml
Plug 'cespare/vim-toml'

" # vim-unimpaired
Plug 'tpope/vim-unimpaired'

" # vim-easymotion
Plug 'easymotion/vim-easymotion'

" vim-plugの設定終了
call plug#end()

" 読み込んだプラグインを含め、ファイルタイプの検出、
" ファイルタイプ別プラグイン/インデントを有効化する
filetype plugin indent on

augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.sh setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END
