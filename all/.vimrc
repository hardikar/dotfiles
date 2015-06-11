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


" Show the position in the file
set ruler
" the cursor will briefly jump to the matching brace when you insert one
set showmatch
set matchtime=3

" Easier moving of code block
vnoremap < <gv
vnoremap > >gv
