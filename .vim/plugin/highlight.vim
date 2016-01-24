" ================================================================================
" Hightlight plugin
" This mini-plugin provides a few mappings for highlighting words temporarily.
"
" Copied from https://bitbucket.org/sjl/dotfiles/src/54484a3a4dfd417d9412505666d7c5da80e7a76d/vim/vimrc?at=default
" ================================================================================

function! HiInterestingWord(n, op) " {{{
    " Save our location.
    normal! mz

    " Calculate an arbitrary match ID.  Hopefully nothing else is using it.
    let mid = 86750 + a:n

    " Clear existing matches, but don't worry if they don't exist.
    silent! call matchdelete(mid)

    if a:op == '+'
        " Yank the current word into the z register.
        normal! "zyiw

        " Construct a literal pattern that has to match at boundaries.
        let pat = '\V\<' . escape(@z, '\') . '\>'

        " Actually match the words.
        call matchadd("InterestingWord" . a:n, pat, 1, mid)
    end

    " Move back to our original location.
    normal! `z
endfunction " }}}

" Mappings {{{

nnoremap <silent> <Leader>1 :call HiInterestingWord(1, '+')<cr>
nnoremap <silent> <Leader>2 :call HiInterestingWord(2, '+')<cr>
nnoremap <silent> <Leader>3 :call HiInterestingWord(3, '+')<cr>
nnoremap <silent> <Leader>4 :call HiInterestingWord(4, '+')<cr>
nnoremap <silent> <Leader>5 :call HiInterestingWord(5, '+')<cr>
nnoremap <silent> <Leader>6 :call HiInterestingWord(6, '+')<cr>

nnoremap <silent> <Leader>u1 :call HiInterestingWord(1, '-')<cr>
nnoremap <silent> <Leader>u2 :call HiInterestingWord(2, '-')<cr>
nnoremap <silent> <Leader>u3 :call HiInterestingWord(3, '-')<cr>
nnoremap <silent> <Leader>u4 :call HiInterestingWord(4, '-')<cr>
nnoremap <silent> <Leader>u5 :call HiInterestingWord(5, '-')<cr>
nnoremap <silent> <Leader>u6 :call HiInterestingWord(6, '-')<cr>
" }}}
" Default Highlights {{{

function! SetHighlightColors()
    hi def InterestingWord1 guifg=#000000 ctermfg=0 guibg=#ffa724 ctermbg=154
    hi def InterestingWord2 guifg=#000000 ctermfg=0 guibg=#aeee00 ctermbg=229
    hi def InterestingWord3 guifg=#000000 ctermfg=0 guibg=#8cffba ctermbg=121
    hi def InterestingWord4 guifg=#000000 ctermfg=0 guibg=#b88853 ctermbg=211
    hi def InterestingWord5 guifg=#000000 ctermfg=0 guibg=#ff9eb8 ctermbg=195
    hi def InterestingWord6 guifg=#000000 ctermfg=0 guibg=#ff9eb8 ctermbg=137
endfunction

autocmd ColorScheme * call SetHighlightColors()
call SetHighlightColors()

