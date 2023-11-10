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
    let g:semshi#error_sign = v:false
    " LSP Support
    Plug 'neovim/nvim-lspconfig'
    " Autocompletion
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'L3MON4D3/LuaSnip'
    " LSP-Zero
    Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'compat-07'}  " Debian has old nvim
endif
call plug#end()
let g:python3_host_prog = $HOME . '/.venv_pynvim/bin/python'

"""""""""""""""""""""""""""""""""
" Custom Colors
"""""""""""""""""""""""""""""""""
function! DiagHighlights() abort
    " :filt Diag hi
    hi DiagnosticError ctermfg=197 guifg=#fd2c40
    hi DiagnosticWarn ctermfg=173  guifg=#d7875f
    hi DiagnosticInfo ctermfg=245  guifg=#8a8a8a
    hi DiagnosticHint ctermfg=250 guifg=#BCBCBC
    hi DiagnosticUnderlineError cterm=underline gui=underline guisp=Red
    hi DiagnosticUnderlineWarn cterm=underline gui=underline guisp=Orange
    hi DiagnosticUnderlineInfo cterm=underline gui=underline guisp=LightBlue
    hi DiagnosticUnderlineHint cterm=underline gui=underline guisp=LightGrey
endfunction
augroup DiagColors
    autocmd!
    autocmd ColorScheme * call DiagHighlights()
augroup END

let g:python_highlight_all = 1
let g:vim_monokai_tasty_italic=1
colorscheme vim-monokai-tasty

function SemshiPyHighlights()
    hi semshiSelf            ctermfg=208 guifg=#FF9700
    hi semshiImported        cterm=underline gui=underline
endfunction
autocmd FileType python call SemshiPyHighlights()

" highlight non-ASCII; shortcut 'ga' to show char's bytes
function HiNonASCII()
    syntax match nonascii "[^\u0000-\u007F]"
    hi nonascii ctermbg=226 ctermfg=black cterm=bold guibg=#ffff00 guifg=black gui=bold
endfunction
autocmd BufEnter * call HiNonASCII()

hi clear CursorLine
hi CursorLine cterm=underline gui=underline 
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

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

"""""""""""""""""""""""""""""""""
" End Custom Colors
"""""""""""""""""""""""""""""""""

" Get the defaults that most users want.
if !has('nvim')
    source $VIMRUNTIME/defaults.vim
endif

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
set laststatus=2  " status line always
" cursorline for active window

" netrw customization
let g:netrw_keepdir = 0
let g:netrw_winsize = 30
let g:netrw_banner = 0

" space, y to copy last yank to clipboard
let mapleader = " "
map <leader>y :let @+=@0<CR>
" map <Leader>be :BufExplorer<CR>
" map <Leader>bt :ToggleBufExplorer<CR>
" map <Leader>bs :BufExplorerHorizontalSplit<CR>
" map <Leader>bv :BufExplorerVerticalSplit<CR>

" shift + arrow-key to resize pane
map <S-Up> <c-w>-
map <S-Down> <c-w>+
map <S-Right> <c-w>>
map <S-Left> <c-w><
function! NetRWPaneResizeShortcuts()
    map <buffer> <S-Up> <c-w>-
    map <buffer> <S-Down> <c-w>+
    map <buffer> <S-Right> <c-w>>
    map <buffer> <S-Left> <c-w><
endfunction
autocmd filetype netrw call NetRWPaneResizeShortcuts()
