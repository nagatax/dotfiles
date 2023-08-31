" # set nocompatible
if !has('nvim')
  " setting for vim
  set nocompatible
endif

" # encoding
if has('win32')
  set encoding=cp932
else
  set encoding=utf-8
endif
if !has('nvim')
  " setting for vim
  scriptencoding utf-8
endif

" # load the default setting
if !has('nvim')
  " setting for vim
  unlet! skip_defaults_vim
  source $VIMRUNTIME/defaults.vim
endif

" # whichwrap
set whichwrap=b,s,[,],<,>,~

" # clear mouse setting
set mouse=

" # enable hlsearch
set hlsearch

" # enable cursorline
set cursorline

" # convert tab to space
set expandtab

" # set tabstop
set tabstop=4

" # enable autoindent
if !has('nvim')
  " setting for vim
   set autoindent
endif

" # set autoindent width
set shiftwidth=4

" # set printing line number
set number

" # set color scheme
syntax on
colorscheme molokai
set t_Co=256

" # set swap directory
if !isdirectory(expand("$HOME/.vim/swap"))
  call mkdir(expand("$HOME/.vim/swap"), "p")
endif
set directory=$HOME/.vim/swap//

" # set undo directory
set undofile
if !isdirectory(expand("$HOME/.vim/undo"))
  call mkdir(expand("$HOME/.vim/undo"), "p")
endif
set undodir=$HOME/.vim/undo

" # enable wildmenu
set wildmenu
set wildmode=list:longest,full

" ##### vim-plug #####

" # begin vim-plug
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

" # end vim-plug
call plug#end()

augroup fileTypeIndent
  autocmd!
  autocmd BufNewFile,BufRead *.sh setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END
