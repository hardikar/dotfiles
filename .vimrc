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

" Navigation plugins
Plug 'scrooloose/nerdtree'
Plug 'hardikar/ctrlp.vim', {'branch': 'cscope'}
Plug 'jeetsukumaran/vim-buffergator'
Plug 'junegunn/vim-peekaboo'

" Productivity plugins
Plug 'xolox/vim-misc' | Plug 'xolox/vim-notes'
Plug 'mtth/scratch.vim'
Plug 'tpope/vim-dispatch'
Plug 'SirVer/ultisnips'
Plug 'jszakmeister/vim-togglecursor'
Plug 'jaxbot/semantic-highlight.vim'
Plug 'airblade/vim-gitgutter'

" Language plugins
Plug 'rust-lang/rust.vim'
"Plug 'Superbil/llvm.vim'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'derekwyatt/vim-scala'
Plug 'tfnico/vim-gradle'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'hari-rangarajan/CCTree'
Plug 'Valloric/YouCompleteMe', {
  \ 'do': './install.py --clang-completer --system-libclang'
  \ }

" Color scheme plugins
Plug 'jonathanfilip/vim-lucius'
Plug 'NLKNguyen/papercolor-theme'
Plug 'flazz/vim-colorschemes'
Plug 'w0ng/vim-hybrid'

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

" Don't allow mappings that start with <Esc>
set noesckeys

" Easy toggling insert modes
set pastetoggle=<F6>

" }}}

" Color Theme ------------------------------------------------------------- {{{
" =============================================================================

" Explicitly tell vim that the terminal supports 256 colors"
set t_Co=256
" Vim theme : Enable wambat color
" curl -O http://www.vim.org/scripts/download_script.php?src_id=13400

let g:colors = ["hybrid", "wombat256mod", "PaperColor"]
nnoremap <F12> :ColorsNext<CR>:echo g:colors_name<CR>

" Status line changes on mode changes
if version > 700
    hi link StatusLineInsert PMenuSel
    hi link StatusLineNormal StatusLine
    " Change colors when intering INSERT MODE
    autocmd InsertEnter * hi! link StatusLine StatusLineInsert
    autocmd InsertLeave * hi! link StatusLine StatusLineNormal
endif

" Setup fonts
if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 12
  elseif has("gui_macvim")
    set guifont=Inconsolata:h14
  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI
  endif
endif

" }}}

" Status bar -------------------------------------------------------------- {{{
" =============================================================================

" Verbose status
set showmode     " Show current mode on the last line when in insert/visual etc
set showcmd      " Show's the current command at the bottom right corner
set laststatus=2 " Always have a status line on
set report=0     " Always report the number of lines yanked/deleted etc

set statusline=          " Empty status bar
set statusline+=%n:      " Buffer number
set statusline+=%m\      " Modifiable flag
set statusline+=%F       " Full path of the file
set statusline+=%=       " left/right separator
set statusline+=%l,      " Cursor line
set statusline+=%c\      " Cursor column
set statusline+=\|\      " Seperator
set statusline+=%L       " Cursor line/total lines
set statusline+=\ (%P)   " Percent through file

" }}}

" MakeIDE ----------------------------------------------------------------- {{{
" =============================================================================

function! MakeIDE()
if has("cscope")
    " Ask user if he wants to make a cscope database
    function! CscopeConfirmCreateLoad(cscope_out)
        if confirm(a:cscope_out . " not found. Create and load now?", "y\nN", 1) == 1
            call system("find . -name '*.c' -o -name '*.h' -o -name '*.cpp' -o -name '*.cc' > cscope.files")
            call system("cscope -bq")
            exec("cscope add " . a:cscope_out)
        endif
    endfunction

    " Pick up any cscope database in current directory
    if filereadable("cscope.out")
        cscope add cscope.out
    elseif $CSCOPE_DB != "" && filereadable($CSCOPE_DB)
        cscope add $CSCOPE_DB
    else
        call CscopeConfirmCreateLoad("cscope.out")
    endif

    " Ask user if he wants to load the XRef database
    function! CCTreeConfirmLoad(cctree_out)
        if confirm("Found " . a:cctree_out . ". Load now?", "y\nN", 1) == 1
            exec("CCTreeLoadXRefDB " . a:cctree_out)
        endif
    endfunction

    " Ask user if he wants to create and load the XRef database
    function! CCTreeConfirmLoadCreate(cscope_out, cctree_out)
        if confirm("Found " . a:cscope_out . ", but no cctree.out. Create and load now?", "y\nN", 2) == 1
            exec("CCTreeLoadDB " . a:cscope_out)
            exec("CCTreeSaveXRefDB " . a:cctree_out)
        endif
    endfunction

    " Pick up any cctree database in current directory
    if filereadable("cctree.out")
        call CCTreeConfirmLoad("cctree.out")
    elseif $CCTREE_DB != ""
        call CCTreeConfirmLoad($CCTREE_DB)
    " or create one if cscope.out is found
    elseif filereadable("cscope.out")
        call CCTreeConfirmLoadCreate("cscope.out", "cctree.out")
    elseif $CSCOPE_DB != ""
        call CCTreeConfirmLoadCreate($CSCOPE_DB, "cctree.out")
    endif
