""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" KEN CUSTOM ~/.vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" Change vim leader
let mapleader = ","

""""""""""""""""""""""""""""""""""""""""""
"" ColorScheme (ls -l /usr/share/vim/vim*/colors/)
""""""""""""""""""""""""""""""""""""""""""
"let g:solarized_termcolors=256
"colorscheme solarized
"colorscheme simple-dark
"colorscheme wombat256grf
colorscheme gruvbox

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Automatically make needed files and folders on first run
"call system("mkdir -p $HOME/.vim/{swap,undo}")
"if !filereadable($HOME . "/.vimrc.plugins") | call system("touch $HOME/.vimrc.plugins") | endif
"if !filereadable($HOME . "/.vimrc.first") | call system("touch $HOME/.vimrc.first") | endif
"if !filereadable($HOME . "/.vimrc.last") | call system("touch $HOME/.vimrc.last") | endif

"" Using VIM8 built-in plugin-in manager
"""""""""""""""""""""""""""""""""""
"" LIGHTLINE PLUGIN

let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'readonly', 'filename', 'modified', 'helloworld' ] ]
  \ },
  \ 'component': {
  \   'helloworld': 'Hello, world!'
  \ },
  \ }

"""""""""""""""""""""""""""""""""""""""""
"" FZF PLUGIN

set rtp+=~/.fzf

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Advanced customization using Vim function
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

" Replace the default dictionary completion with fzf-based fuzzy completion
inoremap <expr> <c-x><c-k> fzf#vim#complete('cat /usr/share/dict/words')

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" non-Plugin config below
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""
"" Use local config if it exists

"if filereadable($HOME . "/.vimrc.local")
"  source ~/.vimrc.local
"endif

""""""""""""""""""""""""""""""""""""""""""""
"" HOTKEYS

map <leader>e :Lexplore!<CR>

map <leader>- :set splitbelow<CR>
map <leader>% :set splitright<CR>

nnoremap <C-P> :bprev<CR>
nnoremap <C-N> :bnext<CR>
map <F9> :bprevious<CR>
map <F10> :bnext<CR>
map <leader>n :bnext<CR>
map <leader>p :prev<CR>

"" change to next/prev tab
map <F7> :tabp<CR>
map <F8> :tabn<CR>

"" toggle word wrap
map <F8> :set wrap!<CR>

"" to handle exiting insert mode via a control-C
inoremap <c-c> <c-o>:call InsertLeaveActions()<cr><c-c>

""""""""""""""""""""""""""""""""""""""""""""""
"" PASTE MODE (Auto set/unset vims paste mode)
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

""""""""""""""""""""""""""""""""""""""""""""""
"" PASTE MODE (Fix for Tmux)
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


"" toggle paste/nopaste
set pastetoggle=<F2>

""""""""""""""""""""""""""""""""""""""""""""
"" split navigations

"nnoremap <C-J> <C-W><C-J>
"nnoremap <C-K> <C-W><C-K>
"nnoremap <C-L> <C-W><C-L>
"nnoremap <C-H> <C-W><C-H>

"""""""""""""""""""""""""""""""""""""""""""
"" Moving around
" Buffer switching left, down, up, right
map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext

" Tab switchting
map <D-1> 1gt
map <D-2> 2gt
map <D-3> 3gt
map <D-4> 4gt
map <D-5> 5gt
map <D-6> 6gt
map <D-7> 7gt
map <D-8> 8gt
map <D-9> 9gt
map <D-0> :tablast<CR>

""""""""""""""""""""""""""""""""""""""""""
"" Enable folding

set foldmethod=indent
set foldlevel=99

"" Enable folding with the spacebar
nnoremap <space> za

"""""""""""""""""""""""""""""""""""""""""
"" Custom options per file type

au BufNewFile,BufRead *.py
  \ set tabstop=4
  \ set softtabstop=4
  \ set shiftwidth=4
  \ set textwidth=79
  \ set expandtab
  \ set autoindent
  \ set fileformat=unix

au BufNewFile,BufRead *.js, *.html, *.css, *.sh
  \ set tabstop=2
  \ set softtabstop=2
  \ set shiftwidth=2
            
"" Flagging Unnecessary Whitespace
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

"" Wrap text at 80 characters
au BufRead,BufNewFile *.md setlocal textwidth=80

"" Set syntax highlighting for specific file types
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
autocmd BufRead,BufNewFile .bash*,*/zsh/configs/* set filetype=sh
autocmd BufRead,BufNewFile gitconfig.local set filetype=gitconfig
autocmd BufRead,BufNewFile tmux.conf.local set filetype=tmux
autocmd BufRead,BufNewFile vimrc.local set filetype=vim

"""""""""""""""""""""""""""""""""""""""""
"" Settings

