" Tab incantations
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set expandtab       " tabs are spaces
set shiftwidth=4

" Rust syntax highlighting
filetype indent on 
au BufNewFile,BufRead *.rs set filetype=rust

" Turn on syntax highlighting
syntax on
set autoindent 


" General awesome features
set ruler " Show the position in the file
set number " Show line numbers on the side
set ignorecase " Ignore cases while searching
set smartcase " /The matches only The but /the matches both The and the
set incsearch " Show the next matching thing right away

" the cursor will briefly jump to the matching brace when you insert one
set showmatch
set matchtime=3

" Easier moving of code block
vnoremap < <gv
vnoremap > >gv


" Enable wambat color
"" curl -O http://www.vim.org/scripts/download_script.php?src_id=13400
set term=xterm-256color
color wombat256mod

" Remember enough
set history=750
set undolevels=700

" Install the pathogen VIM plugin manager
"" mkdir -p ~/.vim/autoload ~/.vim/bundle && \
"" curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
execute pathogen#infect()

" ================================================================================
" VIM plugins
" ================================================================================
let mapleader = " "

" Python IDE - Jedi VIM
"" cd ~/.vim/bundle/ && git clone --recursive https://github.com/davidhalter/jedi-vim.git
let g:jedi#usages_command = "<leader>u"
let g:jedi#rename_command = "<leader>r"
let g:jedi#goto_command = "<leader>g"
let g:jedi#goto_assignments_command = "<leader>a"
let g:jedi#goto_definitions_command = "<leader>d"
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0

" Better navigating through omnicomplete option list
"" See http://stackoverflow.com/questions/2170023/how-to-map-keys-for-popup-menu-in-vim
set completeopt=longest,menuone
function! OmniPopup(action)
    if pumvisible()
        if a:action == 'j'
            return "\<C-N>"
        elseif a:action == 'k'
            return "\<C-P>"
        endif
    endif
    return a:action
endfunction

inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>


" syntastic for Pylint support
" cd ~/.vim/bundle && \
" git clone https://github.com/scrooloose/syntastic.git
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

nnoremap <leader>p :SyntasticCheck<CR>
nnoremap <leader>P :SyntasticToggleMode<CR>
