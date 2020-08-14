" ╔════════════════════════════════════════════════════════════════════════════╗
" ║                                                                            ║
" ║ ~/.vimrc                                                                   ║
" ║                                                                            ║
" ║ non-plugin config below                                                    ║
" ╚════════════════════════════════════════════════════════════════════════════╝

"" Change vim leader
let mapleader = ","

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ netrw - NERDTree like setup                                                ║
" ╚════════════════════════════════════════════════════════════════════════════╝
let g:netrw_altv = 1

" absolute width of netrw window
let g:netrw_winsize = -28
" do not display info on the top of window
let g:netrw_banner = 0
" tree-view
let g:netrw_liststyle = 3
" sort is affecting only: directories on the top, files below
let g:netrw_sort_sequence = '[\/]$,*'
" use the previous window to open file
let g:netrw_browse_split = 4

function! ToggleLExplorer()
    if exists("t:expl_buf_num")
        let expl_win_num = bufwinnr(t:expl_buf_num)
        let cur_win_num = winnr()

        if expl_win_num != -1
            while expl_win_num != cur_win_num
                exec "wincmd w"
                let cur_win_num = winnr()
            endwhile

            close
        endif

        unlet t:expl_buf_num
    else
         Lexplore
         let t:expl_buf_num = bufnr("%")
    endif
endfunction

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ ColorScheme (ls -l /usr/share/vim/vim*/colors/)                            ║
" ╚════════════════════════════════════════════════════════════════════════════╝
"let g:solarized_termcolors=256
"colorscheme solarized
"colorscheme simple-dark
"colorscheme wombat256grf
"colorscheme seoul256
"colorscheme onedark
"colorscheme gruvbox

if filereadable($HOME . "/.vim/colors/gruvbox.vim")
  colorscheme gruvbox
else
  colorscheme peachpuff
endif

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ Source config files if exists                                              ║
" ╚════════════════════════════════════════════════════════════════════════════╝
if filereadable($HOME . "/.vim/plugins.vim")
  source ~/.vim/plugins.vim
endif

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ Automatically make needed files and folders on first run                   ║
" ╚════════════════════════════════════════════════════════════════════════════╝
"call system("mkdir -p $HOME/.vim/{swap,undo}")
"if !filereadable($HOME . "/.vimrc.plugins") | call system("touch $HOME/.vimrc.plugins") | endif
"if !filereadable($HOME . "/.vimrc.first") | call system("touch $HOME/.vimrc.first") | endif
"if !filereadable($HOME . "/.vimrc.last") | call system("touch $HOME/.vimrc.last") | endif

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ PASTE MODE (Auto set/unset vims paste mode)                                ║
" ╚════════════════════════════════════════════════════════════════════════════╝
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ PASTE MODE (Fix for Tmux)                                                  ║
" ╚════════════════════════════════════════════════════════════════════════════╝
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

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ HOTKEYS                                                                    ║
" ╚════════════════════════════════════════════════════════════════════════════╝

"" map ctrl+w to ,w
"nnoremap <Leader>w <C-w>

map <leader>- :set splitbelow<CR>
map <leader>% :set splitright<CR>

"" change to next/previous buffer
nnoremap <C-P> :bprev<CR>
nnoremap <C-N> :bnext<CR>
map <leader>n :bnext<CR>
map <leader>N :prev<CR>

"" close current buffer
map <leader>d :bd<CR>

"" open explorer
map <leader>e :Lexplore<CR>

"" to handle exiting insert mode via a control-C
inoremap <c-c> <c-o>:call InsertLeaveActions()<cr><c-c>

"" toggle paste/nopaste
set pastetoggle=<F2>

" Buffer switching left, down, up, right
map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l