set list listchars=eol:$,trail:∙ listchars+=tab:│\  fillchars+=vert:│,fold:\

set nocompatible          " vimconf is not vi-compatible
filetype plugin on        " Needed by vimwiki
set nolist                " Turn off special characters (like $ at end of line) for the current buffer
syntax on                 " Enable syntax highlighting
set noswapfile            " Do not use swap file
set hidden                " Switch buffers without the need of saving them
set clipboard=unnamed     " Copy to clipboard when yanking text with yy/dd etc
"set colorcolumn=80       " render a visual column at 80 characters
set lazyredraw            " redraw screen only when we need to
set magic
set encoding=utf-8        " set encoding to UTF-8
set modelines=0
set formatoptions=tqn1
set cmdheight=1
set backspace=indent,eol,start " Fix backspace

" Treat wrapped lines as normal lines
nnoremap j gj
nnoremap k gk

""""""""""""""""""""""""""""""""""""""""""""""
"" Status line

set laststatus=2        " always show Status bar

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

" Status Line old custom {
"  set statusline=
"  set statusline+=[%n]\                          " buffer number
"  set statusline+=%#DiffChange#                " color
"  set statusline+=%{StatuslineGit()}           " git status line
"  set statusline+=%#TabLineFill#               " color
  "set statusline+=%-10.3n\                     " buffer number
"  set statusline+=\ %F                         " file name
"  set statusline+=%m                           " status flags
  "set statusline+=\ %#ModeMsg#                 " color
"  set statusline+=%=                           " right align remainder
"  set statusline+=%#TabLineFill#               " color
"  set statusline+=\ [%l:%c]                    " line, character
"  set statusline+=\ (%p%%)                     " file position
"  set statusline+=\ %y
"  set statusline+=\[%{&fileformat}\]
"  set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
"}

"##################################################################
" status bar

" Status Line Custom
let g:currentmode={
    \ 'n'  : 'Normal',
    \ 'no' : 'Normal·Operator Pending',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V·Line',
    \ '^V' : 'V·Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ '^S' : 'S·Block',
    \ 'i'  : 'Insert',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal'
    \}

set noshowmode
set statusline=
set statusline+=%0*\ %n\                                 " Buffer number
set statusline+=%{StatuslineGit()}                       " Git branch
set statusline+=%1*\ %<%F%m%r%h%w\                       " File path, modified, readonly, helpfile, preview
set statusline+=%3*│                                     " Separator
set statusline+=%2*\ %Y\                                 " FileType
set statusline+=%3*│                                     " Separator
set statusline+=%2*\ %{''.(&fenc!=''?&fenc:&enc).''}     " Encoding
set statusline+=\ (%{&ff})                               " FileFormat (dos/unix..)
set statusline+=%=                                       " Right Side
set statusline+=%2*\ col:\ %02v\                         " Colomn number
set statusline+=%3*│                                     " Separator
set statusline+=%1*\ ln:\ %02l/%L\ (%3p%%)\              " Line number / total lines, percentage of document
set statusline+=%0*\ %{toupper(g:currentmode[mode()])}\  " The current mode

hi User1 ctermfg=007 ctermbg=239 guibg=#4e4e4e guifg=#adadad
hi User2 ctermfg=007 ctermbg=236 guibg=#303030 guifg=#adadad
hi User3 ctermfg=236 ctermbg=236 guibg=#303030 guifg=#303030
hi User4 ctermfg=239 ctermbg=239 guibg=#4e4e4e guifg=#4e4e4e
"##################################################################

set scrolloff=3         " Keep at least 3 lines above/below when scrolling
set ruler               " show file stats
set number              " show line numbers
"set nonumber            " Do not show line numbers
"set relativenumber      " make line numbers relative to the current line
"set signcolumn=yes      " always show the sign column, e.g. where lint errors are marked
set cursorline          " underlines the line where the cursor is
set showmode
set showcmd

"""""""""""""""""""""""""""""""""""""""""""
"" Line wrapping

set nowrap            " no wrap lines
"set showbreak=\ \ \ \ " indent wrapped lines

"""""""""""""""""""""""""""""""""""""""""""""
"" Search settings

