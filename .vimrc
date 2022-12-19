" Plugin options
call plug#begin('~/.vim/plugged')

Plug 'NLKNguyen/papercolor-theme'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

" Visual options
set ruler
set background=dark
colorscheme PaperColor

" Formatting options
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set formatoptions+=j

autocmd FileType markdown set tw=80
autocmd FileType yaml set tabstop=2 shiftwidth=2
autocmd FileType nix set tabstop=2 shiftwidth=2

" Interaction options
set mouse=a

" Variables
let g:mouse_enable = 1

" Functions
function! ToggleMouseOptions()
    if g:mouse_enable
        set mouse&
        let g:mouse_enable = 0
        echom "Mouse disabled"
    else
        set mouse=a
        let g:mouse_enable = 1
        echom "Mouse enabled"
    endif
endfunction

" Commands
nnoremap <silent> <C-m> :call ToggleMouseOptions()<cr>
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
