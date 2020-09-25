" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ ~/.vimrc                                                                   ║
" ╚════════════════════════════════════════════════════════════════════════════╝

" Automatically make needed files and folders on first run --------------------
"call system("mkdir -p $HOME/.vim/{swap,undo}")
"if !filereadable($HOME . "/.vim/plugins.vim") | call system("touch $HOME/.vim/plugins.vim") | endif

" Source plugin config file if exists -----------------------------------------
if filereadable($HOME . "/.vim/plugins.vim")
  source ~/.vim/plugins.vim
endif

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ Non-plugin config below                                                    ║
" ╚════════════════════════════════════════════════════════════════════════════╝

" reset to vim-defaults -------------------------------------------------------
if &compatible                    " only if not set before:
  set nocompatible                " use vim-defaults instead of vi-defaults (easier, more user friendly)
endif

" display settings ------------------------------------------------------------
set background=dark               " enable for dark terminals
set nowrap                        " dont wrap lines
set scrolloff=2                   " 2 lines above/below cursor when scrolling
set number                        " show line numbers
set showmatch                     " show matching bracket (briefly jump)
set showmode                      " show mode in status bar (insert/replace/...)
set showcmd                       " show typed command in status bar
set ruler                         " show cursor position in status bar
set title                         " show file in titlebar
set matchtime=2                   " show matching bracket for 0.2 seconds
set matchpairs+=<:>               " specially for html
"set colorcolumn=80               " render a visual column at 80 characters
set encoding=utf-8                " set encoding to UTF-8
set nolist                        " Turn off special characters (like $ at end of line) for the current buffer
"set list listchars=eol:$,trail:∙ listchars+=tab:│\  fillchars+=vert:│,fold:\

" editor settings -------------------------------------------------------------
set esckeys                       " map missed escape sequences (enables keypad keys)
set ignorecase                    " case insensitive searching
set smartcase                     " but become case sensitive if you type uppercase characters
set smartindent                   " smart auto indenting
set smarttab                      " smart tab handling for indenting
set magic                         " change the way backslashes are used in search patterns
set bs=indent,eol,start           " Allow backspacing over everything in insert mode
set autoindent                    " copy indent from current line when starting a new line
set modelines=0
set formatoptions=tqn1
set cmdheight=1
set backspace=indent,eol,start    " Fix backspace
set relativenumber                " make line numbers relative to the current line
"set signcolumn=yes               " always show the sign column, e.g. where lint errors are marked
set cursorline                    " underlines the line where the cursor is
set tabstop=2                     " number of spaces a tab counts for
set shiftwidth=2                  " spaces for autoindents
set softtabstop=2                 " backspace after pressing <TAB> will remove up to this many spaces
set expandtab                     " turn a tabs into spaces

set fileformat=unix               " file mode is unix
"set fileformats=unix,dos         " only detect unix file format, displays that ^M with dos files

" system settings -------------------------------------------------------------
set lazyredraw                    " no redraws in macros
set confirm                       " get a dialog when :q, :w, or :wq fails
set nobackup                      " no backup~ files.
set viminfo='20,\"500             " remember copy registers after quitting in the .viminfo file -- 20 jump links, regs up to 500 lines'
set hidden                        " remember undo after quitting
set history=50                    " keep 50 lines of command history
set mouse=a                       " use mouse in visual mode (not normal,insert,command,help mode (change v to a for all)
set clipboard=unnamed,unnamedplus " Copy to clipboard when yanking text with yy/dd etc

" wildmenu settings -----------------------------------------------------------
set wildmenu                      " completion with menu
set wildignore=*.o,*.obj,*.bak,*.exe,*.py[co],*.swp,*~,*.pyc,.svn
set wildignore+=*.swp,*.bak
set wildignore+=*.pyc,*.class,*.sln,*.Master,*.csproj,*.csproj.user,*.cache,*.dll,*.pdb,*.min.*
set wildignore+=*/.git/**/*,*/.hg/**/*,*/.svn/**/*
set wildignore+=*/min/*,*/vendor/*,*/node_modules/*,*/bower_components/*
set wildignore+=tags,cscope.*
set wildignore+=*.tar.*
set wildignorecase
set wildmode=longest:full,full

" folding ---------------------------------------------------------------------
set foldmethod=indent
set foldlevel=99
nnoremap <space> za               " Enable folding with the spacebar

" color settings (if terminal/gui supports it) --------------------------------
if &t_Co > 2 || has("gui_running")
  syntax on                       " enable colors
  set hlsearch                    " highlight search (very useful!)
  set incsearch                   " search incremently (search while typing)
endif

" ColorScheme (ls -l /usr/share/vim/vim*/colors/) -----------------------------
if filereadable($HOME . "/.vim/colors/gruvbox.vim")
  colorscheme gruvbox
