" ---- Vundle ----

set nocompatible              " be iMproved, required
filetype off				  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-surround'
Plugin 'tmux-plugins/vim-tmux'
Plugin 'sheerun/vim-polyglot'
Plugin 'joshdick/onedark.vim'
Plugin 'Matt-Deacalion/vim-systemd-syntax'
Plugin 'rust-lang/rust.vim'

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

" ---- VIM Customizations ----
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set ruler
syntax on

" Color Settings
color onedark
set termguicolors

" Automatic settings based on filetypes.
autocmd FileType markdown,yaml,json set tabstop=2 shiftwidth=2
autocmd FileType markdown set tw=80
autocmd BufRead,BufNewFile *.conf setfiletype dosini
autocmd BufRead,BufNewFile *.tfvars setfiletype terraform
autocmd BufRead,BufNewFile Vagrantfile* setfiletype ruby

" Persistent Undos
set undodir=$HOME/.vim/undo
set undofile

" Delete comment character from joined lines.
set formatoptions+=j

" Enable mouse events.
set mouse=a
