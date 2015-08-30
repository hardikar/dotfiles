" F*** vi
set nocompatible
set modelines=0
" Tab incantations
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set expandtab       " tabs are spaces
set shiftwidth=4

" Turn on syntax highlighting
syntax on
set autoindent 

" Turn on soft wrapping for text files
autocmd FileType text setlocal wrap linebreak

" General awesome features
set ruler " Show line numbers on the file
set ignorecase " Ignore cases while searching
set smartcase " /The matches only The but /the matches both The and the
set incsearch " Show the next matching thing right away
set gdefault  " Set global by default for substitute. Use g for local

set showmode " Show current mode on the last line when in insert/visual etc
set showcmd " Show's the current command at the bottom right corner
set hidden " Opening a new file when the current buffer has unsaved changes causes files to be hidden instead of closed
set wildmenu " Command mode completion
set cursorline " Highlight the screen line of the cursor
set ttyfast " Fast terminal connection
set backspace=indent,eol,start " Allow backspace over autoindent, eol, start
set laststatus=2 " Always have a status line on

" Automatically save a file going away
autocmd FocusLost * :wa

set relativenumber 
autocmd InsertEnter * :set number " Show the position in the file
autocmd InsertLeave * :set relativenumber " Shows relative positions to the current line


" resize splits once window is resized
autocmd VimResized * execute "normal! \<c-w>="

" Enable mouse selection whenever possible
set mouse=a

" the cursor will briefly jump to the matching brace when you insert one
set showmatch
set matchtime=3

" Enable wambat color
" curl -O http://www.vim.org/scripts/download_script.php?src_id=13400
set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors"
" set term=xterm-256color
set term=screen-256color " because tmux REALLY likes term=screen
color wombat256mod

" Remember enough
set history=750
set undolevels=700

" Install the pathogen VIM plugin manager
"" mkdir -p ~/.vim/autoload ~/.vim/bundle && \
"" curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
execute pathogen#infect()

" Backups and swap files
" set nobackup
" set nowritebackup
set noswapfile
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Status bar
set statusline=         " Empty status bar
set statusline=%n:      " Buffer number
set statusline+=%m\     " Modifiable flag
set statusline+=%F      " Full path of the file
set statusline+=%=      " left/right separator
set statusline+=%c,     " Cursor column
set statusline+=%l/%L   " Cursor line/total lines
set statusline+=\ %P    " Percent through file


" ================================================================================
" Major remappings
" ================================================================================

let mapleader = " "

" Toggle spelling on/off
nmap <silent> <leader>s :set spell!<CR>

" Toggle invisibles
noremap <Leader>i :set list!<CR>

" Quick fix list traversal
nnoremap <silent> <leader>] :cnext<CR>
nnoremap <silent> <leader>[ :cprevious<CR>


" Save a million keystrokes
nnoremap ; :
cnoremap <C-;> <C-C>

" Easier moving of code block
vnoremap < <gv
vnoremap > >gv

" Remap tab to % for matching parentheses etc
vnoremap <tab> %
nnoremap <tab> %

" Ignore F1
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Re-map q to just try and quit
" nnoremap q :q<CR>

" Map emacs-like keys for moving to beginning/end of line
noremap <C-a> <Home>
noremap <C-e> <End>


" Mappings for command mode
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-L> <Right>
cnoremap <C-H> <Left>
cnoremap <C-J> <Down>
cnoremap <C-K> <Up>

" Mappings home row keys
noremap H ^
noremap L $

nnoremap <up>       :bp<CR>
nnoremap <down>     :bn<CR>
nnoremap <left>     :tabp<CR>
nnoremap <right>    :tabn<CR>

" Use python/perl regex, why learn another one?
nnoremap / /\v
vnoremap / /\v

" ================================================================================
" VIM plugins
" ================================================================================

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


" Settings for vim-notes plugin
" cd ~/.vim/bundle && \
" git clone https://github.com/xolox/vim-misc.git && \
" git clone https://github.com/xolox/vim-notes.git
let g:notes_directories = ['~/notes']
let g:notes_smart_quotes = 0
let g:notes_suffix = '.md'
let g:notes_list_bullets = ['-', '*', '->', '+']

" Limit notes to auto-indent for notes filetype
autocmd FileType notes setlocal textwidth=120


" Settings for nerdtree plugin
" cd ~/.vim/bundle && \
" git clone https://github.com/scrooloose/nerdtree.git
noremap <Leader>n :NERDTreeToggle<CR>
" Close vim if NERDTree is the only remaining window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" Show current file in NERDTree
map <silent> <Leader>m :NERDTreeFind<CR>


" Setting for VimOrganizer plugin
au! BufRead,BufWrite,BufWritePost,BufNewFile *.org 
au BufEnter *.org            call org#SetOrgFileType()
let g:org_capture_file = '~/notes/org_files/mycaptures.org'
command! OrgCapture :call org#CaptureBuffer()
command! OrgCaptureFile :call org#OpenCaptureFile()

let g:org_todo_setup='TODO STARTED PENDING | DONE CANCELLED'
let g:org_agenda_select_dirs=["~/notes/org_files"]
let g:org_agenda_files = split(glob("~/notes/org_files/org-mod*.org"),"\n")

" OrgCustomColors() allows a user to set highlighting for particular items
function! OrgCustomColors()
"    let g:org_todo_custom_highlights = 
"               \     { 'NEXT': { 'guifg':'#888888', 'guibg':'#222222',
"               \              'ctermfg':'gray', 'ctermbg':'darkgray'},
"               \      'WAITING': { 'guifg':'#aa3388', 
"               \                 'ctermfg':'red' } }
endfunction


" Settings for vimux plugin
" cd ~/.vim/bundle && \
" git clone https://github.com/benmills/vimux.git
nnoremap <Leader>tp :VimuxPromptCommand<CR>
nnoremap <Leader>tl :VimuxRunLastCommand<CR>
" This will either open a new pane or use the nearest pane and set it as the
" vimux runner pane for the other vimux commands. You can control if this command
" uses the nearest pane or always creates a new one with g:VimuxUseNearest
nnoremap <Leader>to :VimuxOpenPane<CR>
nnoremap <Leader>tq :VimuxCloseRunner<CR>
nnoremap <Leader>tc :VimuxInterruptRunner<CR>
nnoremap <Leader>vz :VimuxZoomRunner<CR>
" map <Leader>rb :call VimuxRunCommand("clear; rspec " . bufname("%"))<CR>


" ================================================================================
" Finally
" ================================================================================

" Override general settings with system specific ones
if filereadable($HOME."/.local_vimrc")
    source ~/.local_vimrc
endif