endif
endfunction

command! IDE call MakeIDE()

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

" Silence output to prevent displaying "Press a Key to continue"
command! -nargs=1 SilentExec execute ':silent !'.<q-args> | execute ':redraw!'


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

" Movement  {{{
" Map emacs-like keys for moving to beginning/end of line
nnoremap <C-a> <Home>
nnoremap <C-e> <End>

" Mappings for command mode
cnoremap <C-A> <Home>
cnoremap <C-E> <End>

" Mappings for insert mode
inoremap <C-A> <Home>
inoremap <C-E> <End>

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
set wildignore+=*.class,*.jar,.gradle            " Java garbage
set wildignore+=*/build/*,*/build-eclipse/*      " Build directories

" Because the default <Tab> doesn't work
set wildcharm=<C-Z>
cnoremap <expr><Tab>     wildmenumode() ? "\<C-N>" : "\<C-Z>"
cnoremap <expr><S-Tab>   wildmenumode() ? "\<C-P>" : "\<C-Z>"
" }}}

" }}}

" VIM plugin settings ----------------------------------------------------- {{{
" =============================================================================

" Scope settings  {{{
if has("cscope")
    " Show a nice message when cscope is added
    set cscopeverbose

    " Use cscope database for tags when available
    set cscopetag

    " Use quickfix for showing results
    set cscopequickfix=s-,c-,d-,i-,t-,e-

	" The following maps all invoke one of the following cscope search types:
    "
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls
	nnoremap \s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nnoremap \g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nnoremap \c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nnoremap \t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nnoremap \e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nnoremap \f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nnoremap \i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nnoremap \d :cs find d <C-R>=expand("<cword>")<CR><CR>
endif

" }}}
" YouCompleteMe settings  {{{
if Plugin_exists('YouCompleteMe')
    let g:ycm_min_num_of_chars_for_completion = 2
    let g:ycm_auto_trigger = 1
    let g:ycm_error_symbol = '>>'
    let g:ycm_warning_symbol = '!'

    let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
    let g:ycm_key_list_previous_completion = ['<S-TAB>', '<Up>']
    let g:ycm_key_invoke_completion = '<C-Space>'

    let g:ycm_use_ultisnips_completer = 1

    " Fall back to a ycm in the current directory (for when access files in
    " include directories)
    let g:ycm_global_ycm_extra_conf = $HOME.'/.vim/ycm_extra_conf.py'
    let g:ycm_extra_conf_vim_data = ['&filetype', 'getcwd()']

    nnoremap <F1> :YcmCompleter GetType<CR>
    nnoremap <F2> :YcmCompleter GoTo<CR>
    nnoremap <F3> :YcmCompleter GoToDefinition<CR>
endif
"}}}
" CCTree  {{{
let g:CCTreeRecursiveDepth = 5
let g:CCTreeMinVisibleDepth = 2

let g:CCTreeKeyTraceReverseTree = '<f4>'
let g:CCTreeKeyTraceForwardTree = '<f5>'
" }}}
" Fugitive settings  {{{
if Plugin_exists('vim-fugitive')
    " Toggles Git blame window and shortens the window to name length
    nnoremap <leader>gb :Gblame!<CR>
    nnoremap <leader>gs :ToggleGStatus<CR>

	function! ToggleGStatus()
        if buflisted('.git/index')
            bd .git/index
        else
            Gstatus
		endif
	endfunction
	command! ToggleGStatus :call ToggleGStatus()
endif
"}}}
" Gitgutter settings  {{{
if Plugin_exists('vim-gitgutter')
    nnoremap <F10> :GitGutterToggle<CR>
endif
"}}}
" Scratch.vim {{{
if Plugin_exists('scratch.vim')
    nnoremap <leader>ts :Scratch<CR>
    nnoremap <leader>tS :Scratch!<CR>
endif
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
command! NotesStash :Note Notes Stash

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
    let g:ctrlp_extensions = ['mixed', 'line', 'quickfix', 'undo', 'cscope']

    " Use prefixed count to determine the mode for ctrl-p
    " 0 - Last Mode
    " 1 - Mixed mode
    " 2 - Line mode
    " 3 - Quickfix
    " 4 - Undo
    let g:ctrlp_cmd = 'exec "CtrlP".get(["LastMode", "Mixed", "Line", "QuickFix", "Undo"], v:count)'

    " Increase the number of files indexed
    let g:ctrlp_max_files = 25000
    let g:ctrlp_max_depth = 40

    nnoremap <C-t> :CtrlPCscope<CR>
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
" Eclim  {{{
" Add eclim settings to status line. Note the %( %). If all of the variables
" inside are unset, the entire group disappears
function! Eclim_status_line() "{{{
    " if we can't reach Eclim, do nothing else.
    " 0 -> don't echo to user
    if ! exists(":PingEclim") || ! eclim#PingEclim(0)
        return ''
    endif
    " Compute items to be printed on the status line
    let project = eclim#project#util#GetCurrentProjectName()
    let workspace = eclim#project#util#GetProjectWorkspace(project)
    if strlen(project) == 0
        return ''
    else
        return ' | ' . project . ' (' . pathshorten(workspace) . ')'
    endif
endfunction "}}}
set statusline+=%(%{Eclim_status_line()}%)

" Let Syntastic do the java validation (tentative)
" let g:EclimFileTypeValidate = 0
let g:EclimCompletionMethod = 'omnifunc'

let g:EclimDefaultFileOpenAction = 'vsplit'

" Only show error highlights
let g:EclimSignLevel = 'error'

function! SetupEclimJavaMappings()
    nnoremap <buffer><silent> <leader>ji :JavaImport<CR>
    nnoremap <buffer><silent> <leader>jI :JavaImportOrganize<CR>
    " Java search in context based on word under cursor
    nnoremap <buffer><silent> <f3> :JavaSearchContext<CR>
    " Java correction suggestions
    nnoremap <buffer><silent> <leader>jc :JavaCorrect<CR>
    nnoremap <buffer><silent> <f5>    :ProjectRefresh<CR>

    " Show type hierarchy
    nnoremap <buffer><silent> <leader>jt :JavaHierarchy<CR>
    " Show callers
    nnoremap <buffer><leader>jd :JavaCallHierarchy<CR>
    " Show callees
    nnoremap <buffer><leader>ju :JavaCallHierarchy!<CR>
endfunction

" TODO Shorcut to search for method in same file
" TODO Shorcut to search for constructor of current class
" TODO "Show all references"
" TODO "Show implementors (for methods I think)"

" http://eclim.org/vim/java/search.html

" open class path directory
nnoremap <leader>jcp :call eclim#common#locate#locatefile('vsplit', '.classpath', 'project')<cr>

" }}}

" UltiSnips  {{{
" TODO: Go through and learn the java snippets.
if Plugin_exists('ultisnips')
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<c-n>"
    let g:UltiSnipsJumpBackwardTrigger="<c-p>"

    " If you want :UltiSnipsEdit to split your window.
    let g:UltiSnipsEditSplit="vertical"
endif
" }}}
" }}}

" filetype settings ------------------------------------------------------- {{{
" =============================================================================

filetype plugin indent on
set omnifunc=syntaxcomplete#complete

" turn on syntax highlighting
syntax on

" turn on soft wrapping for text files
autocmd FileType text setlocal wrap linebreak

" java {{{

augroup ft_java
    au!
    autocmd FileType java syn region imports start='\n^\s*import'ms=s+2 end='^\s*[^i]'me=e-3  fold transparent
    autocmd FileType java setlocal foldmethod=syntax
    autocmd FileType java call SetupEclimJavaMappings()
augroup end
" }}}

" c/c++ {{{
augroup ft_cpp
    au!
    autocmd FileType c,cpp setlocal foldmethod=syntax
    autocmd FileType c,cpp setlocal tabstop=2
    autocmd FileType c,cpp setlocal softtabstop=2
    autocmd FileType c,cpp setlocal shiftwidth=2
augroup end
" }}}

" llvm {{{
augroup ft_llvm
    au!
    au FileType llvm setlocal iskeyword=@,48-57,_,192-255,%
augroup end

" notes {{{
augroup ft_notes
    au!
    au FileType notes setlocal textwidth=120
    au FileType notes setlocal spell
augroup end
" }}}

" }}}

" break bad habits -------------------------------------------------------- {{{
" =============================================================================

" trailing whitespace {{{
" mark trailing white space, except when typing at the end of the line
highlight extrawhitespace ctermbg=red guibg=red
autocmd insertenter * match extrawhitespace /\s\+\%#\@<!$/
autocmd insertleave * match extrawhitespace /\s\+$/

" clear trailing whitespace
nnoremap <leader>w :%s/\s\+$//<cr>

" }}}

" remap the cursor keys to something else
nnoremap <up>       <nop>
nnoremap <down>     <nop>
nnoremap <left>     <nop>
nnoremap <right>    <nop>

" }}}

" nvim settings ----------------------------------------------------------- {{{
" =============================================================================
if has('nvim')
    tnoremap <esc> <c-\><c-n>
endif
" }}}

" finally ----------------------------------------------------------------- {{{
" =============================================================================

" override general settings with system specific ones
if filereadable($home."/.local/.vimrc")
    source ~/.local/.vimrc
endif
" }}}

