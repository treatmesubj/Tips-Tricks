" :so ./color_demo.vim
let num = 255
while num >= 0
    exec 'hi col_'.num.' ctermbg='.num.' ctermfg=white'
    exec 'syn match col_'.num.' "ctermbg='.num.':...." containedIn=ALL'
    call append(0, 'ctermbg='.num.':....')
    let num = num - 1
endwhile

" to see all color groups... :so $VIMRUNTIME/syntax/hitest.vim
" https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim
