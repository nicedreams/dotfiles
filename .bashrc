#!/bin/bash
# ~/.bashrc (Kenneth Bernier - kbernier@gmail.com)
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Custom bashrc that could be used across multiple systems                   ║
# ╚════════════════════════════════════════════════════════════════════════════╝
# If not running interactively, don't do anything!
[[ $- != *i* ]] && return

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ HISTORY                                                                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝
export HISTSIZE=5000
export HISTFILESIZE=10000
export HISTCONTROL=ignoreboth  # don't put duplicate lines in the history. [=ignoredups:erasedups | =ignoreboth]
export HISTTIMEFORMAT='%F %T '
export HISTFILE=~/.bash_history
export HISTIGNORE="history*:pwd:ls:l:ll:exit:sensor*:note:todo:tmux:tmux-ns:tmux-hn"
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"  # After each command, append to the history file and reread it

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ SHOPT OPTIONS                                                              ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#shopt -s histverify     # prefill ! history command instead of running it
shopt -s histappend     # append history list to HISTFILE on exit
shopt -s checkwinsize   # fix window sizes when termianl is resized
shopt -s cmdhist        # attempts to save all lines of a multiple-line command in the same history entry
shopt -s lithist        # multi-line commands are saved to the history with embedded newlines rather than using semicolon separators
shopt -s cdspell        # minor errors in the spelling of a directory component in a cd command will be corrected
#shopt -s nocaseglob     # pathname expansion will be treated as case-insensitive (auto-corrects the case)
#shopt -s dotglob        # bash includes filenames beginning with a â€˜.â€™ in the results of filename expansion
#shopt -s globstar       # If set, the pattern "**" used in a pathname expansion context will match all files and zero or more directories and subdirectories.

#bind "set completion-ignore-case on"      # Perform file completion in a case insensitive fashion
#bind "set mark-symlinked-directories on"  # Immediately add a trailing slash when autocompleting symlinks to directories

# number of trailing directory components to retain when expanding the \w and \W prompt string escapes
PROMPT_DIRTRIM=3

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Auto Logout In Seconds After No Input                                      ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#TMOUT=300

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ EXPORT LANGUAGE                                                            ║
# ╚════════════════════════════════════════════════════════════════════════════╝
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ SET TERMINAL                                                               ║
# ╚════════════════════════════════════════════════════════════════════════════╝
case "$TERM" in
  xterm|screen|tmux|rxvt-unicode)
    export TERM="$TERM-256color"
  ;;
esac

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ COLORS                                                                     ║
# ╚════════════════════════════════════════════════════════════════════════════╝
# COLORS
BLACK="\e[1;30m"       # Black
RED="\e[1;31m"         # Red
GREEN="\e[1;32m"       # Green
YELLOW="\e[1;33m"      # Yellow
BLUE="\e[1;34m"        # Blue
PURPLE="\e[1;35m"      # Purple
CYAN="\e[1;36m"        # Cyan
WHITE="\e[1;37m"       # White
RESET="\e[m"           # Color Reset
# PS1 COLORS
PS1BLACK="\[\e[1;30m\]"       # Black
PS1RED="\[\e[1;31m\]"         # Red
PS1GREEN="\[\e[1;32m\]"       # Green
PS1YELLOW="\[\e[1;33m\]"      # Yellow
PS1BLUE="\[\e[1;34m\]"        # Blue
PS1PURPLE="\[\e[1;35m\]"      # Purple
PS1CYAN="\[\e[1;36m\]"        # Cyan
PS1WHITE="\[\e[1;37m\]"       # White
PS1RESET="\[\e[m\]"         # Color Reset

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ PS1 PROMPT                                                                 ║
# ╚════════════════════════════════════════════════════════════════════════════╝
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}

# Set variable identifying the chroot you work in (used in the prompt below)
if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
  debian_chroot="$(cat /etc/debian_chroot)"
fi

