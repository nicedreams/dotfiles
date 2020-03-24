"""""""""""""""""""""""""
" TMUX FIXES            "
"""""""""""""""""""""""""

" Colourscheme background fix
if exists('$TMUX')
  set term=screen-256color
endif

" Status cursor shape
if exists('$ITERM_PROFILE')
  if exists('$TMUX') 
    let &t_SI = "\<Esc>[3 q"
    let &t_EI = "\<Esc>[0 q"
  else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  endif
end

" Indentation at pasting
" for tmux to automatically set paste and nopaste mode at the time pasting (as
" happens in VIM UI)

function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

"""""""""""""""""""""""""""
" non-Plugin config below "
"""""""""""""""""""""""""""

noh
syntax on             " turn on syntax highlighting
"set colorcolumn=80    " render a visual column at 80 characters
set t_Co=256          " use 256 colors
"set t_Co=16
set background=dark   " configure Vim to use brighter colors
set nocompatible      " be iMproved
set lazyredraw        " redraw screen only when we need to
set magic
set encoding=utf-8    " set encoding to UTF-8
set modelines=0
set formatoptions=tqn1
set cmdheight=1
set backspace=indent,eol,start
set list
set listchars=tab:\│\ 
set matchpairs+=<:>

"" Status line ------------------------------------------------------
set laststatus=2      " always show Status bar
"set noshowmode        " don't show -- INSERT --, pointless as we have a status bar

set statusline=%1*\ file\ %3*\ %f\ %4*\ 
set statusline+=%=\ 
set statusline+=%3*\ %l\ of\ %L\ %2*\ line\ 

set scrolloff=5
set ruler             " show file stats
set number            " show line numbers
set relativenumber    " make line numbers relative to the current line
"set signcolumn=yes    " always show the sign column, e.g. where lint errors are marked
set cursorline        " highlight current line
set showmode
set showcmd

"" Line wrapping
"set wrap              " wrap lines
set nowrap            " no wrap lines
set showbreak=\ \ \ \ " indent wrapped lines

"" Search settings ------------------------------------------------------
set incsearch         " search as characters are entered
set ignorecase        " case insensitive
set smartcase         " (uses set ignorecase)
set hlsearch          " highlight matches
" turn off search highlighting with <CR> (carriage-return)
nnoremap <CR> :nohlsearch<CR><CR>
" make sarches always appear in centre of page
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
" clear search highlighting with enter
nnoremap <cr> :noh<CR><CR>:<backspace>


"" Miscellaneous ------------------------------------------------------
set mouse=a           " enable mouse support
set fileformat=unix   " force unix fileformat
:set wildmenu          " visual autocomplete for command menu
set wildmode=longest:full,full  " make tab completion in wildmenu work like bash
set wildmenu          " visual autocomplete for command menu

"" Tab/Space settings --------------------------------------------------
set tabstop=2         " width that a <TAB> character displays as
set softtabstop=2     " backspace after pressing <TAB> will remove up to this many spaces
set expandtab         " convert <TAB> key-presses to spaces
set shiftwidth=2      " number of spaces to use for each step of (auto)indent
set autoindent        " copy indent from current line when starting a new line
set smartindent       " even better autoindent (e.g. add indent after '{')

"" Whitespace ------------------------------------------------------
"set textwidth=79
"set formatoptions=tcqrn1
set noshiftround

"" -------------------------------------------------------------------
nmap <C-S> :w<CR>
nmap <C-_> :noh<CR>
nmap <S-Left> v<Left>
nmap <S-Right> v<Right>
nmap <C-Up> 8k
nmap <C-Down> 8j
nmap <C-O> o<Esc>
nmap <C-Z> u
nmap <C-Y> <C-R>
nmap <C-F> /
nmap <C-H> i<C-W><Esc>
nmap <F3> :set invnumber<CR>
nmap <F4> :q<CR>

imap <C-S> <Esc>:w<CR>a
imap <C-_> <Esc>:noh<CR>a
imap <S-Left> <Esc>lv<Left>
imap <S-Right> <Esc>lv<Right>
imap <C-Up> <Esc>8ka
imap <C-Down> <Esc>8ja
imap <C-O> <Esc>o
imap <C-Z> <Esc>ua
imap <C-Y> <Esc><C-R>a
imap <Nul> <C-N>
imap <C-F> <Esc>/
imap <C-H> <C-W>
imap <C-V> <Esc>pa
imap <F3> <Esc>:set invnumber<CR>a
imap <F4> <Esc>:q<CR>
vmap <C-Up> 8k
vmap <C-Down> 8j

"" Custom Colors ------------------------------------------------------
hi linenr ctermfg=0
hi cursorline cterm=NONE
"hi cursorlinenr ctermfg=8
"hi comment ctermfg=8
hi pmenu ctermbg=0 ctermfg=NONE
hi pmenusel ctermbg=4 ctermfg=0
hi pmenusbar ctermbg=0
hi pmenuthumb ctermbg=7
hi matchparen ctermbg=0 ctermfg=NONE
hi search ctermbg=0 ctermfg=NONE
hi statusline ctermbg=0 ctermfg=NONE
hi statuslinenc ctermbg=0 ctermfg=0
hi user1 ctermbg=1 ctermfg=0
hi user2 ctermbg=4 ctermfg=0
hi user3 ctermbg=0 ctermfg=NONE
hi user4 ctermbg=NONE ctermfg=NONE
hi group1 ctermbg=NONE ctermfg=0
autocmd colorscheme * hi clear cursorline
match group1 /\t/
" -------------------------------------
"highlight Comment ctermbg=DarkGray
"highlight Constant ctermbg=Blue
"highlight Normal ctermbg=Black
"highlight NonText ctermbg=Black
"highlight Special ctermbg=DarkMagenta
"highlight Cursor ctermbg=Green

"" ColorScheme (ls -l /usr/share/vim/vim*/colors/) ----------------
"colorscheme fansi

" ======== COMPLETION ========

" Use tab to trigger completion and tab/shift-tab to navigate results
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Close preview pane once completion is
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" use ctrl-j, ctrl-k for selecting omni completion entries
inoremap <expr> <C-j> pumvisible() ? '<C-n>' : ''
inoremap <expr> <C-k> pumvisible() ? '<C-p>' : ''

" select omni completion entry with enter (always supress newline)
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"