set matchtime=2       " time to blink match {}
set matchpairs+=<:>   " for ci< or ci>
set showmatch         " tmpjump to match-bracket

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


"""""""""""""""""""""""""""""""""""""""""""""""
"" Miscellaneous

set mouse=a           " enable mouse support
set fileformat=unix   " force unix fileformat

nnoremap <leader>b :ls<CR>:b<Space>

nnoremap ,b :buffer *
nnoremap <F5> :buffers<CR>:buffer<Space>

set wildmenu
set wildignore+=*.swp,*.bak
set wildignore+=*.pyc,*.class,*.sln,*.Master,*.csproj,*.csproj.user,*.cache,*.dll,*.pdb,*.min.*
set wildignore+=*/.git/**/*,*/.hg/**/*,*/.svn/**/*
set wildignore+=*/min/*,*/vendor/*,*/node_modules/*,*/bower_components/*
set wildignore+=tags,cscope.*
set wildignore+=*.tar.*
set wildignorecase
set wildmode=full

""""""""""""""""""""""""""""""""""""""""""""""""
"" Tab/Space settings

set tabstop=2         " width that a <TAB> character displays as
set softtabstop=2     " backspace after pressing <TAB> will remove up to this many spaces
set expandtab         " convert <TAB> key-presses to spaces
set shiftwidth=2      " number of spaces to use for each step of (auto)indent
set autoindent        " copy indent from current line when starting a new line
set smartindent       " even better autoindent (e.g. add indent after '{')

""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Whitespace

"set textwidth=79
"set formatoptions=tcqrn1
set noshiftround

"""""""""""""""""""""""""""""""""""""""""""""""""
"" COLOR OPTIONS

noh

"set t_Co=256              " Use 256 colors
if &term == "screen"
  set t_Co=256
endif

set background=dark       " Use a dark background

"""""""""""""""""""""""""""""""""""""""
"" COMPLETION

" better completion menu (tab | tab/shift-tab)
"inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

" Use tab to trigger completion and tab/shift-tab to navigate results
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : coc#refresh()
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

""""""""""""""""""""""""""""""""""""""""""""""""""
"" CUSTOM COLORS

" https://vim.fandom.com/wiki/Change_statusline_color_to_show_insert_or_normal_mode

" Set StatusLine colors to change when enter/leave modes
"au InsertEnter * hi StatusLine ctermbg=223 ctermfg=31
"au InsertLeave * hi StatusLine ctermbg=223 ctermfg=239

" Highlight CursorLine when enter/leaving modes
"hi CursorLine ctermbg=237 cterm=none
"set nocursorline
"au InsertEnter * set cursorline
"au InsertLeave * set nocursorline

"" custom theme """"""""""""""""
" Default the statusline when entering Vim
hi statusline ctermbg=223 ctermfg=31
" Set StatusLine colors to change when enter/leave modes
au InsertEnter * hi StatusLine ctermbg=223 ctermfg=88
au InsertLeave * hi StatusLine ctermbg=223 ctermfg=31
" Highlight CursorLine when enter/leaving modes
set cursorline
au InsertEnter * hi CursorLine ctermbg=236 ctermfg=none
au InsertLeave * hi CursorLine ctermbg=242 ctermfg=none
hi CursorLine                  ctermbg=242 ctermfg=none
"""""""""""""""""

"hi pmenu ctermbg=0 ctermfg=NONE
"hi pmenusel ctermbg=4 ctermfg=0
"hi pmenusbar ctermbg=0
"hi pmenuthumb ctermbg=7
"hi matchparen ctermbg=0 ctermfg=NONE
"hi search ctermbg=0 ctermfg=NONE
"hi statusline ctermbg=0 ctermfg=NONE
"hi statuslinenc ctermbg=0 ctermfg=0
" -------------------------------------
"highlight Comment ctermbg=DarkGray
"highlight Constant ctermbg=Blue
"highlight Normal ctermbg=Black
"highlight NonText ctermbg=Black
"highlight Special ctermbg=DarkMagenta
"highlight Cursor ctermbg=Green