# Terminal color support else set PS1 with no colors
# Use normal colored prompt
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  # Get color variable depending on root(red) or user(green)
  if [[ "$UID" -eq 0 ]]; then export PS1USERCOLOR="${PS1RED}"; else export PS1USERCOLOR="${PS1GREEN}"; fi

  # Set PS1 color depending on root(red) or user(green)
  export PS1="${debian_chroot:+($debian_chroot)}[${PS1YELLOW}\h${PS1RESET}](${PS1USERCOLOR}\u${PS1RESET})${PS1BLUE}\w${PS1RESET}\\$ "  # Style: [hostname](username)~$
  #export PS1="${debian_chroot:+($debian_chroot)}[\[${PS1USERCOLOR}\]\u\[\e[m\]@\[\e[1;33m\]\h\[\e[m\]]\[\e[1;34m\]\w\[\e[m\]\\$ "  # Style: [username@hostname]~$

  # Append git branch to current PS1 if git installed
  # Do not run if git script detected
  if [[ -z "$(command -v git &> /dev/null)" ]] && [[ ! -f "${HOME}"/.bash_git ]]; then
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWCOLORHINTS=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    # Use built-in __git_ps1 if exist and fallback to parse_git_branch function if not
    if [[ -n "$(type -t __git_ps1)" ]]; then
      export PS1="${PS1}\$(__git_ps1 '(%s)') "
    else
      export PS1="${PS1}\$(parse_git_branch)"
    fi
  fi
else
  # Basic PS1 without color
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

# Use fancyprompt script if exists
#if [[ -e "${HOME}"/.bash_fancyprompt ]]; then source "${HOME}"/.bash_fancyprompt; fi

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Export path for root vs users                                              ║
# ╚════════════════════════════════════════════════════════════════════════════╝
if [[ "$UID" -eq 0 ]]; then
  PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
else
  PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
fi

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Set PATH so it includes user's private bin if it exists                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝
if [[ -d "${HOME}/bin" ]]; then
  if [[ "$UID" -ne 0 ]]; then
    # Includes only ${HOME}/bin/ and not sub directories
    #PATH="${HOME}/bin:${PATH}"
    # Includes all sub directories in ${HOME}/bin/
    PATH="${PATH}$( find ${HOME}/bin/ -type d -printf ":%p" )"
  fi
