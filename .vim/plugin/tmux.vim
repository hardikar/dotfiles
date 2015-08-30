if exists('g:tmux_vim') || &cp || v:version < 700
  finish
endif
let g:tmux_vim = 1

function! s:InTmuxSession()
  return $TMUX != ''
endfunction

if s:InTmuxSession()
  let g:reg = @0
  function RegChanged()
    if g:reg != @0 
      let g:reg = @0
      return 1
    else
      return 0
    endif
  endfunction
  function TmuxSetBuffer()
    if RegChanged()
      let cmd = 'tmux set-buffer "'. g:reg . '"'
      echom cmd
      silent call system(cmd)
    endif
  endfunction
  " Settings for my very own tmux-vim
  autocmd CursorHold * call TmuxSetBuffer()
  autocmd CursorHoldI * call TmuxSetBuffer()
  autocmd InsertEnter * call TmuxSetBuffer()
else
  " Set clipboard as unnamed to interact better with tmux
  set clipboard=unnamed
endif
