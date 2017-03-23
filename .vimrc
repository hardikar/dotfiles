" .vimrc
" Author : Shreedhar Hardikar (hardikar@cs.wisc.edu)
"
" TODO Add ctags support
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
Plug 'jeetsukumaran/vim-buffergator'
Plug 'yssl/QFEnter'

" Productivity plugins
Plug 'jszakmeister/vim-togglecursor'
Plug 'jaxbot/semantic-highlight.vim'

" Language plugins
Plug 'Superbil/llvm.vim'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'

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
set tabstop=2       " number of visual spaces per TAB
set softtabstop=2   " number of spaces in tab when editing
set expandtab       " tabs are spaces
set shiftwidth=2

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
if version >= 703
    set relativenumber  " Show line numbers relative to current line
    autocmd InsertEnter * :set number
    autocmd InsertLeave * :set relativenumber
else
    set number
endif

" Brackets while editing
set matchpairs=(:),{:},[:]   " Additional "bracket" types
" the cursor will briefly jump to the matching brace when you insert one
set showmatch
set matchtime=3

" Enable mouse selection whenever possible
set mouse=a

" Don't allow mappings that start with <Esc>
set noesckeys

" Easy toggling insert modes
set pastetoggle=<F6>

" NetRW settings
" Quick help for me:
" <cr>,o,v,t Open window in this window/horz split/vert split/new tab
" p          Preview
" P          Open in previous window
" s          Change sort key
" d          Create directory
" D          Delete file/directory
" %          New file in current directory

let g:netrw_banner = 0     " Remove hideous banner
let g:netrw_liststyle = 3  " tree listing
let g:netrw_preview   = 1  " Split vertically for preview windows
let g:netrw_alto = 0       " Split on right for preview windows

" VIM's own fuzzy finding
set path+=**

" }}}

" Color Theme ------------------------------------------------------------- {{{
" =============================================================================

" Explicitly tell vim that the terminal supports 256 colors"
set t_Co=256

let g:colors = ["hybrid", "wombat256mod"]
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

" Create a cscope database
function! MakeCscope()
    call system("find . -name '*.c' -o -name '*.h' -o -name '*.cpp' -o -name '*.cc' -o -name '*.hpp' > cscope.files")
    call system("cscope -bq")
endfunction

" Create ctags database (sample), you're better of running this on a command
" line
function! MakeCtags()
    call system("ctags -R .")
endfunction

command! MakeCscope :call MakeCscope()
command! MakeCtags :call MakeCtags()

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
nnoremap <silent> <Leader>l :set list!<CR>

" Since <C-I> is <TAB> some times
nnoremap <C-P> <C-I>

" Vertical splits a tad bit better
nnoremap <C-W>] :vertical stag <C-R>=expand("<cword>")<CR><CR>


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
autocmd BufWinEnter quickfix :nnoremap <buffer> <silent> q :call ToggleQuickFix()<CR>
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
if version >= 703
    set wildcharm=<C-Z>
    cnoremap <expr><Tab>     wildmenumode() ? "\<C-N>" : "\<C-Z>"
    cnoremap <expr><S-Tab>   wildmenumode() ? "\<C-P>" : "\<C-Z>"
endif
" }}}

" }}}

" VIM plugin settings ----------------------------------------------------- {{{
" =============================================================================

