call plug#begin('~/.vim/plugged')
Plug 'patstockwell/vim-monokai-tasty'
Plug 'vim-python/python-syntax'
Plug 'jlanzarotta/bufexplorer'
Plug 'mogelbrod/vim-jsonpath'
Plug 'itchyny/lightline.vim'
Plug 'treatmesubj/rock-lightline'
if has('nvim')
    Plug 'wookayin/semshi'
    let g:semshi#excluded_hl_groups = ['local', 'global']
    let g:semshi#simplify_markup = v:false
    let g:semshi#mark_selected_nodes = 2
endif
call plug#end()

let g:lightline = {
      \ 'colorscheme': 'rock',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype', 'charvaluehex' ] ]
      \ },
      \ 'component': {
      \   'charvaluehex': '0x%B',
      \ },
      \ }

let g:python_highlight_all = 1
let g:vim_monokai_tasty_italic=1
colorscheme vim-monokai-tasty

function SemshiPyHighlights()
  hi semshiSelf            ctermfg=208 guifg=#FF9700
  hi semshiImported        cterm=underline gui=underline
endfunction
autocmd FileType python call SemshiPyHighlights()

" Get the defaults that most users want.
if !has('nvim')
    source $VIMRUNTIME/defaults.vim
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

set hlsearch " highlight search
set incsearch " incremental highlight search
set ic  " ignore-case
set is  " partial-search-match
set number  " line-numbers
set relativenumber " relative line-numbers
set mouse=  " no-mouse
if !has('nvim')
    set ttymouse=  " no-mouse
endif
set wrap " don't literally insert newlines
set directory=/tmp
set backupdir=/tmp
set undofile  " keep an undo file (undo changes after closing)
set undodir=~/.vim/undodir  " put all undo files in a tidy dir
set background=dark
set tabstop=4 shiftwidth=4 expandtab " every tab -> 4 spaces
" set fileformat=unix to fix trailing character issues
set list
set listchars=eol:$,tab:<->,trail:+,nbsp:_
" highlight non-ASCII; shortcut 'ga' to show char's bytes
function HiNonASCII()
    syntax match nonascii "[^\u0000-\u007F]"
    hi nonascii ctermbg=226 ctermfg=black cterm=bold guibg=#ffff00 guifg=black gui=bold
endfunction
autocmd BufEnter * call HiNonASCII()
set laststatus=2  " status line always
"hi StatusLine ctermbg=54 ctermfg=white guibg=#5f00d7 guifg=white
" cursorline for active window
hi clear CursorLine
hi CursorLine cterm=underline gui=underline 
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" space, y to copy last yank to clipboard
let mapleader = " "
noremap <leader>y :let @+=@0<CR>
" noremap <Leader>be :BufExplorer<CR>
" noremap <Leader>bt :ToggleBufExplorer<CR>
" noremap <Leader>bs :BufExplorerHorizontalSplit<CR>
" noremap <Leader>bv :BufExplorerVerticalSplit<CR>

