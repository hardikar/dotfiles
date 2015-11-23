" .vimrc
" Author : Shreedhar Hardikar (hardikar@cs.wisc.edu)
"
" Initializations --------------------------------------------------------- {{{
" =============================================================================

" Vim Plugin Manager {{{
" Install the vim-plug VIM plugin manager
"    mkdir -p ~/.vim/autoload ~/.vim/bundle && \
"    curl -LSso ~/.vim/autoload/pathogen.vim \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

" Hacky check to see if a plugin exists using g:plugs which is set up by
" the vim-plug plugin manager
function! Plugin_exists(name)
    return has_key(g:plugs, a:name) && isdirectory(g:plugs[a:name]['dir'])
endfunction

call plug#begin('~/.vim/bundle')

Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdtree'
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/syntastic'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'tpope/vim-fugitive'
Plug 'xolox/vim-misc' | Plug 'xolox/vim-notes'
Plug 'junegunn/vim-peekaboo'

" Add plugins to &runtimepath
call plug#end()

" }}}

" Map leader early on, so that all future mappings succeed
let mapleader = " "

" }}}

" Basic options ----------------------------------------------------------- {{{
" =============================================================================

" set term=xterm-256color
" set term=screen-256color " because tmux REALLY likes term=screen

" F*** vi
set nocompatible " Must be the first line
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
" Auto-fold everything above fold level 5
set foldlevel=5

" Folding key bindings
nnoremap <Tab> za
vnoremap <Tab> za

" Focus mode that auto-folds all other folds
nnoremap <leader>z zMzvzz

" }}}

" General Auto-commands --------------------------------------------------- {{{
" =============================================================================

" resize splits once window is resized
autocmd VimResized * execute "normal! \<c-w>="

" }}}

" Major Mappings ---------------------------------------------------------- {{{
" =============================================================================

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

" Select entire buffer
nnoremap vaa ggvGg_

" Easier moving of code block
vnoremap < <gv
vnoremap > >gv

" Select (charwise) the contents of the current line, excluding indentation.
" Great for pasting Python lines into REPLs.
nnoremap <leader>v ^<C-v>g_

" Justify current paragraph with current wrap
nnoremap Q gqip

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

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

" Search for the word under the cursor in the current file and open a quickfix
" window
nnoremap <leader>* :execute 'noautocmd vimgrep /'.expand("<cword>").'/g %'<CR>:copen<CR>

" Set up a command to search for any word in the directory
nnoremap <leader>/ :noautocmd vimgrep  **<left><left><left>

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
inoremap <expr><CR>    pumvisible() ? "\<C-Y>" : "\<CR>"

" C-C to fast escape from insert mode
inoremap <C-c> <ESC>

" Insert Mode Completion {{{
" :help ins-completion
inoremap <c-f> <c-x><c-f>
" Because on the terminal, <C-space> becomes <C-@>
imap <c-@> <c-Space>
inoremap <c-Space> <c-x><c-o>

" inoremap <c-]> <c-x><c-]>
" inoremap <c-l> <c-x><c-l>

" }}}

" }}}

" Wildmenu settings ------------------------------------------------------- {{{
" =============================================================================

set wildmenu              " Command mode completion
set wildmode=longest:full " complete till longest common string and start
                          " wildmenu

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

" Because the default <Tab> doesn't work
set wildcharm=<C-Z>
cnoremap <expr><Tab>     wildmenumode() ? "\<C-N>" : "\<C-Z>"
cnoremap <expr><S-Tab>   wildmenumode() ? "\<C-P>" : "\<C-Z>"
" }}}

" }}}

" VIM plugin settings ----------------------------------------------------- {{{
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
if Plugin_exists('syntastic')
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

    " Systastic check for python - maybe set this as an autocmd?
    let g:syntastic_python_checkers = ['python', 'pylint']
    let g:syntastic_python_pylint_quiet_messages = { "level": "warnings" }

    nnoremap <leader>p :SyntasticCheck<CR>
    nnoremap <leader>P :SyntasticReset<CR>
endif
" }}}
" NERDTree  {{{
" cd ~/.vim/bundle && \
" git clone https://github.com/scrooloose/nerdtree.git
if Plugin_exists('nerdtree')
    " Quit Nerd tree on opening a file
    let NERDTreeQuitOnOpen=1

    noremap <C-n> :NERDTreeToggle<CR>

    " Close vim if NERDTree is the only remaining window
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
    " Show current file in NERDTree
    noremap <silent> <Leader>m :NERDTreeFind<CR>
