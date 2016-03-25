"
" List of colors to switch between. This is not auto-populated.  To add colors
" use ColorsAddColor and ColorsSetDefaultColor to add colors and set a default
" one. You must make sure that the colorscheme is actually available
"

if !exists('g:colors')
    let g:colors = ['default']
endif
if !exists('g:colors_default_background')
    let g:colors_default_background = 'dark'
endif
if !exists('g:colors_default_color_index')
    let g:colors_default_color_index = 0
endif

let s:color_index = 0

function! colors#set_default_color(color)
    let s:color_index = colors#add_color(a:color)
    call colors#set_color(s:color_index)
endfunction

" Add the color given to g:colors, if it isn't already present in the list,
" else return the corresponding index
function! colors#add_color(color)
    let l:c_index = index(g:colors, a:color)
    if l:c_index == -1
        let c_index = len(g:colors)
        call insert(g:colors, a:color)
    endif
    return l:c_index
endfunction

function! colors#set_color(c_index)
    let l:color = g:colors[a:c_index]
    execute "colorscheme default"
    execute "colorscheme ".l:color
endfunction

function! colors#print_colors()
    echom g:colors_name . " - " . s:color_index . " : " string(g:colors)
endfunction

function! colors#toggle_background()
    if &background == 'dark'
        set background=dark
    else
        set background=light
    endif
endfunction

function! colors#next_color()
    let s:color_index = ( s:color_index + 1) % len(g:colors)
    call colors#set_color(s:color_index)
endfunction


function! colors#prev_color()
    let s:color_index = ( s:color_index - 1) % len(g:colors)
    call colors#set_color(s:color_index)
endfunction

command! ColorsToggleBackground call colors#toggle_background()
command! ColorsNext call colors#next_color()
command! ColorsPrev call colors#prev_color()
command! ColorsPrint call colors#print_colors()

call colors#set_color(g:colors_default_color_index)
execute('set background=' . g:colors_default_background)
