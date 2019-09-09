"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/Users/nagata/.cache/dein/./repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/Users/nagata/.cache/dein/.')
  call dein#begin('/Users/nagata/.cache/dein/.')

  " Let dein manage dein
  " Required:
  call dein#add('/Users/nagata/.cache/dein/./repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here like this:
  "call dein#add('Shougo/neosnippet.vim')
  "call dein#add('Shougo/neosnippet-snippets')
  call dein#add('tomasr/molokai')
  "call dein#add('nathanaelkane/vim-indent-guides')

  " # bundle
  " neobundle.vimを更新するための設定
  call dein#add('Shougo/neobundle.vim')

  " # lightline
  call dein#add('itchyny/lightline.vim')
  set laststatus=2

  " # vim indent guides
  call dein#add('nathanaelkane/vim-indent-guides')

  let g:indent_guides_enable_on_vim_startup = 1
  let g:indent_guides_auto_colors = 0
  autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
  autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4

  " # vim trailing whitespace
  call dein#add('bronson/vim-trailing-whitespace')
  if neobundle#tap('vim-trailing-whitespace')
    " uniteでスペースが表示されるので、設定でOFFにする
    let g:extra_whitespace_ignored_filetypes = ['unite']
  endif

  " # tcomment vim
  call dein#add('tomtom/tcomment_vim')

  " # emmet-vim
  call dein#add('mattn/emmet-vim')

  " # vim-css3-syntax
  call dein#add('hail2u/vim-css3-syntax')

  " # NERDtree
  call dein#add('scrooloose/nerdtree')

  " # Markdown
  call dein#add('tpope/vim-markdown')
  call dein#add('tyru/open-browser.vim')
  call dein#add('thinca/vim-quickrun')

  " # vimproc
  call dein#add('Shougo/vimproc.vim')

  " # vimshell
  call dein#add('Shougo/vimshell.vim')

  " # Editorconfig
  call dein#add('editorconfig/editorconfig-vim')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
"End dein Scripts-------------------------

