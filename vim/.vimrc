" ==================================================
" Core settings
" Configure Vim editing, display, and persistence behavior.
" ==================================================

" Disable Vi compatibility when running Vim.
if !has('nvim')
  set nocompatible
endif

" Use UTF-8 internally and detect legacy Windows-encoded files.
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp932,default,latin1
if !has('nvim')
  scriptencoding utf-8
endif

" Load Vim's default configuration when running Vim.
if !has('nvim')
  unlet! skip_defaults_vim
  source $VIMRUNTIME/defaults.vim
endif

" Allow cursor movement to wrap across line boundaries.
set whichwrap=b,s,[,],<,>,~

" Disable mouse input.
set mouse=

" Use the macOS system clipboard for unnamed register operations when available.
if has('clipboard')
  set clipboard=unnamed
endif

" Ask before abandoning modified buffers.
set confirm

" Highlight search matches.
set hlsearch

" Ignore letter case unless the search pattern contains uppercase letters.
set ignorecase
set smartcase

" Highlight the current cursor line.
set cursorline

" Keep context visible above and below the cursor.
set scrolloff=4

" Preserve indentation when long lines wrap visually.
set breakindent

" Allow rectangular selections to extend beyond line endings.
set virtualedit=block

" Keep the diagnostic and Git sign column visible.
set signcolumn=yes

" Open standard horizontal and vertical splits below and to the right.
set splitbelow
set splitright

" Insert spaces when the Tab key is pressed.
set expandtab

" Use four-column tab stops.
set tabstop=4

" Preserve indentation when starting a new line in Vim.
if !has('nvim')
   set autoindent
endif

" Use four columns for automatic indentation.
set shiftwidth=4

" Use an absolute current line and relative surrounding line numbers.
set number
set relativenumber

" Enable syntax highlighting with the Molokai color scheme.
syntax on
colorscheme molokai
set t_Co=256

" Store swap files outside working directories.
if !isdirectory(expand("$HOME/.vim/swap"))
  call mkdir(expand("$HOME/.vim/swap"), "p")
endif
set directory=$HOME/.vim/swap//

" Persist undo history outside working directories.
set undofile
if !isdirectory(expand("$HOME/.vim/undo"))
  call mkdir(expand("$HOME/.vim/undo"), "p")
endif
set undodir=$HOME/.vim/undo

" Complete command-line entries with a longest-match menu.
set wildmenu
set wildmode=list:longest,full

" ==================================================
" Plugins
" Configure plugins managed by vim-plug.
" ==================================================

call plug#begin()

Plug 'itchyny/lightline.vim'
" Keep the status line visible and let lightline provide the mode indicator.
set laststatus=2
set noshowmode

Plug 'nathanaelkane/vim-indent-guides'
" Configure indent-guide startup behavior and colors.
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
augroup vimrc_indent_guides
  autocmd!
  autocmd VimEnter,ColorScheme * highlight IndentGuidesOdd guibg=red ctermbg=3
  autocmd VimEnter,ColorScheme * highlight IndentGuidesEven guibg=green ctermbg=4
augroup END

Plug 'bronson/vim-trailing-whitespace'
" Ignore Unite buffers because Unite renders spaces as part of its interface.
let g:extra_whitespace_ignored_filetypes = ['unite']

Plug 'tomtom/tcomment_vim'

Plug 'mattn/emmet-vim'

Plug 'hail2u/vim-css3-syntax'

Plug 'scrooloose/nerdtree'
" Display NERDTree bookmarks on startup.
" let NERDTreeShowBookmarks = 1
" Open NERDTree on startup.
" autocmd VimEnter * NERDTree

" Configure Markdown editing, browser integration, and command execution.
Plug 'tpope/vim-markdown'
Plug 'tyru/open-browser.vim'
Plug 'thinca/vim-quickrun'

Plug 'editorconfig/editorconfig-vim'

Plug 'leafgarland/typescript-vim'

Plug 'cespare/vim-toml'

Plug 'tpope/vim-unimpaired'

Plug 'easymotion/vim-easymotion'

Plug 'tpope/vim-fugitive'

Plug 'janko-m/vim-test'

Plug 'dense-analysis/ale'

" Configure Vim LSP support.
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

" Configure snippet support.
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

" Configure asynchronous LSP completion.
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

Plug 'cohama/lexima.vim'

Plug 'github/copilot.vim'

call plug#end()

" ==================================================
" Language Server Protocol
" Configure buffer-local LSP behavior and TypeScript servers.
" ==================================================

let g:lsp_format_sync_timeout = 1000

function! s:organize_imports_and_format_go() abort
  let l:servers = lsp#get_allowed_servers()

  if !empty(filter(copy(l:servers), 'lsp#capabilities#has_code_action_provider(v:val)'))
    LspCodeActionSync source.organizeImports
  endif

  if !empty(filter(copy(l:servers), 'lsp#capabilities#has_document_formatting_provider(v:val)'))
    LspDocumentFormatSync
  endif
endfunction

function! s:on_lsp_buffer_enabled() abort
  if &buftype ==# 'nofile' || &filetype =~# '^\(quickrun\)' || getcmdwintype() ==# ':'
    return
  endif

  setlocal omnifunc=lsp#complete

  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)

  if &filetype ==# 'go'
    augroup vimrc_lsp_go_save
      autocmd! BufWritePre <buffer>
      autocmd BufWritePre <buffer> call s:organize_imports_and_format_go()
    augroup END
  endif
endfunction

" Configure fenced TypeScript blocks and available language servers.
let g:markdown_fenced_languages = ['ts=typescript']
let g:lsp_settings_filetype_typescript = ['typescript-language-server', 'eslint-language-server', 'deno']

augroup vimrc_lsp_install
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
