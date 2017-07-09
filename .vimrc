set tabstop=4 	 " I like having 4 spaces and not 8
set shiftwidth=4 " Set shift size.
syntax on		 " Syntax highlighting

:color desert	 " Color schema for vim that doesn't suck.

" ---- Vundle Stuff ----

set nocompatible              " be iMproved, required
filetype off				  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
" Plugins:
Plugin 'chr4/nginx.vim'
Plugin 'tpope/vim-surround'
Plugin 'tmux-plugins/vim-tmux'
Plugin 'dracula/vim'
