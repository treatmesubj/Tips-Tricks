call plug#begin('~/.vim/plugged')
Plug 'patstockwell/vim-monokai-tasty'
Plug 'vim-python/python-syntax'
if has('nvim')
    Plug 'wookayin/semshi'
    let g:semshi#excluded_hl_groups = ['local', 'global']
    let g:semshi#simplify_markup = v:false
    let g:semshi#mark_selected_nodes = 2
endif

call plug#end()
let g:python_highlight_all = 1
let g:vim_monokai_tasty_italic=1
colorscheme vim-monokai-tasty

" When started as "evim", evim.vim will already have done these settings, bail
" out.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
if !has('nvim')
    source $VIMRUNTIME/defaults.vim
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!
  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

if has('syntax') && has('eval')
  packadd! matchit
endif

set ic  "ignore-case
set is  "partial-search-match
set number  "line-numbers
set relativenumber "relative line-numbers
set mouse=  "no-mouse
if !has('nvim')
    set ttymouse=  "no-mouse
endif
set wrap "don't literally insert newlines
set directory=/tmp
set backupdir=/tmp
set undofile  " keep an undo file (undo changes after closing)
set undodir=~/.vim/undodir  "put all undo files in a tidy dir
set background=dark
set tabstop=4 shiftwidth=4 expandtab "every tab -> 4 spaces
" set fileformat=unix to fix trailing character issues
set list
set listchars=eol:$,tab:<->,trail:+,nbsp:_
set laststatus=2  " status line always
" cursorline for active window
hi clear CursorLine
hi CursorLine gui=underline cterm=underline
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

function SemshiPyHighlights()
  hi semshiSelf            ctermfg=208 guifg=#FF9700
  hi semshiImported        cterm=underline gui=underline
endfunction
autocmd FileType python call SemshiPyHighlights()

" WSL2 copy yank register to clipboard
  " access Windows executables when System D enbaled
  " https://github.com/microsoft/WSL/issues/8843
  " sudo sh -c 'echo :WSLInterop:M::MZ::/init:PF > /usr/lib/binfmt.d/WSLInterop.conf'
"function! Clip()
"  call system("clip.exe",  getreg('0'))
"endfunction
command Clip :call system("clip.exe",  getreg('0'))

