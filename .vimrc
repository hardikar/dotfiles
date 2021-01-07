" .vimrc
" Author : Shreedhar Hardikar (hardikar@cs.wisc.edu)
"
" Basic options ----------------------------------------------------------- {{{

let mapleader = " "

set nocompatible    " Disable vi compatibility
set nomodeline      " Don't read editor config from file
set history=750
set undolevels=700
set cursorline      " Highlight the screen line of the cursor
set ttyfast         " Fast terminal connection
set backspace=2     " Allow backspace over autoindent,eol,start
set tildeop         " Change case is now an operator
set hidden          " Opening a new file when the current buffer has unsaved
                    " changes, causes files to be hidden instead of closed
set splitbelow
set splitright
set mouse=a         " Enable mouse selection whenever possible
set noesckeys       " Don't allow mappings that start with <Esc>
set number
set path+=**        " :find searches current directory recursively 

set autoindent      " Indent according to the previous line automatically
set smarttab        " Uses shiftwidth on a <Tab> in front of a line
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=0    " Use the tabstop value when shifting

" Search settings
set ignorecase      " Ignore cases while searching
set smartcase       " /The matches only The but /the matches both The and the
set incsearch       " Show the next matching thing right away

" Backups and swap files
set noswapfile
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

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
let g:netrw_preview = 1    " Split vertically for preview windows

set background=dark
colorscheme hybrid

" Setup fonts
if has("gui_running")
  if has("gui_gtk2")
    set guifont=JetbrainsMonoNL-Regular\ 12
  elseif has("gui_macvim")
    set guifont=JetBrainsMonoNL-Regular:h13
  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI
  endif
endif

set scrolloff=2     " min lines to show when scrolling up/down
set sidescrolloff=2 " min lines to show when scrolling left/right

" Delete comment character when joining commented
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j
endif

set listchars=tab:>\ ,extends:>,precedes:<,nbsp:+,eol:$

" don't fold anything when file is opened
set foldlevel=1000

" resize splits once window is resized
autocmd VimResized * execute "normal! \<c-w>="


" }}}
" Status bar -------------------------------------------------------------- {{{

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
" Mappings ---------------------------------------------------------- {{{

" Vertical splits a tad bit better
nnoremap <C-W>] :vertical stag <C-R>=expand("<cword>")<CR><CR>

" Easier moving of code block
vnoremap < <gv
vnoremap > >gv

" Select (charwise) the contents of the current line, excluding indentation.
" Great for pasting Python lines into REPLs.
nnoremap <leader>v ^<C-v>g_

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" Quick-access to omni-complete
inoremap <c-o> <c-x><c-o>

" Toggle spelling on/off
nnoremap <silent> <leader>s :set spell!<CR>

" Toggle invisibles
nnoremap <silent> <Leader>l :set list!<CR>

" ScrollLock
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

" Quick fix list traversal
nnoremap <silent> <leader>n :cnext<CR>
nnoremap <silent> <leader>N :cprevious<CR>

" Search for the word under the cursor in the current file and open a quickfix window
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

set complete=.,w,b,kspell,t
" Better navigating through omnicomplete option list
set completeopt=longest,menuone
" Limit the height of the menu
set pumheight=10

" mark trailing white space, except when typing at the end of the line
highlight extrawhitespace ctermbg=red guibg=red
autocmd insertenter * match extrawhitespace /\s\+\%#\@<!$/
autocmd insertleave * match extrawhitespace /\s\+$/

" remove trailing whitespace
nnoremap <leader>w :%s/\s\+$//<cr>

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
function! SendToTerm(bufn) range
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
" Plugins {{{

" To install vim-plug:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin('~/.vim/bundle')

Plug 'https://github.com/tpope/vim-rsi'
Plug 'nathangrigg/vim-beancount'
Plug 'tpope/vim-fugitive'
Plug 'kien/ctrlp.vim'

call plug#end()

" match more complex pairs (eg xml tags)
packadd! matchit

" disable meta maps; see :help rsi for details
let g:rsi_no_meta = 1

" ctrl-p mappings
let g:ctrlp_map = '<leader>f'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_user_command = ['.git', 'git --git-dir=%s/.git ls-files -co --exclude-standard']

" }}}
" filetype settings ------------------------------------------------------- {{{

filetype plugin indent on
syntax enable

" turn on soft wrapping for text files
autocmd FileType text setlocal wrap linebreak

augroup ft_java
    au!
    autocmd FileType java syn region imports start='\n^\s*import'ms=s+2 end='^\s*[^i]'me=e-3  fold transparent
    autocmd FileType java setlocal foldmethod=syntax
augroup end

augroup ft_python
	au!
    autocmd FileType python setlocal tabstop=4
    autocmd FileType python setlocal softtabstop=4
    autocmd FileType python setlocal shiftwidth=4
    autocmd FileType python setlocal expandtab
augroup end

augroup ft_cpp
    au!
    autocmd FileType c,cpp setlocal foldmethod=syntax
    autocmd FileType c,cpp setlocal tabstop=2
    autocmd FileType c,cpp setlocal softtabstop=2
    autocmd FileType c,cpp setlocal shiftwidth=2
	" Additional 'bracket' types for C++
    autocmd FileType cpp setlocal matchpairs+=<:>
augroup end

augroup ft_javascript
    au!
    au FileType javascript setlocal expandtab
    au FileType json setlocal expandtab
augroup end

augroup ft_gitcommit
	au!
	au FileType gitcommit setlocal spell
augroup end

augroup ft_vim
    au!
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType vim setlocal expandtab
augroup end

augroup ft_fugitive
	au!
    autocmd FileType fugitive nmap <buffer> p 1p
    autocmd FileType fugitive nmap <buffer> <Tab> =
    autocmd FileType fugitive nmap <buffer> x X
augroup end

augroup ft_beancount
    let g:beancount_detailed_first = 1

    autocmd BufEnter *.bc :setlocal filetype=beancount

    autocmd filetype beancount setlocal foldmethod=marker
    autocmd filetype beancount setlocal foldlevel=0
    autocmd filetype beancount setlocal foldlevelstart=0
    autocmd FileType beancount setlocal iskeyword+=-,.
    autocmd FileType beancount setlocal expandtab
    autocmd FileType beancount setlocal tabstop=2
    autocmd FileType beancount setlocal softtabstop=2
augroup end
" }}}

