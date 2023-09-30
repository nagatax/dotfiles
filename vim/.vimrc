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

" # vim-toml
Plug 'cespare/vim-toml'

" # vim-unimpaired
Plug 'tpope/vim-unimpaired'

" # vim-easymotion
Plug 'easymotion/vim-easymotion'

" # vim-fugitive
Plug 'tpope/vim-fugitive'

" # vim-test
Plug 'janko-m/vim-test'

" # ale
Plug 'dense-analysis/ale'

" # vim-lsp-settings
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

" # vim-vsnip
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

" # asyncomplete.vim
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" # lexima.vim
Plug 'cohama/lexima.vim'

" # copilot.vim
Plug 'github/copilot.vim'

" # end vim-plug
call plug#end()

" # Language Server Protocol setting
function! s:on_lsp_buffer_enabled() abort
  if &buftype ==# 'nofile' || &filetype =~# '^\(quickrun\)' || getcmdwintype() ==# ':'
    return
  endif

  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes

  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)
  
  let g:lsp_format_sync_timeout = 1000
  autocmd BufWritePre *.go call execute(['LspCodeActionSync source.organizeImports', 'LspDocumentFormatSync'])
endfunction

augroup vimrc_lsp_install
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END