" Scope settings  {{{
if has("cscope")
    " Show a nice message when cscope is added
    set cscopeverbose

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
    "   'i'   includes: find files that include the current file
    "   'd'   called: find functions that function under cursor calls
	nnoremap \s :cs find s <C-R>=expand("<cword>")<CR><CR>
	nnoremap \S :cs find s 
    nnoremap \g :cs find g <C-R>=expand("<cword>")<CR><CR>
	nnoremap \G :cs find g 
    nnoremap \c :cs find c <C-R>=expand("<cword>")<CR><CR>
	nnoremap \C :cs find c 
    nnoremap \t :cs find t <C-R>=expand("<cword>")<CR><CR>
	nnoremap \T :cs find t 
    nnoremap \e :cs find e <C-R>=expand("<cword>")<CR><CR>
	nnoremap \E :cs find e 
    nnoremap \f :cs find f <C-R>=expand("<cfile>")<CR><CR>
	nnoremap \F :cs find f 
    nnoremap \i :cs find i <C-R>=expand("%:t")<CR><CR>
	nnoremap \I :cs find i 
    nnoremap \d :cs find d <C-R>=expand("<cword>")<CR><CR>
	nnoremap \D :cs find d 

	nnoremap <C-W>\s :vertical scs find s <C-R>=expand("<cword>")<CR><CR>
	nnoremap <C-W>\S :vertical scs find s 
    nnoremap <C-W>\g :vertical scs find g <C-R>=expand("<cword>")<CR><CR>
	nnoremap <C-W>\G :vertical scs find g 
    nnoremap <C-W>\c :vertical scs find c <C-R>=expand("<cword>")<CR><CR>
	nnoremap <C-W>\C :vertical scs find c 
    nnoremap <C-W>\t :vertical scs find t <C-R>=expand("<cword>")<CR><CR>
	nnoremap <C-W>\T :vertical scs find t 
    nnoremap <C-W>\e :vertical scs find e <C-R>=expand("<cword>")<CR><CR>
	nnoremap <C-W>\E :vertical scs find e 
    nnoremap <C-W>\f :vertical scs find f <C-R>=expand("<cfile>")<CR><CR>
	nnoremap <C-W>\F :vertical scs find f 
    nnoremap <C-W>\i :vertical scs find i <C-R>=expand("%:t")<CR><CR>
	nnoremap <C-W>\I :vertical scs find i 
    nnoremap <C-W>\d :vertical scs find d <C-R>=expand("<cword>")<CR><CR>
	nnoremap <C-W>\D :vertical scs find d 

	nnoremap <C-X>\s :scs find s <C-R>=expand("<cword>")<CR><CR>
	nnoremap <C-X>\S :scs find s 
    nnoremap <C-X>\g :scs find g <C-R>=expand("<cword>")<CR><CR>
	nnoremap <C-X>\G :scs find g 
    nnoremap <C-X>\c :scs find c <C-R>=expand("<cword>")<CR><CR>
	nnoremap <C-X>\C :scs find c 
    nnoremap <C-X>\t :scs find t <C-R>=expand("<cword>")<CR><CR>
	nnoremap <C-X>\T :scs find t 
    nnoremap <C-X>\e :scs find e <C-R>=expand("<cword>")<CR><CR>
	nnoremap <C-X>\E :scs find e 
    nnoremap <C-X>\f :scs find f <C-R>=expand("<cfile>")<CR><CR>
	nnoremap <C-X>\F :scs find f 
    nnoremap <C-X>\i :scs find i <C-R>=expand("%:t")<CR><CR>
	nnoremap <C-X>\I :scs find i 
    nnoremap <C-X>\d :scs find d <C-R>=expand("<cword>")<CR><CR>
	nnoremap <C-X>\D :scs find d 

  nnoremap <leader>? :ptag <C-R>=expand("<cword>")<CR><CR>
endif

" }}}
" QFEnter settings  {{{
if Plugin_exists('QFEnter')
    let g:qfenter_vopen_map = ['<C-v>']
    let g:qfenter_hopen_map = ['<C-CR>', '<C-s>', '<C-x>']
    let g:qfenter_topen_map = ['<C-t>']
endif
"}}}
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
    let g:syntastic_python_checkers = ['python']
    let g:syntastic_python_pylint_quiet_messages = { "level": "warnings" }

    " Limit include files to 3 levels
    let includedirs = split(globpath('.','include'), '\n') + 
                      \ split(globpath('.','*/include'), '\n') +
                      \ split(globpath('.','*/*/include'), '\n')

    " Systastic check for c
    let g:syntastic_c_include_dirs = includedirs
    let g:syntastic_c_compilter_options = ' -std=c11 -Wall -pedantic -Wextra'

    " Systastic check for c++
    let g:syntastic_cpp_include_dirs = includedirs
    let g:syntastic_cpp_compiler_options = ' -std=c++11'

    nnoremap <leader>p :SyntasticCheck<CR>
    nnoremap <leader>P :SyntasticReset<CR>
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
    autocmd FileType cpp setlocal matchpairs+=<:>   " Additional 'bracket' types for C++
augroup end
" }}}

" c/c++ {{{
augroup ft_cpp
    au!
    autocmd FileType c,cpp setlocal foldmethod=syntax
    autocmd FileType c,cpp setlocal tabstop=2
    autocmd FileType c,cpp setlocal softtabstop=2
    autocmd FileType c,cpp setlocal shiftwidth=2
    autocmd FileType cpp setlocal matchpairs+=<:>   " Additional 'bracket' types for C++
augroup end
" }}}

" llvm {{{
augroup ft_llvm
    au!
    au FileType llvm setlocal iskeyword=@,48-57,_,192-255,%
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
"nnoremap <up>       <nop>
"nnoremap <down>     <nop>
"nnoremap <left>     <nop>
"nnoremap <right>    <nop>

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