endif
" }}}
" Vim Notes  {{{
let g:notes_directories = ['~/notes']
let g:notes_suffix = '.md'

" Automatically change the title to match the filename
let g:notes_title_sync = 'change_title'

" Don't do fancy substitutions
let g:notes_smart_quotes = 0
let g:notes_list_bullets = ['*', '-', '+']

" Tab indents/dedent list items in insert mode
let g:notes_tab_indents = 1

" Don't conceal anything
let g:notes_conceal_code = 0
let g:notes_conceal_italic = 0
let g:notes_conceal_bold = 0
let g:notes_conceal_url = 0

" Modify highlighting
hi link notesListNumber markdownListMarker
hi link notesListBullet markdownListMarker

hi link notesItalic markdownUrl
hi link notesBold markdownBold
hi link notesTextURL markdownListMarker
hi link notesRealURL markdownListMarker
hi link notesUnixPath Directory
hi link notesPathLnum Directory

hi def link notesSingleQuote String
hi def link notesDoubleQuote String

hi link notesTitle Title
hi link notesShortHeading markdownId
hi link notesBlockQuote String

function! NotesHighlightTitleLevels()
    " TODO Update the regexes in the original plugin
    syntax match notesAtxHeading1 /^\s*#.*/ contains=notesAtxMarker,@notesInline
    syntax match notesAtxHeading2 /^\s*##.*/ contains=notesAtxMarker,@notesInline
    syntax match notesAtxHeading3 /^\s*###.*/ contains=notesAtxMarker,@notesInline
    syntax match notesAtxHeading4 /^\s*####.*/ contains=notesAtxMarker,@notesInline
    syntax match notesAtxHeading5 /^\s*#####.*/ contains=notesAtxMarker,@notesInline

    hi def notesAtxHeading1 term=bold cterm=bold ctermfg=192
    hi def notesAtxHeading2 term=bold cterm=bold ctermfg=222
    hi def notesAtxHeading3 term=bold cterm=bold ctermfg=173
    hi def notesAtxHeading4 term=bold cterm=bold ctermfg=35
    hi def notesAtxHeading5 term=bold cterm=bold ctermfg=184
endfunction
function! NotesHighlightStrings()
    syntax match notesSingleQuoted /\w\@<!'.\{-}'\w\@!/
    syntax match notesDoubleQuoted /\w\@<!".\{-}"\w\@!/
endfunction
function! NotesSetupCustomHighlighting()
    if &ft == 'notes'
        call NotesHighlightTitleLevels()
        call NotesHighlightStrings()
    endif
endfunction
autocmd VimEnter,BufEnter,BufNewFile * :call NotesSetupCustomHighlighting()

" Open NotesStash for a quicknote
command NotesStash :Note Notes Stash

" }}}
" CTRL-P  {{{
" cd ~/.vim/bundle && \
" git clone https://github.com/kien/ctrlp.vim.git
if Plugin_exists('ctrlp.vim')
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
endif
" }}}
" Buffergator  {{{
" git clone https://github.com/jeetsukumaran/vim-buffergator
if Plugin_exists('vim-buffergator')
    let g:buffergator_viewport_split_policy = "B"
    let g:buffergator_hsplit_size = 10

    " Suppress the standard key maps
    let g:buffergator_suppress_keymaps = 1
    nnoremap <Leader>b :BuffergatorToggle<CR>
endif
" }}}

" }}}

" Filetype settings ------------------------------------------------------- {{{
" =============================================================================

" Turn on syntax highlighting
syntax on

" Turn on soft wrapping for text files
autocmd FileType text setlocal wrap linebreak

" Java {{{

augroup ft_java
    au!
    au FileType java setlocal foldmethod=marker
    au FileType java setlocal foldmarker={,}
augroup END
" }}}

" }}}

" Break bad habits -------------------------------------------------------- {{{
" =============================================================================

" Trailing Whitespace {{{
" Mark trailing white space, except when typing at the end of the line
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

" Clear trailing whitespace
nnoremap <leader>w :%s/\s\+$//<CR>

" }}}

" Remap the cursor keys to something else
nnoremap <up>       <Nop>
nnoremap <down>     <Nop>
nnoremap <left>     <Nop>
nnoremap <right>    <Nop>

" }}}

" NVIM settings ----------------------------------------------------------- {{{
" =============================================================================
if has('nvim')
    tnoremap <Esc> <C-\><C-n>
endif
" }}}

" Finally ----------------------------------------------------------------- {{{
" =============================================================================

" Override general settings with system specific ones
if filereadable($HOME."/.local_vimrc")
    source ~/.local_vimrc
endif
" }}}

