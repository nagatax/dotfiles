if &compatible
  set nocompatible               " Be iMproved
endif

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

"vim-plug Scripts-----------------------------
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

call plug#end()
"End vim-plug Scripts-------------------------