else
  colorscheme peachpuff
endif

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ HOTKEYS                                                                    ║
" ╚════════════════════════════════════════════════════════════════════════════╝
let mapleader = ","               " Change vim leader

nnoremap <CR> :nohlsearch<CR><CR>       " turn off search highlighting with <CR> (carriage-return)
"nnoremap <cr> :noh<CR><CR>:<backspace>  " clear search highlighting with enter

" treat wrapped lines as normal lines
nnoremap j gj
nnoremap k gk

" Map ctrl+w to ,w
nnoremap <Leader>w <C-w>
map <leader>- :set splitbelow<CR>
map <leader>% :set splitright<CR>

" Change to next/previous buffer
map <leader>n :bnext<CR>
map <leader>N :prev<CR>

map <leader>d :bd<CR>             " Close current buffer
inoremap <c-c> <c-o>:call InsertLeaveActions()<cr><c-c>  " To handle exiting insert mode via a control-C
set pastetoggle=<F2>              " toggle paste/nopaste

" Make JKLH move the cursor MORE.
nnoremap J }
nnoremap K {
nnoremap L g_
nnoremap H ^

"" WINDOW SPLITS
" Navigate between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" More natural split opening
set splitbelow
set splitright

"" TABS
" change to next/prev tab
"map <leader>t :tabn<CR>
"map <leader>T :tabp<CR>
" Useful mappings for managing tabs
"map <leader>tn :tabnew<cr>
"map <leader>to :tabonly<cr>
"map <leader>tc :tabclose<cr>
"map <leader>tm :tabmove
"map <leader>t<leader> :tabnext

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ Custom options per file type                                               ║
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
            
" -----------------------------------------------------------------------------
" Flagging Unnecessary Whitespace
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" -----------------------------------------------------------------------------
" Markdown
"autocmd BufNewFile,BufRead *.md set filetype=markdown    " Treat all .md files as markdown
"autocmd FileType markdown set conceallevel=2             " Hide and format markdown elements like **bold**
"autocmd BufRead,BufNewFile *.md set filetype=markdown    " Set syntax highlighting for markdown file type
"au BufRead,BufNewFile *.md setlocal textwidth=80         " Wrap text at 80 characters

" -----------------------------------------------------------------------------
" Set syntax highlighting for specific file types
autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
autocmd BufRead,BufNewFile .bash*,*/zsh/configs/* set filetype=sh
autocmd BufRead,BufNewFile gitconfig.local set filetype=gitconfig
autocmd BufRead,BufNewFile tmux.conf.local set filetype=tmux
autocmd BufRead,BufNewFile vimrc.local set filetype=vim

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ completion                                                                 ║
" ╚════════════════════════════════════════════════════════════════════════════╝
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col
        return "\<tab>"
    endif

    let char = getline('.')[col - 1]
    if char =~ '\k'
        " There's an identifier before the cursor, so complete the identifier.
        return "\<c-p>"
    else
        return "\<tab>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <tab> <c-n>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocomplete brackets, braces and quotes
" Make sure "set paste" is not set
" When don't want the mapping, need to escape it using ctrl + v before typing the mapped char like ( { etc.
" Disabled since gets annoying at times.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"inoremap " ""<left>
"inoremap ' ''<left>
"inoremap ( ()<left>
"inoremap [ []<left>
"inoremap { {}<left>
"inoremap {<CR> {<CR>}<ESC>O
"inoremap {;<CR> {<CR>};<ESC>O

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ STATUS LINE                                                                ║
" ╚════════════════════════════════════════════════════════════════════════════╝
set laststatus=2        " always show Status bar
" -----------------------------------------------------------------------------
"function! GitBranch()
"  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
"endfunction

"function! StatuslineGit()
"  let l:branchname = GitBranch()
"  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
"endfunction

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
" -----------------------------------------------------------------------------
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
" color options ---------------------------------------------------------------
noh
if &term == "screen"
  set t_Co=256
endif

" -----------------------------------------------------------------------------
" https://vim.fandom.com/wiki/Change_statusline_color_to_show_insert_or_normal_mode
" Set StatusLine colors to change when enter/leave modes
" -----------------------------------------------------------------------------
" Default the StatusLine when entering Vim
hi statusline ctermbg=255 ctermfg=31
" Set StatusLine colors to change when enter/leave modes
au InsertEnter * hi StatusLine ctermbg=255 ctermfg=41
au InsertLeave * hi StatusLine ctermbg=255 ctermfg=31

" -----------------------------------------------------------------------------
"" Highlight CursorLine when enter/leaving modes
set cursorline
au InsertEnter * hi CursorLine ctermbg=236 ctermfg=none
au InsertLeave * hi CursorLine ctermbg=31 ctermfg=none
hi CursorLine                  ctermbg=31 ctermfg=none

" Change color used for line numbers ------------------------------------------
"hi LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

" USER DEFINED COLORS ---------------------------------------------------------
"hi pmenu ctermbg=0 ctermfg=NONE
"hi pmenusel ctermbg=4 ctermfg=0
"hi pmenusbar ctermbg=0
"hi pmenuthumb ctermbg=7
"hi matchparen ctermbg=0 ctermfg=NONE
"hi search ctermbg=0 ctermfg=NONE
" -----------------------------------------------------------------------------
"hi Comment ctermbg=DarkGray
"hi Constant ctermbg=Blue
"hi Normal ctermbg=Black
"hi NonText ctermbg=Black
"hi Special ctermbg=DarkMagenta
"hi Cursor ctermbg=Green

hi User1 ctermfg=007 ctermbg=239 guibg=#4e4e4e guifg=#adadad
hi User2 ctermfg=007 ctermbg=236 guibg=#303030 guifg=#adadad
hi User3 ctermfg=236 ctermbg=236 guibg=#303030 guifg=#303030
hi User4 ctermfg=007 ctermbg=056 guibg=#4e4e4e guifg=#4e4e4e

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ Functions                                                                  ║
" ╚════════════════════════════════════════════════════════════════════════════╝
" -----------------------------------------------------------------------------
" PASTE MODE (Auto set/unset vims paste mode) ---------------------------------
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

" -----------------------------------------------------------------------------
" PASTE MODE (Fix for Tmux) ---------------------------------------------------
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

" -----------------------------------------------------------------------------
" netrw - NERDTree like setup -------------------------------------------------
let g:netrw_altv = 1                    " absolute width of netrw window
"let g:netrw_winsize = -28               " do not display info on the top of window
let g:netrw_winsize = 25                " do not display info on the top of window
let g:netrw_banner = 0                  " tree-view
let g:netrw_liststyle = 3               " sort is affecting only: directories on the top, files below
let g:netrw_sort_sequence = '[\/]$,*'   " use the previous window to open file
let g:netrw_browse_split = 4

" Open Explorer Hotkey
map <leader>e :Lexplore<CR>

" ToggleExplorer Function
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

" -----------------------------------------------------------------------------
" Use of the filetype plugins, auto completion and indentation support --------
filetype plugin indent on

" file type specific settings
if has("autocmd")
  " For debugging
  "set verbose=9

  " if bash is sh.
  let bash_is_sh=1

  " change to directory of current file automatically
  autocmd BufEnter * lcd %:p:h

  " Put these in an autocmd group, so that we can delete them easily.
  augroup mysettings
    au FileType xslt,xml,css,html,xhtml,javascript,sh,config,c,cpp,docbook set smartindent shiftwidth=2 softtabstop=2 expandtab
    au FileType tex set wrap shiftwidth=2 softtabstop=2 expandtab

    " Confirm to PEP8
    au FileType python set tabstop=4 softtabstop=4 expandtab shiftwidth=4 cinwords=if,elif,else,for,while,try,except,finally,def,class
  augroup END

  augroup perl
    " reset (disable previous 'augroup perl' settings)
    au!  

    au BufReadPre,BufNewFile
    \ *.pl,*.pm
    \ set formatoptions=croq smartindent shiftwidth=2 softtabstop=2 cindent cinkeys='0{,0},!^F,o,O,e' " tags=./tags,tags,~/devel/tags,~/devel/C
    " formatoption:
    "   t - wrap text using textwidth
    "   c - wrap comments using textwidth (and auto insert comment leader)
    "   r - auto insert comment leader when pressing <return> in insert mode
    "   o - auto insert comment leader when pressing 'o' or 'O'.
    "   q - allow formatting of comments with "gq"
    "   a - auto formatting for paragraphs
    "   n - auto wrap numbered lists
    "   
  augroup END

  " Always jump to the last known cursor position. 
  " Don't do it when the position is invalid or when inside
  " an event handler (happens when dropping a file on gvim). 
  autocmd BufReadPost * 
    \ if line("'\"") > 0 && line("'\"") <= line("$") | 
    \   exe "normal g`\"" | 
    \ endif 

endif " has("autocmd")
" -----------------------------------------------------------------------------

" ╔════════════════════════════════════════════════════════════════════════════╗
" ║ Source .vimrc.local if exist                                               ║
" ╚════════════════════════════════════════════════════════════════════════════╝
if filereadable(glob("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif
