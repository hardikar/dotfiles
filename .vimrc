" .vimrc
" Author : Shreedhar Hardikar (hardikar@cs.wisc.edu)
"
" Initializations --------------------------------------------------------- {{{
" =============================================================================

" Install the pathogen VIM plugin manager
"" mkdir -p ~/.vim/autoload ~/.vim/bundle && \
"" curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
execute pathogen#infect()

" }}}

" Basic options ----------------------------------------------------------- {{{
" =============================================================================

" set term=xterm-256color
set term=screen-256color " because tmux REALLY likes term=screen

" F*** vi
set nocompatible
set modelines=0

" Remember enough
set history=750
set undolevels=700

" Tab incantations
set autoindent      " Indent according to the previous line automatically
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set expandtab       " tabs are spaces
set shiftwidth=4

" Search settings
set ignorecase " Ignore cases while searching
set smartcase  " /The matches only The but /the matches both The and the
set incsearch  " Show the next matching thing right away

" General
set cursorline                 " Highlight the screen line of the cursor
set ttyfast                    " Fast terminal connection
set backspace=indent,eol,start " Allow backspace over autoindent, eol, start
set tildeop                    " Change case is now an operator
set hidden                     " Opening a new file when the current buffer 
                               " has unsaved changes " causes files to be hidden
                               " instead of closed

" Split settings
set splitbelow
set splitright

" Backups and swap files
" set nobackup
" set nowritebackup
set noswapfile
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Fancy line numbering
set relativenumber  " Show line numbers relative to current line
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

" Brackets while editing
set matchpairs=(:),{:},[:],<:>   " Additional "bracket" types
" the cursor will briefly jump to the matching brace when you insert one
set showmatch
set matchtime=3

" Enable mouse selection whenever possible
set mouse=a

" }}}

" Color Theme ------------------------------------------------------------- {{{
" =============================================================================

" Explicitly tell vim that the terminal supports 256 colors"
set t_Co=256
" Vim theme : Enable wambat color
" curl -O http://www.vim.org/scripts/download_script.php?src_id=13400
color wombat256mod

" }}}

" Status bar -------------------------------------------------------------- {{{
" =============================================================================

" Verbose status
set showmode     " Show current mode on the last line when in insert/visual etc
set showcmd      " Show's the current command at the bottom right corner
set laststatus=2 " Always have a status line on
set report=0     " Always report the number of lines yanked/deleted etc

set statusline=          " Empty status bar
set statusline=%n:       " Buffer number
set statusline+=%m\      " Modifiable flag
set statusline+=%F       " Full path of the file
set statusline+=%=       " left/right separator
set statusline+=%l,      " Cursor line
set statusline+=%c\      " Cursor column
set statusline+=\|\ %L   " Cursor line/total lines
set statusline+=\ (%P)   " Percent through file

" }}}

" Folding ----------------------------------------------------------------- {{{
" =============================================================================

set foldmethod=marker
" Auto-fold everything above fold level 10
set foldlevel=10

" Folding key bindings
nnoremap <Tab> za
vnoremap <Tab> za

" }}}

" General Auto-commands --------------------------------------------------- {{{
" =============================================================================

" resize splits once window is resized
autocmd VimResized * execute "normal! \<c-w>="

" }}}

" Major Mappings ---------------------------------------------------------- {{{
" =============================================================================

let mapleader = " "

" Toggle spelling on/off
nnoremap <silent> <leader>s :set spell!<CR>

" Toggle invisibles
nnoremap <silent> <Leader>i :set list!<CR>

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

