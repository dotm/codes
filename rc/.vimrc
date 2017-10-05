" Turn off vi compatibility
set nocompatible

" Turn backup off
set nobackup
set nowb
set noswapfile

" Line number
set relativenumber number

" Paste toggle shortcut
set pastetoggle=<F2>

" Search highlighting
set hlsearch

" Indenting
set smartindent
set autoindent
" load indent file for current filetype
filetype indent on
set tabstop=2 shiftwidth=2 expandtab

syntax on
colorscheme murphy

" vimplug
call plug#begin()
Plug 'https://github.com/moll/vim-node'
call plug#end()
