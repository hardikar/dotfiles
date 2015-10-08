" .vimrc
" Author : Shreedhar Hardikar (hardikar@cs.wisc.edu)
"
" ================================================================================
" Initialize pathogen
" ================================================================================

" Install the pathogen VIM plugin manager
"" mkdir -p ~/.vim/autoload ~/.vim/bundle && \
"" curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
execute pathogen#infect()

" ================================================================================
" Basic options
" ================================================================================

" F*** vi
set nocompatible
set modelines=0

" Remember enough
set history=750
set undolevels=700

" Turn on syntax highlighting
syntax on

" Tab incantations
set autoindent " Indent according to the previous line automatically
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set expandtab       " tabs are spaces
set shiftwidth=4

" Turn on soft wrapping for text files
autocmd FileType text setlocal wrap linebreak

" General awesome features
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
set tildeop " Change case is now an operator

" Split settings
set splitbelow
set splitright

" Fancy line numbering
set relativenumber
set ruler " Show line numbers on the file
autocmd InsertEnter * :set number " Show the position in the file
autocmd InsertLeave * :set relativenumber " Shows relative positions to the current line

" Additional "bracket" types
set matchpairs=(:),{:},[:],<:>

" the cursor will briefly jump to the matching brace when you insert one
set showmatch
set matchtime=3

" Folding
set foldmethod=syntax

" Enable mouse selection whenever possible
set mouse=a

" Backups and swap files
" set nobackup
" set nowritebackup
set noswapfile
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" ================================================================================
" Status bar
" ================================================================================
set statusline=         " Empty status bar
set statusline=%n:      " Buffer number
set statusline+=%m\     " Modifiable flag
set statusline+=%F      " Full path of the file
set statusline+=%=      " left/right separator
set statusline+=%c,     " Cursor column
set statusline+=%l/%L   " Cursor line/total lines
set statusline+=\ %P    " Percent through file

" ================================================================================
" Vim theme : Enable wambat color
" curl -O http://www.vim.org/scripts/download_script.php?src_id=13400
" ================================================================================

set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors"
" set term=xterm-256color
set term=screen-256color " because tmux REALLY likes term=screen
color wombat256mod


" ================================================================================
" General Auto-commands
" ================================================================================

" resize splits once window is resized
autocmd VimResized * execute "normal! \<c-w>="

" ================================================================================
" Major remappings
" ================================================================================

let mapleader = " "

" Toggle spelling on/off
nnoremap <silent> <leader>s :set spell!<CR>

" Toggle invisibles
nnoremap <Leader>i :set list!<CR>

" Quick fix list traversal
nnoremap <silent> <leader>n :cnext<CR>
nnoremap <silent> <leader>N :cprevious<CR>

" Folding key bindings
nnoremap <Leader><Space> za
vnoremap <Leader><Space> za

" Save a million keystrokes
nnoremap ; :
cnoremap <C-;> <C-C>

" We just lost the power of ; so bring it back in another way
nnoremap : ,
" While we're at it, define , to redo the previous f,t command
nnoremap , ;

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

" Map emacs-like keys for moving to beginning/end of line
noremap <C-a> <Home>
noremap <C-e> <End>


" Mappings for command mode
cnoremap <C-A> <Home>
cnoremap <C-E> <End>

" Mappings home row keys
noremap H ^
noremap L $

" Setup a scroll lock so that j,k stay in the same place relative to the
" window
function! ToggleScrollLock()
    if exists("g:ScrollLock")
        unlet g:ScrollLock
        nnoremap j j
        nnoremap k k
    else
        let g:ScrollLock = 1
        nnoremap j <C-E>j
        nnoremap k <C-Y>k
    endif
endfunction
nnoremap <silent> <Leader>- :call ToggleScrollLock()<CR>


" Remap the cursor keys to something else
nnoremap <up>       :bp<CR>
nnoremap <down>     :bn<CR>
nnoremap <left>     :tabp<CR>
nnoremap <right>    :tabn<CR>

" Use python/perl regex, why learn another one?
nnoremap / /\v
vnoremap / /\v

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Don't move when pressing *
" nnoremap * *<C-O>

" Better navigating through omnicomplete option list
set completeopt=longest,menuone
" Limit the height of the menu
set pumheight=10

" A most standard IDE like keys
inoremap <expr><Tab> pumvisible() ? "\<C-N>" : "\<Tab>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-P>" : "\<S-Tab>"
inoremap <expr><C-J> pumvisible() ? "\<C-N>" : "\<C-J>"
inoremap <expr><C-K> pumvisible() ? "\<C-P>" : "\<C-K>"
inoremap <expr><Esc> pumvisible() ? "\<C-E>" : "\<Esc>"
inoremap <expr><CR> pumvisible() ? "\<C-Y>" : "\<CR>"


" ================================================================================
" Wildmenu settings
" ================================================================================
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.mp3,*.mp4,*.m4a                " other binary files
set wildignore+=*.pdf                            " other binary files
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit

set wildignore+=*.luac                           " Lua byte code

set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code

set wildignore+=*.orig                           " Merge resolution files

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


" syntastic for Pylint support
" cd ~/.vim/bundle && \
" git clone https://github.com/scrooloose/syntastic.git
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"let g:syntastic_error_symbol = "✗"
"let g:syntastic_warning_symbol = "⚠"

" Automatically close when no errors, but don't auto-open
let g:syntastic_auto_loc_list = 2
" But keep the list ready
let g:syntastic_always_populate_loc_list = 1

" When to run Syntastic
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

nnoremap <leader>p :SyntasticCheck<CR>
nnoremap <leader>P :SyntasticReset<CR>


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
noremap <C-n> :NERDTreeToggle<CR>
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


" ctrl-p plugin
" cd ~/.vim/bundle && \
" git clone https://github.com/kien/ctrlp.vim.git

" Enabling various ctrl-p extensions
" quickfix - searches in the quickfix window
" undo - searches the undo tree
" line - searches a line in the open buffers
" mixed - Default+Buffer+MRU combo
let g:ctrlp_extensions = ['mixed', 'line', 'quickfix', 'undo']

" Use prefixed count to determine the mode for ctrl-p
" 0 - Mixed mode
" 1 - Line mode
" 2 - Quickfix
" 3 - Undo
let g:ctrlp_cmd = 'exec "CtrlP".get(["Mixed", "Line", "QuickFix", "Undo"], v:count)'

" ================================================================================
" Finally
" ================================================================================

" Override general settings with system specific ones
if filereadable($HOME."/.local_vimrc")
    source ~/.local_vimrc
endif