" Ignore F1
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Movement  {{{
" Map emacs-like keys for moving to beginning/end of line
nnoremap <C-a> <Home>
nnoremap <C-e> <End>

" Mappings for command mode
cnoremap <C-A> <Home>
cnoremap <C-E> <End>

" Mappings home row keys
noremap H ^
noremap L $

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv
" }}}

" ScrollLock {{{
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
" }}}
" QuickFix list mappings  {{{
" Quick fix list traversal
nnoremap <silent> <leader>n :cnext<CR>
nnoremap <silent> <leader>N :cprevious<CR>

function! ToggleQuickFix()
    if exists("g:QuickfixWindowOpen")
        unlet g:QuickfixWindowOpen
        cclose
    else
        let g:QuickfixWindowOpen = 1
        copen
    endif
endfunction
nnoremap <silent> <Leader>q :call ToggleQuickFix()<CR>
" }}}
" Omnicomplete navigation {{{

" Better navigating through omnicomplete option list
set completeopt=longest,menuone
" Limit the height of the menu
set pumheight=10

" A most standard IDE like keys
inoremap <expr><Tab>   pumvisible() ? "\<C-N>" : "\<Tab>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-P>" : "\<S-Tab>"
inoremap <expr><C-J>   pumvisible() ? "\<C-N>" : "\<C-J>"
inoremap <expr><C-K>   pumvisible() ? "\<C-P>" : "\<C-K>"
inoremap <expr><Esc>   pumvisible() ? "\<C-E>" : "\<Esc>"
inoremap <expr><CR>    pumvisible() ? "\<C-Y>" : "\<CR>"
" }}}

" }}}

" Wildmenu settings ------------------------------------------------------- {{{
" =============================================================================

set wildmenu   " Command mode completion
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

" }}}

" VIM plugins ------------------------------------------------------------- {{{
" =============================================================================

" Python IDE - Jedi VIM  {{{
"" cd ~/.vim/bundle/ && git clone --recursive https://github.com/davidhalter/jedi-vim.git
let g:jedi#usages_command = "<leader>u"
let g:jedi#rename_command = "<leader>r"
let g:jedi#goto_command = "<leader>g"
let g:jedi#goto_assignments_command = "<leader>a"
let g:jedi#goto_definitions_command = "<leader>d"
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
" }}}
" Syntastic  {{{
" cd ~/.vim/bundle && \
" git clone https://github.com/scrooloose/syntastic.git
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Automatically close when no errors, but don't auto-open
let g:syntastic_auto_loc_list = 2
" But keep the list ready
let g:syntastic_always_populate_loc_list = 1

" When to run Syntastic
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

nnoremap <leader>p :SyntasticCheck<CR>
nnoremap <leader>P :SyntasticReset<CR>
" }}}
" NERDTree  {{{
" cd ~/.vim/bundle && \
" git clone https://github.com/scrooloose/nerdtree.git
noremap <C-n> :NERDTreeToggle<CR>
" Close vim if NERDTree is the only remaining window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" Show current file in NERDTree
map <silent> <Leader>m :NERDTreeFind<CR>
" }}}
" VimOrganizer  {{{
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
" }}}
" CTRL-P  {{{
" cd ~/.vim/bundle && \
" git clone https://github.com/kien/ctrlp.vim.git
let g:ctrlp_map = '<Leader><Space>'

" 'r' - the nearest ancestor that contains one of these directories or files:
" .git .hg .svn .bzr _darcs
" 'a' - directory of current file, but only if the current working directory outside of CtrlP is
" not a direct ancestor
let g:ctrlp_working_path_mode = 'ra'

" Enabling various ctrl-p extensions
" quickfix - searches in the quickfix window
" undo - searches the undo tree
" line - searches a line in the open buffers
" mixed - Default+Buffer+MRU combo
let g:ctrlp_extensions = ['mixed', 'line', 'quickfix', 'undo']

" Use prefixed count to determine the mode for ctrl-p
" 0 - Last Mode
" 1 - Mixed mode
" 2 - Line mode
" 3 - Quickfix
" 4 - Undo
let g:ctrlp_cmd = 'exec "CtrlP".get(["LastMode", "Mixed", "Line", "QuickFix", "Undo"], v:count)'

" }}}
" Buffergator  {{{
" git clone https://github.com/jeetsukumaran/vim-buffergator
let g:buffergator_viewport_split_policy = "B"
let g:buffergator_hsplit_size = 10

" Suppress the standard key maps
let g:buffergator_suppress_keymaps = 1
nnoremap <Leader>b :BuffergatorToggle<CR>
" }}}

" }}}

" Filetype settings ------------------------------------------------------- {{{
" =============================================================================

" Turn on syntax highlighting
syntax on

" Turn on soft wrapping for text files
autocmd FileType text setlocal wrap linebreak

" }}}

" Break bad habits -------------------------------------------------------- {{{
" =============================================================================

" Remap the cursor keys to something else
nnoremap <up>       <Nop>
nnoremap <down>     <Nop>
nnoremap <left>     <Nop>
nnoremap <right>    <Nop>

" }}}

" Finally ----------------------------------------------------------------- {{{
" =============================================================================

" Override general settings with system specific ones
if filereadable($HOME."/.local_vimrc")
    source ~/.local_vimrc
endif