" make J, K, L, and H move the cursor MORE.
nnoremap J }
nnoremap K {
nnoremap L g_
nnoremap H ^

" make <c-j>, <c-k>, <c-l>, and <c-h> scroll the screen.
"inoremap <A-h> <C-o>h
"inoremap <A-j> <C-o>j
"inoremap <A-k> <C-o>k
"inoremap <A-l> <C-o>l

" provide hjkl movements in Insert mode and Command-line mode via the <Alt> modifier key
noremap! <A-h> <Left>
noremap! <A-j> <Down>
noremap! <A-k> <Up>
noremap! <A-l> <Right>

" make <a-j>, <a-k>, <a-l>, and <a-h> move to window.
"nnoremap <a-j> <c-w>j
"nnoremap <a-k> <c-w>k
"nnoremap <a-l> <c-w>l
"nnoremap <a-h> <c-w>h

" make <a-J>, <a-K>, <a-L>, and <a-H> create windows.
"nnoremap <a-J> <c-w>s<c-w>k
"nnoremap <a-K> <c-w>s
"nnoremap <a-H> <c-w>v
"nnoremap <a-L> <c-w>v<c-w>h

"" change to next/prev tab
map <leader>t :tabn<CR>
map <leader>T :tabp<CR>

" Useful mappings for managing tabs
"map <leader>tn :tabnew<cr>
"map <leader>to :tabonly<cr>
"map <leader>tc :tabclose<cr>
"map <leader>tm :tabmove
"map <leader>t<leader> :tabnext

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ enable folding                                                             ║
" ╚════════════════════════════════════════════════════════════════════════════╝
set foldmethod=indent
set foldlevel=99

"" Enable folding with the spacebar
nnoremap <space> za

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ custom options per file type                                               ║
" ╚════════════════════════════════════════════════════════════════════════════╝
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
            
" ══════════════════════════════════════════════════════════════════════════════
"" Flagging Unnecessary Whitespace
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" ══════════════════════════════════════════════════════════════════════════════
"" Wrap text at 80 characters
au BufRead,BufNewFile *.md setlocal textwidth=80

" ══════════════════════════════════════════════════════════════════════════════
"" Set syntax highlighting for specific file types
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
autocmd BufRead,BufNewFile .bash*,*/zsh/configs/* set filetype=sh
autocmd BufRead,BufNewFile gitconfig.local set filetype=gitconfig
autocmd BufRead,BufNewFile tmux.conf.local set filetype=tmux
autocmd BufRead,BufNewFile vimrc.local set filetype=vim

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ Settings                                                                   ║
" ╚════════════════════════════════════════════════════════════════════════════╝
set list listchars=eol:$,trail:∙ listchars+=tab:│\  fillchars+=vert:│,fold:\

set nocompatible          " vimconf is not vi-compatible
filetype plugin on        " Needed by vimwiki
set nolist                " Turn off special characters (like $ at end of line) for the current buffer
syntax on                 " Enable syntax highlighting
set noswapfile            " Do not use swap file
set hidden                " Switch buffers without the need of saving them
set clipboard=unnamedplus " Copy to clipboard when yanking text with yy/dd etc
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

" ══════════════════════════════════════════════════════════════════════════════

set scrolloff=3         " Keep at least 3 lines above/below when scrolling
set ruler               " show file stats
"set relativenumber      " make line numbers relative to the current line
"set signcolumn=yes      " always show the sign column, e.g. where lint errors are marked
set cursorline          " underlines the line where the cursor is
set showmode
set showcmd

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ line numbers                                                               ║
" ╚════════════════════════════════════════════════════════════════════════════╝
set number              " show line numbers
nmap <C-N> :set invnumber<CR>
" toggle line numbers both in normal and insert mode (two mappings)
"noremap <F3> :set invnumber<CR>
"inoremap <F3> <C-O>:set invnumber<CR>

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ line wrapping                                                              ║
" ╚════════════════════════════════════════════════════════════════════════════╝
set nowrap            " no wrap lines
"set showbreak=\ \ \ \ " indent wrapped lines

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ search settings                                                            ║
" ╚════════════════════════════════════════════════════════════════════════════╝
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

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ Miscellaneous                                                              ║
" ╚════════════════════════════════════════════════════════════════════════════╝
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

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ tab/space settings                                                         ║
" ╚════════════════════════════════════════════════════════════════════════════╝
set tabstop=2         " width that a <TAB> character displays as
set softtabstop=2     " backspace after pressing <TAB> will remove up to this many spaces
set expandtab         " convert <TAB> key-presses to spaces
set shiftwidth=2      " number of spaces to use for each step of (auto)indent
set autoindent        " copy indent from current line when starting a new line
set smartindent       " even better autoindent (e.g. add indent after '{')

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ whitespace                                                                 ║
" ╚════════════════════════════════════════════════════════════════════════════╝
"set textwidth=79
"set formatoptions=tcqrn1
set noshiftround

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ color options                                                              ║
" ╚════════════════════════════════════════════════════════════════════════════╝
noh

"set t_Co=256              " Use 256 colors
if &term == "screen"
  set t_Co=256
endif

set background=dark       " Use a dark background

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ completion                                                                 ║
" ╚════════════════════════════════════════════════════════════════════════════╝
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

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ STATUS BAR                                                                 ║
" ╚════════════════════════════════════════════════════════════════════════════╝
set laststatus=2        " always show Status bar
" ══════════════════════════════════════════════════════════════════════════════
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

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
" ══════════════════════════════════════════════════════════════════════════════
function! StatuslineMode()
  let l:mode=mode()
  if l:mode==#"n"
    return "NORMAL "
  elseif l:mode==?"v"
   return "VISUAL "
  elseif l:mode==#"i"
    return "INSERT "
  elseif l:mode==#"R"
    return "REPLACE "
  elseif l:mode==?"s"
    return "SELECT "
  elseif l:mode==#"t"
    return "TERMINAL "
  elseif l:mode==#"c"
    return "COMMAND "
  elseif l:mode==#"!"
    return "SHELL "
  endif
endfunction

function! StatuslineGitBranch()
  let b:gitbranch=""
  if &modifiable
    try
      let l:dir=expand('%:p:h')
      let l:gitrevparse = system("git -C ".l:dir." rev-parse --abbrev-ref HEAD")
      if !v:shell_error
        let b:gitbranch="(".substitute(l:gitrevparse, '', '', 'g').") "
      endif
    catch
    endtry
  endif
endfunction

augroup GetGitBranch
  autocmd!
  autocmd VimEnter,WinEnter,BufEnter * call StatuslineGitBranch()
augroup END

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ STATUSLINE FORMATTING                                                      ║
" ╚════════════════════════════════════════════════════════════════════════════╝
set noshowmode
set statusline=
set statusline+=%0*\ %{StatuslineMode()}                    " The current mode (function 2)
set statusline+=%2*\ %n\                                   " Buffer number
"set statusline+=%4*\%{StatuslineGit()}                     " Git branch (function 1)
set statusline+=%4*\%{b:gitbranch}                         " Git branch (function 2)
set statusline+=%1*\ %<%F%m%r%h%w\                         " File path, modified, readonly, helpfile, preview
"set statusline+=%2*\ %{''.(&fenc!=''?&fenc:&enc).''}       " Encoding (utf-8)
"set statusline+=\ (%{&ff})                                 " FileFormat (dos/unix..)
set statusline+=%3*│                                       " Separator
set statusline+=%=                                         " Right Side --------
set statusline+=%2*\ (%Y)\                                   " FileType
"set statusline+=%2*\ col:\ %02v\                           " Colomn number
set statusline+=%1*\ ln:\ %02l/%L\ (%3p%%)\                " Line number / total lines, percentage of document
"set statusline+=%0*\ %{toupper(g:currentmode[mode()])}\    " The current mode (function 1)

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ CUSTOM COLORS                                                              ║
" ╚════════════════════════════════════════════════════════════════════════════╝
" https://vim.fandom.com/wiki/Change_statusline_color_to_show_insert_or_normal_mode

" Set StatusLine colors to change when enter/leave modes
" ══════════════════════════════════════════════════════════════════════════════
"" Custom StatusLine theme
"au InsertEnter * hi StatusLine ctermbg=223 ctermfg=31
"au InsertLeave * hi StatusLine ctermbg=223 ctermfg=239

" Default the statusline when entering Vim
"hi statusline ctermbg=223 ctermfg=31
" Set StatusLine colors to change when enter/leave modes
"au InsertEnter * hi StatusLine ctermbg=223 ctermfg=41
"au InsertLeave * hi StatusLine ctermbg=223 ctermfg=31

" Default the statusline when entering Vim
hi statusline ctermbg=255 ctermfg=31
" Set StatusLine colors to change when enter/leave modes
au InsertEnter * hi StatusLine ctermbg=255 ctermfg=41
au InsertLeave * hi StatusLine ctermbg=255 ctermfg=31

" ══════════════════════════════════════════════════════════════════════════════
"" Highlight CursorLine when enter/leaving modes
" Highlight CursorLine when enter/leaving modes
"hi CursorLine ctermbg=237 cterm=none
"set nocursorline
"au InsertEnter * set cursorline
"au InsertLeave * set nocursorline

set cursorline
au InsertEnter * hi CursorLine ctermbg=236 ctermfg=none
au InsertLeave * hi CursorLine ctermbg=31 ctermfg=none
hi CursorLine                  ctermbg=31 ctermfg=none

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ Change color used for line numbers                                         ║
" ╚════════════════════════════════════════════════════════════════════════════╝
"hi LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ USER DEFINED COLORS                                                        ║
" ╚════════════════════════════════════════════════════════════════════════════╝
"hi pmenu ctermbg=0 ctermfg=NONE
"hi pmenusel ctermbg=4 ctermfg=0
"hi pmenusbar ctermbg=0
"hi pmenuthumb ctermbg=7
"hi matchparen ctermbg=0 ctermfg=NONE
"hi search ctermbg=0 ctermfg=NONE
"hi statusline ctermbg=0 ctermfg=NONE
"hi statuslinenc ctermbg=0 ctermfg=0
" ══════════════════════════════════════════════════════════════════════════════
"highlight Comment ctermbg=DarkGray
"highlight Constant ctermbg=Blue
"highlight Normal ctermbg=Black
"highlight NonText ctermbg=Black
"highlight Special ctermbg=DarkMagenta
"highlight Cursor ctermbg=Green

hi User1 ctermfg=007 ctermbg=239 guibg=#4e4e4e guifg=#adadad
hi User2 ctermfg=007 ctermbg=236 guibg=#303030 guifg=#adadad
hi User3 ctermfg=236 ctermbg=236 guibg=#303030 guifg=#303030
hi User4 ctermfg=007 ctermbg=056 guibg=#4e4e4e guifg=#4e4e4e

"hi User1 ctermfg=255 ctermbg=160 guifg=#ffdad8  guibg=#880c0e
"hi User2 ctermfg=255 ctermbg=166 guifg=#000000  guibg=#F4905C
"hi User3 ctermfg=255 ctermbg=226 guifg=#292b00  guibg=#f4f597
"hi User4 ctermfg=255 ctermbg=112 guifg=#112605  guibg=#aefe7B
"hi User5 ctermfg=255 ctermbg=113 guifg=#051d00  guibg=#7dcc7d
"hi User7 ctermfg=255 ctermbg=114 guifg=#ffffff  guibg=#880c0e gui=bold
"hi User8 ctermfg=255 ctermbg=117 guifg=#ffffff  guibg=#5b7fbb
"hi User9 ctermfg=255 ctermbg=129 guifg=#ffffff  guibg=#810085
"hi User0 ctermfg=255 ctermbg=240 guifg=#ffffff  guibg=#094afe

" ══════════════════════════════════════════════════════════════════════════════
" Load local machine settings if they exist
if filereadable(glob("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif

