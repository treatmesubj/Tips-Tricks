" ~/.vimrc
call plug#begin('~/.vim/plugged')
" :PlugInstall, :PlugUpdate, :PlugUpgrade
Plug 'patstockwell/vim-monokai-tasty'
Plug 'vim-python/python-syntax'
Plug 'preservim/vim-markdown'
Plug 'chrisbra/csv.vim'
Plug 'itchyny/lightline.vim'
Plug 'treatmesubj/rock-lightline'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
if has('nvim')
  Plug 'wookayin/semshi'  " python highlights
  Plug 'lukas-reineke/indent-blankline.nvim'
  " LSP Support
  Plug 'neovim/nvim-lspconfig'
  " Autocompletion
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'L3MON4D3/LuaSnip'
  " LSP-Zero
  Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v3.x'}
  Plug 'hrsh7th/cmp-buffer'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " :TSUpdate
  " :TSInstall yaml
  Plug 'cuducos/yaml.nvim'
  " :TSInstall json
  Plug 'treatmesubj/jsonpath.nvim'
  " marks
  Plug 'chentoast/marks.nvim'
  " logs syntax highlights
  Plug 'fei6409/log-highlight.nvim'
endif
call plug#end()
let g:python3_host_prog = $HOME . '/.venv_pynvim/bin/python'

"""""""""""""""""""""""""""""""""
" Custom Colors
"""""""""""""""""""""""""""""""""
set notermguicolors
set background=dark
" Diagnostic Colors
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
let g:vim_monokai_tasty_italic = 1
colorscheme vim-monokai-tasty
" hi Normal guibg=NONE ctermbg=NONE  " transparent

let g:semshi#excluded_hl_groups = ['local', 'global']
let g:semshi#simplify_markup = v:false
let g:semshi#mark_selected_nodes = 2
let g:semshi#error_sign = v:false
function SemshiPyHighlights()
    hi semshiSelf            ctermfg=208 guifg=#FF9700
    hi semshiImported        cterm=underline gui=underline
endfunction
autocmd FileType python call SemshiPyHighlights()

" csv.vim
hi CSVColumnEven ctermfg=166 guifg=#d75f00
hi CSVColumnOdd  ctermfg=37 guifg=#00afaf

" highlight non-ASCII; shortcut 'ga' to show char's bytes
function HiNonASCII()
  syntax match nonascii "[^\u0000-\u007F]" containedin=ALLBUT,nonascii
  hi nonascii ctermbg=226 ctermfg=black cterm=bold guibg=#ffff00 guifg=black gui=bold
endfunction
autocmd BufEnter * call HiNonASCII()

" highlight git merge conflict markers
function! HiGitMergeConflict()
  syn region conflictStart start=/^<<<<<<< .*$/ end=/^\ze\(=======$\||||||||\)/ containedin=ALLBUT,conflictStart
  syn region conflictMiddle start=/^||||||| .*$/ end=/^\ze=======$/ containedin=ALLBUT,conflictMiddle
  syn region conflictEnd start=/^\(=======$\||||||| |\)/ end=/^>>>>>>> .*$/ containedin=ALLBUT,conflictEnd

  highlight conflictStart ctermbg=green ctermfg=black
  highlight conflictMiddle ctermbg=blue ctermfg=black
  highlight conflictEnd ctermbg=red ctermfg=black
endfunction
autocmd BufEnter * call HiGitMergeConflict()

" higlight trailing white spaces
highlight ExtraWhitespace ctermbg=197
match ExtraWhitespace /\s\+$/

" cursorline
hi clear CursorLine
hi CursorLine cterm=underline gui=underline
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" off-white normal text
hi Normal ctermfg=254  guifg=#e4e4e4

" marks.nvim
hi MarkSignNumHL ctermfg=245  guifg=#8a8a8a

let g:lightline = {
  \ 'colorscheme': 'rock',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'readonly', 'filename', 'modified' ] ],
  \   'right': [ [ 'percent' ],
  \              [ 'fileformat', 'fileencoding', 'filetype', 'pos+hex' ] ]
  \ },
  \ 'component': {
  \   'charvaluehex': '0x%B',
  \   'position': '%l,%c',
  \   'pos+hex': '%l,%c:0x%B',
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

" don't unfold when searching
set fdo-=search
" save folds to ~/.vim/view/
augroup remember_folds
  autocmd!
  au BufWinLeave ?* mkview 1
  au BufWinEnter ?* silent! loadview 1
augroup END

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
set formatoptions-=t " don't literally insert newlines
set nowrap " don't wrap w/ virtual lines either
" temporarily wrap current line
nnoremap <silent> <Space><Space> :SoftWrapShow<CR>
set noea  " don't auto-resize panes
set directory=/tmp
set backupdir=/tmp
set undofile  " keep an undo file (undo changes after closing)
set undodir=~/.vim/undodir  " put all undo files in a tidy dir
set iskeyword-=_  " word boundaries
set shellcmdflag=-c
let $BASH_ENV = "~/.bashrc_john.sh"  " expand aliases for non-interactive shells

" alleviate :W :WQ pain
command! W write
command! Q quit
command! Wq write <bar> quit

map <C-j> <C-e>
map <C-k> <C-y>

"keep visual mode after indent
vnoremap > >gv
vnoremap < <gv

set tabstop=4 shiftwidth=4 expandtab " every tab -> 4 spaces
autocmd FileType vim setlocal ts=2 sts=2 sw=2 expandtab  " vimscript
autocmd FileType lua setlocal ts=2 sts=2 sw=2 expandtab  " lua
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab  " yaml
autocmd FileType sql setlocal ts=2 sts=2 sw=2 expandtab  " sql
autocmd FileType yaml set nowrap  " yaml
au BufRead,BufNewFile *.ddl set ft=sql  " ddl is sql
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml " foldmethod=indent

" chrisbra/csv.vim CSVTable
let g:csv_table_leftalign=1
let g:csv_table_use_ascii=1
let g:csv_default_delim=','

" preservim/vim-markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_strikethrough = 1
" let g:vim_markdown_auto_insert_bullets = 0
" let g:vim_markdown_new_list_item_indent = 0
" preservim/vim-markdown
augroup markdown_conceal
  au!
  au BufRead,BufNewFile *.md set conceallevel=2  " md
  " don't conceal brackets
  au BufRead,BufNewFile *.md execute 'syn region mkdLink matchgroup=mkdDelimiter  start="\\\@<!!\?\[" end="\n\{-,1}[^]]\{-}\zs\]\ze[[(]" contains=@mkdNonListItem,@Spell nextgroup=mkdURL,mkdID skipwhite oneline'
augroup END

" pip install emoji-fzf
" Use emoji-fzf and fzf to fuzzy-search for emoji, and insert the result
function! InsertEmoji(emoji)
    let @a = system('cut -d " " -f 1 | emoji-fzf get', a:emoji)
    normal! "agP
endfunction

" :Emoj
command! -bang Emoj
  \ call fzf#run({
      \ 'source': 'emoji-fzf preview',
      \ 'options': '--preview-window=down,1 --preview ''emoji-fzf get --name {1}''',
      \ 'sink': function('InsertEmoji')
      \ })

" set fileformat=unix to fix trailing character issues
set list
set listchars=eol:$,tab:<->,trail:+,nbsp:_
set laststatus=2  " status line always
" cursorline for active window

" netrw customization
let g:netrw_keepdir = 1  " netrw cwd remains with OG nvim buffer's cwd
let g:netrw_fastbrowse = 0  " just close netrw after open file
let g:netrw_winsize = 30
let g:netrw_banner = 0

" space, y to copy last yank to clipboard
let mapleader = " "
map <leader>y :let @+=@0<CR>
" space, p to paste last yanked
map <leader>p "0p<CR>
" switch & preview buffers
map <leader>bb :Buffer<CR>


function! VertCursLock()
  nnoremap k kzz
  nnoremap j jzz
endfunction
command! -bang VertCursLock
  \ call VertCursLock()
function! NoVertCursLock()
  unmap k
  unmap j
endfunction
command! -bang NoVertCursLock
  \ call NoVertCursLock()

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

function YAMLGoToKey(key)
  let yqcmd = "yq '" . a:key . " | line' " . expand('%:p')
  let line = trim(system(yqcmd))
  execute "norm " . line . "gg"
endfunction
" :YAMLGoToKey
command! -nargs=1 -complete=command YAMLGoToKey call YAMLGoToKey(<q-args>)

" Cheat Sheets -----------------------
"
" vertical list of incrementing numbers
"   <CTRL-v> to highlight numbers you want to increment then g<CTRL-a>
"
" screen moves
"  <CTRL-u> scroll 1/2 page up
"  <CTRL-d> scroll 1/2 page down
"  <CTRL-j> scroll 1 line up
"  <CTRL-k> scroll 1 line down
"  zz center cursor line
"  zL 1/2 page right
"  zH 1/2 page left
"  ctrl+e up 1 line
"  ctrl+y down 1 line
"  zt top cursor line
"  zb top cursor line
"
" windows/pands
"   <CTRL-W => equally resize all windows
"   <CTRL-W _> max height
"   <CTRL-W |> max width
"
" csv.vim
"   <L> to move to right
"   <H> to move to left
"   :CSVArrangeColumn! to resize cols under cursor's row(s)
"   let g:csv_autocmd_arrange = 1
"
" folds
"   zM closes all open folds.
"   zR decreases the foldlevel to zero -- all folds will be open.
"
"   zf#j creates a fold from the cursor down # lines.
"   zf/string creates a fold from the cursor to string .
"   zj moves the cursor to the next fold.
"   zk moves the cursor to the previous fold.
"   zo opens a fold at the cursor.
"   zO opens all folds at the cursor.
"   zm increases the foldlevel by one.
"   zr decreases the foldlevel by one.
"   zd deletes the fold at the cursor.
"   zE deletes all folds.
"   [z move to start of open fold.
"   ]z move to end of open fold.