fi

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Start the ssh-agent in the background                                      ║
# ╚════════════════════════════════════════════════════════════════════════════╝
# Do not run if root user
#if [[ "$UID" -ne 0 ]]; then
#  if [[ -z "$SSH_AUTH_SOCK" ]] ; then
#    printf "Starting ssh-agent: "
#    eval $(ssh-agent -s)
#    #ssh-add $HOME/.ssh/private_key
#  fi
#fi

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Enable programmable completion features                                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Use dircolors if exist                                                     ║
# ╚════════════════════════════════════════════════════════════════════════════╝
[[ -e "${HOME}"/.dircolors ]] && eval "$(dircolors --sh ${HOME}/.dircolors)"

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║  Colored GCC Warnings and Errors                                         ║
# ╚════════════════════════════════════════════════════════════════════════════╝
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ LESS | MAN                                                                 ║
# ╚════════════════════════════════════════════════════════════════════════════╝
export LESS="-R"
# Have less display coloured man pages
# from: https://wiki.archlinux.org/index.php/Color_output_in_console#man
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;33m'     # begin blink
export LESS_TERMCAP_so=$'\e[01;44;37m' # begin reverse video
export LESS_TERMCAP_us=$'\e[01;37m'    # begin underline
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ DEFAULT EDITOR / VIEWER                                                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝
export EDITOR="vi"
export PAGER="less"

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Aliases - Git dotfile                                                      ║
# ╚════════════════════════════════════════════════════════════════════════════╝
alias dotfiles='/usr/bin/git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME}'      # dotfiles git alias command
alias dotfiles-ls='dotfiles ls-tree -r HEAD --name-only'                            # list files
alias dotfiles-remove='dotfiles rm --cached'                                        # remove files
alias dotfiles-reset='dotfiles fetch origin && dotfiles reset --hard origin/master' # replace local files with remote

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ ALIASES                                                                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝
command -v curl &> /dev/null && alias whatismyip="curl http://ipecho.net/plain; echo"
command -v tmux &> /dev/null && alias tmux-ns='tmux new-session -s'
command -v tmux &> /dev/null && alias tmux-hn='tmux attach -t ${HOSTNAME} || tmux new-session -t ${HOSTNAME}'
command -v vim &> /dev/null && alias vi='vim'
# -----------------------------------------------------------------------------
alias diff='diff --color'
alias rm='rm --preserve-root'
alias top='top -E g'
alias ps='ps -auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias histg='history | grep'
alias hgrep='history | grep'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias fsck='fsck -M'
alias dmesg='dmesg --color=always -T'
alias du='du -h'
alias df='df -hT'
alias free='free -h'
alias cd..="cd .."
alias ..="cd .."
alias mnt='mount | grep -E ^/dev | column -t'   # Show mount in columns
alias f='sudo $(history -p !!)'                 # Repeat last command using sudo aka 'fuck'
# -----------------------------------------------------------------------------
alias ls='ls -h --color'
alias l="ls -lv --group-directories-first --color"
alias ll='ls -lhAF --color'
alias lla='ll -A'           #  Show hidden files.
alias llx='ls -lXB'         #  Sort by extension.
alias lls='ls -lSr'         #  Sort by size, biggest last.
alias llt='ls -ltr'         #  Sort by date, most recent last.
alias llc='ls -ltcr'        #  Sort by/show change time,most recent last.
alias llu='ls -ltur'        #  Sort by/show access time,most recent last.
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ GRC Colors - apt install grc (Put at end of any aliases in .bashrc)        ║
# ╚════════════════════════════════════════════════════════════════════════════╝
# Colourify Commands
GRC="$(which grc)"
if [ "$TERM" != dumb ] && [ -n "$GRC" ]; then
  alias colourify="$GRC -es --colour=auto"
  alias blkid='colourify blkid'
  alias configure='colourify ./configure'
  alias df='colourify df'
  alias diff='colourify diff'
  alias docker='colourify docker'
  alias docker-machine='colourify docker-machine'
  alias du='colourify du'
  alias env='colourify env'
  alias free='colourify free'
  alias fdisk='colourify fdisk'
  alias findmnt='colourify findmnt'
  alias make='colourify make'
  alias gcc='colourify gcc'
  alias g++='colourify g++'
  alias id='colourify id'
  alias ip='colourify ip'
  alias iptables='colourify iptables'
  alias as='colourify as'
  alias gas='colourify gas'
  alias ld='colourify ld'
  alias ls='colourify ls -h --color'
  alias lsof='colourify lsof'
  alias lsblk='colourify lsblk'
  alias lspci='colourify lspci'
  alias netstat='colourify netstat'
  alias ping='colourify ping'
  alias traceroute='colourify traceroute'
  alias traceroute6='colourify traceroute6'
  alias head='colourify head'
  alias tail='colourify tail'
  alias dig='colourify dig'
  alias mount='colourify mount'
  alias ps='colourify ps'
  alias mtr='colourify mtr'
  alias semanage='colourify semanage'
  alias getsebool='colourify getsebool'
  alias ifconfig='colourify ifconfig'
fi
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ exa - ls replacement                                                       ║
# ╚════════════════════════════════════════════════════════════════════════════╝
if [[ -f ~/bin/exa ]]; then
  alias l='exa -l'
  alias ll='exa -la'
  alias llt='exa -la --tree --level=2'
