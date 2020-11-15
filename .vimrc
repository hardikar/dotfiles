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
Plug 'jeetsukumaran/vim-buffergator'
Plug 'yssl/QFEnter'

" Productivity plugins
Plug 'jszakmeister/vim-togglecursor'
Plug 'nathangrigg/vim-beancount'

" Language plugins
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'

" Add plugins to &runtimepath
call plug#end()

" }}}

" Map leader early on, so that all future mappings succeed
let mapleader = " "

packadd! matchit

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

set number

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

set statusline=                              " Empty status bar
set statusline+=%n:                          " Buffer number
set statusline+=%{tabpagewinnr(tabpagenr())} " Window number
set statusline+=\                            " Separator
set statusline+=%m                           " Modifiable flag
set statusline+=\                            " Separator
set statusline+=%y                           " File type
set statusline+=\                            " Separator
set statusline+=%F                           " Full path of the file
set statusline+=%=                           " left/right separator
set statusline+=%l,                          " Cursor line
set statusline+=%c                           " Cursor column
set statusline+=\ \|\                        " Seperator
set statusline+=%L                           " Cursor line/total lines
set statusline+=\ (%P)                       " Percent through file

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
" SendToTerm {{{

" Find a terminal buffer in the current tab.
" tabpagebuflist([{arg}]) List list of buffer numbers in tab page
" term_list()             List get the list of terminal buffers
function! GetTermBufferInCurrentTab()
	let terms = term_list()
	if len(terms) <= 0
		" echoerr "No available terminals!"
		return 0
	endif

	for ibuf in tabpagebuflist()
		let idx = index(terms, ibuf)
		if idx != -1
			return ibuf
		endif
	endfor
	return terms[0]
endfunction

" Send characters in visual buffer to the given terminal.
" Else find a terminal buffer in the current tab and send it there.
" term_sendkeys({buf}, {keys}) none send keystrokes to a terminal
" Inspiration:
" - https://stackoverflow.com/questions/49318522/send-buffer-to-a-running-terminal-window-in-vim-8
" - https://vi.stackexchange.com/questions/11025/passing-visual-range-to-a-command-as-its-argument
function! SendToTerm(bufn=-1) range
	" if no bufn is passed in, find a terminal in the current tab
	if a:bufn <= 0
		let c = GetTermBufferInCurrentTab()
	else
		let c = a:bufn
	endif
	" if no bufn found, stop
	if c <= 0
		echon "No available terminals!"
		return
	endif

	" get the line and column of the visual selection marks
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]

  " get all the lines represented by this range
  let lines = getline(lnum1, lnum2)

  " the last line might need to be cut
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  " the first line might need to be trimmed
	let lines[0] = lines[0][col1 - 1:]

	" clean up and send!
	let keys = substitute(join(lines, "\n"), '\n$', '', '')
	call term_sendkeys(c, keys . "\<cr>")

	echon "Sent " . len(keys) . " chars to buf " . c . "."
endfunction

" visual select text to be sent, then hit <leader>r.
" also takes count, e.g 5<leader>r to send to buffer 5.
vnoremap <leader>r :call SendToTerm(v:count)<CR>
nnoremap <leader>r V:call SendToTerm(v:count)<CR>
command! -range SendToTerm call SendToTerm(v:count)

" }}}
" Omnicomplete navigation {{{

" Change the default auto-complete changes.
" The default is ".,w,b,u,t,i", which means to scan:
" 	   1. . the current buffer
" 	   2. w buffers in other windows
" 	   3. b other loaded buffers
" 	   4. u unloaded buffers
" 	   5. t tags
" 	   6. i included files
set complete=.,w,b,u

" Better navigating through omnicomplete option list
set completeopt=longest,menuone
" Limit the height of the menu
set pumheight=10


" Insert Mode Completion {{{
" :help ins-completion
inoremap <c-f> <c-x><c-f>
" Because on the terminal, <C-space> becomes <C-@>
imap <c-@> <c-Space>
inoremap <c-Space> <c-x><c-o>
inoremap <c-o> <c-x><c-o>

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
set wildignore+=*.aux,*.toc                      " LaTeX intermediate files
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
" Syntastic  {{{
" cd ~/.vim/bundle && \
" git clone https://github.com/scrooloose/syntastic.git
if Plugin_exists('syntastic')
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*
 
		" "mode" can be mapped to one of two values - "active" or "passive". When
		" set to "active", syntastic does automatic checking whenever a buffer is
		" saved or initially opened. When set to "passive" syntastic only checks
		" when the user calls `:SyntasticCheck`.
    let g:syntastic_mode_map = {
        \ "mode": "passive",
        \ "active_filetypes": [],
        \ "passive_filetypes": [] }

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
" vim-beancount  {{{
" git clone https://github.com/nathangrigg/vim-beancount
if Plugin_exists('vim-beancount')
    let g:beancount_detailed_first = 1

    autocmd BufEnter *.bc :setlocal filetype=beancount

    autocmd filetype beancount setlocal foldmethod=marker
    autocmd filetype beancount setlocal foldlevel=0
    autocmd filetype beancount setlocal foldlevelstart=0
    autocmd FileType beancount setlocal iskeyword+=-,.
    autocmd FileType beancount setlocal expandtab
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

" javascript & json{{{
augroup ft_javascript
    au!
    au FileType javascript setlocal expandtab
    au FileType json setlocal expandtab
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

" Make sure this wasn't reset in the interim!
set nocompatible
