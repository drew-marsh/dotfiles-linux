" ~/.vimrc
set nocompatible
filetype plugin indent on
syntax on

" UI
set number relativenumber
set cursorline
set showcmd
set showmatch
set laststatus=2
set ruler
set wildmenu
set wildmode=longest:full,full
set scrolloff=5
set sidescrolloff=5
set signcolumn=auto
set belloff=all
set background=dark

" Editing
set expandtab
set tabstop=4 shiftwidth=4 softtabstop=4
set autoindent smartindent
set backspace=indent,eol,start
set nowrap
set hidden
set mouse=a
set encoding=utf-8
set list listchars=tab:»\ ,trail:·,nbsp:␣

" Search
set incsearch hlsearch
set ignorecase smartcase

" Files: keep swap/undo/backup out of working dirs
let s:state = expand('~/.local/state/vim')
for s:d in ['swap', 'undo', 'backup']
  if !isdirectory(s:state . '/' . s:d) | call mkdir(s:state . '/' . s:d, 'p', 0700) | endif
endfor
let &directory = s:state . '/swap//'
let &undodir   = s:state . '/undo//'
let &backupdir = s:state . '/backup//'
set undofile
set autoread

" Splits open below/right
set splitbelow splitright

" Keys
let mapleader = ' '
nnoremap <leader><space> :nohlsearch<CR>
nnoremap <leader>w :w<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
vnoremap < <gv
vnoremap > >gv

" Per-filetype indentation
autocmd FileType yaml,json,javascript,typescript,html,css,sh,zsh,lua setlocal ts=2 sw=2 sts=2
autocmd FileType make setlocal noexpandtab

" Return to last edit position
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