fi

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ FUNCTIONS                                                                  ║
# ╚════════════════════════════════════════════════════════════════════════════╝
# ssh copy file from server back to ssh client
#ssh-dl(){ scp "$1" ${SSH_CLIENT%% *}:/home/ken/Downloads/ ; }
# fzf preview
preview() { cd "$1"; fzf --bind="enter:execute($EDITOR {})" --height=70% --preview="(bat -p --color=always --line-range 1:100 {} 2> /dev/null || head -100 {})" --preview-window=right:70%:noborder --color='fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899'; cd - ; }
# Calculator
calc() { echo "$(( $@ ))"; }
#------------------------------------------------------------------------------
# CPU Info
cpuinfo() { lscpu | egrep 'Model name|Socket|Thread|NUMA|CPU\(s\)' ; }
#------------------------------------------------------------------------------
# Create date stamp backup copy of file or directory
backupfile() { cp "${1}" "${1}"-"$(date +%Y-%m-%d_%H.%M.%S)" ; }
# Create date stamp backup gzip of file or directory
backupdir() { tar -czvf "${1%/}"-"$(date +%Y-%m-%d_%H.%M.%S)".tar.gz "${1%/}" ; }
# Make backup before editing file
safeedit() { cp "${1}" "${1}"."$(date +%Y-%m-%d_%H.%M.%S)" && "$EDITOR" "${1}" ; }
#------------------------------------------------------------------------------
# note function that can run commands
export notefile="${HOME}/.note"
note() {
  if [[ ! -e ${notefile} ]]; then touch ${notefile}; fi
  case "$1" in
    [1-9]*) line=$(sed -n "${1}"p "${notefile}"); eval "${line}" ;;
    --clear) > "${notefile}" ;;
    -e) ${EDITOR} "${notefile}" ;;
    -d) if [[ -z "${2}" ]]; then printf "No input entered\n"; else sed -i "${2}d" "${notefile}" && printf "%sRemoved line ${2} from ${notefile}\n" ; fi ;;
    -b|--backup) cp "${notefile}" "${notefile}"-"$(printf '%(%Y-%m-%d_%H.%M.%S)T' -1)"; printf "%sCreated backup copy of ${notefile}\n" ;;
    -c|--change) if [[ -z "$2" ]]; then export notefile="${HOME}/.note"; else export notefile="$2"; fi ;;
    -h|--help) printf "%snote\t\t:displays notes\n  NUM\t\t:run line number as command\n  --clear\t:clear note file\n  -e\t\t:edit note file\n  -d #\t\t:delete note by line number\n  -b\t\t:backup note file with timestamp\n  -c PATH\t:change PATH to a different note file\n  -c\t\t:set PATH to default ~/.note\nnote PATH:\t${notefile}\n" ;;
    *) if [[ -z "$1" ]]; then cat -n "${notefile}"; else printf '%s \n' "$*" >> "${notefile}"; fi ;;
  esac
}

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ TMUX                                                                       ║
# ╚════════════════════════════════════════════════════════════════════════════╝
# Display TMUX sessions @ login
# Do nothing if root else tmux if user
if [[ "${UID}" -ne 0 ]]; then
  # List TMUX active sessions after login
  if [[ -z "${TMUX}" ]]; then
    if ! tmux ls &> /dev/null; then
      printf "╔════════════════════════════════════════════════════════════════════════════╗\\n"
      printf "║ TMUX: No Active Sessions!                                                  ║\\n"
      printf "╚════════════════════════════════════════════════════════════════════════════╝\\n"
    else
      printf "╔════════════════════════════════════════════════════════════════════════════╗\\n"
      printf "║ TMUX: Listing Sessions:                                                    ║\\n"
      printf "%s\n" "$(tmux ls)"
      printf "╚════════════════════════════════════════════════════════════════════════════╝\\n"
    fi
  fi
fi
#------------------------------------------------------------------------------
# Be careful as if there are issues with ~/.tmux.conf then might have issues logging in to shell
# Attach to active TMUX session or start new session if none available after login to console
#if [[ -z "${TMUX}" || "${SSH_CLIENT}" || "${SSH_TTY}" || ${EUID} = 0 ]]; then (tmux attach || tmux new-session) ; fi
# If ssh detected attach to existing tmux session or create new one
#if [[ -n "${SSH_CONNECTION}" || "${SSH_CLIENT}" ]]; then (tmux attach || tmux new-session) ; fi

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Source other files for alias/function definitions if exist.                ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#for file in "${HOME}"/{.bash_colors,.bash_aliases,.bash_functions}; do [[ -r "$file" ]] && source "$file"; done; unset file
declare -a source_files=(
  ${HOME}/.bash_colors      # PS1 and other terminal color codes to names
  ${HOME}/.bash_aliases     # Common aliases
  ${HOME}/.bash_functions   # Common functions
  ${HOME}/.bash_git         # Git Functions and aliases
  ${HOME}/.bash_server      # Functions and aliases usually used only on servers
  ${HOME}/.bash*.local      # Local and private settings not under version control (example: credentials)
  ${HOME}/.fzf.bash         # Source ~/.fzf.bash
  )
for file in ${source_files[*]}; do [[ -r "$file" ]] && source "$file"; done; unset file
#------------------------------------------------------------------------------

