" Plugin options
call plug#begin('~/.vim/plugged')

Plug 'joshdick/onedark.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

" Visual options
syntax on
colorscheme onedark
set ruler

" Formatting options
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
autocmd FileType markdown set tw=80
set formatoptions+=j

" Undo options
set undodir=$HOME/.vim/undo
set undofile

" Interaction options
set mouse=a

" Functions
function! ToggleMouseOptions()
    if &mouse
        set mouse=a
        echom "Mouse enabled"
    else
        set mouse&
        echom "Mouse disabled"
    endif
endfunction

" Commands
nnoremap <silent> <C-f> :Rg<cr>
nnoremap <silent> <C-m> :call ToggleMouseOptions()<cr>
