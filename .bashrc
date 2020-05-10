#!/bin/bash
# ~/.bashrc
# Custom bashrc that could be used across multiple systems
#------------------------------------------------------------------------------

# If not running interactively, don't do anything!
#[[ $- != *i* ]] && return
#[[ -z "$PS1" ]] && return
case $- in *i*) ;; *) return;; esac

#------------------------------------------------------------------------------
# HISTORY
#------------------------------------------------------------------------------
export HISTSIZE=2000
export HISTFILESIZE=5000
export HISTCONTROL=ignoreboth  # don't put duplicate lines in the history. [=ignoredups:erasedups | =ignoreboth]
export HISTTIMEFORMAT='%F %T '
export HISTFILE=~/.bash_history
export HISTIGNORE="history*:pwd:ls:l:ll:exit:sensor*:cd:note:todo:tmux:tmux-ns:tmux-hn:nmon:htop:ranger"
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"  # After each command, append to the history file and reread it

#------------------------------------------------------------------------------
# SHOPT OPTIONS
#------------------------------------------------------------------------------
shopt -s histappend     # append history list to HISTFILE on exit
shopt -s checkwinsize   # fix window sizes when termianl is resized
shopt -s cmdhist        # attempts to save all lines of a multiple-line command in the same history entry
shopt -s lithist        # multi-line commands are saved to the history with embedded newlines rather than using semicolon separators
shopt -s cdspell        # minor errors in the spelling of a directory component in a cd command will be corrected
#shopt -s nocaseglob     # pathname expansion will be treated as case-insensitive (auto-corrects the case)
#shopt -s dotglob        # bash includes filenames beginning with a â€˜.â€™ in the results of filename expansion
#shopt -s globstar       # If set, the pattern "**" used in a pathname expansion context will match all files and zero or more directories and subdirectories.

bind "set completion-ignore-case on"      # Perform file completion in a case insensitive fashion
bind "set mark-symlinked-directories on"  # Immediately add a trailing slash when autocompleting symlinks to directories

#------------------------------------------------------------------------------
# Display error codes - Set trap to intercept a non-zero return code of the last program run:
#function EC() {
#  echo -e '\e[1;33m'code: $?'\e[m\n'
#}
#trap EC ERR

#------------------------------------------------------------------------------
# Auto logout in seconds after no input
#TMOUT=300

#------------------------------------------------------------------------------
# Export Language
#------------------------------------------------------------------------------
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

#------------------------------------------------------------------------------
# SET TERMINAL
#------------------------------------------------------------------------------
case "$TERM" in
  xterm|screen|tmux|rxvt-unicode)
    export TERM="$TERM-256color"
  ;;
esac

#------------------------------------------------------------------------------
# PS1 PROMPT
#------------------------------------------------------------------------------
## Set variable identifying the chroot you work in (used in the prompt below)
#------------------------------------------------------------------------------
if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
  debian_chroot="$(cat /etc/debian_chroot)"
fi

## Terminal color support else set PS1 with no colors
#------------------------------------------------------------------------------
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  # Get color variable depending on root(red) or user(green)
  if [[ "$UID" -eq 0 ]]; then export PS1_USER_COLOR="\e[1;91m"; else export PS1_USER_COLOR="\e[1;92m"; fi

  # Set PS1 color depending on root(red) or user(green)
  export PS1="${debian_chroot:+($debian_chroot)}[\[\e[1;93m\]\h\[\e[m\]](\[\e[${PS1_USER_COLOR}\]\u\[\e[m\])\[\e[1;36m\]\w\[\e[m\]\\$ "  # Style: [hostname](username)~$
  #export PS1="${debian_chroot:+($debian_chroot)}[\[${PS1_USER_COLOR}\]\u\[\e[m\]@\[\e[1;33m\]\h\[\e[m\]]\[\e[1;34m\]\w\[\e[m\]\\$ "  # Style: [username@hostname]~$
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
if [[ -e "$HOME"/.bash_gitprompt ]]; then source "$HOME"/.bash_gitprompt; fi

#------------------------------------------------------------------------------
# Export path for root vs users
#------------------------------------------------------------------------------
if [[ "$UID" -eq 0 ]]; then
  PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
else
  PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
fi

#------------------------------------------------------------------------------
# Set PATH so it includes user's private bin if it exists
#------------------------------------------------------------------------------
if [[ -d "$HOME/bin" ]]; then
  if [[ "$UID" -ne 0 ]]; then
    # Includes only $HOME/bin/ and not sub directories
    #PATH="$HOME/bin:${PATH}"
    # Includes all sub directories in $HOME/bin/
    PATH="${PATH}$( find ${HOME}/bin/ -type d -printf ":%p" )"
  fi
fi

#------------------------------------------------------------------------------
# Add fzf to PATH
#------------------------------------------------------------------------------
#if [[ -x "${HOME}"/.fzf/bin/fzf ]]; then PATH="${PATH}:${HOME}/.fzf/bin/"; fi
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#------------------------------------------------------------------------------
# Enable programmable completion features
#------------------------------------------------------------------------------
if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

#------------------------------------------------------------------------------
# LESS
#------------------------------------------------------------------------------
#export LESS="-JMQR#3NSi~"
#export LESS="-JMQRNSi"
#export LESS="-JMQRSni"

#------------------------------------------------------------------------------
# DEFAULT EDITOR / VIEWER
#------------------------------------------------------------------------------
export EDITOR="vim"
export PAGER="vim"

#------------------------------------------------------------------------------
# ALIASES
#------------------------------------------------------------------------------
diff='diff --color'
#command -v colordiff &> /dev/null && alias diff='colordiff'
command -v curl &> /dev/null && alias get-wanip="curl http://ipecho.net/plain; echo"
command -v tmux &> /dev/null && alias tmux-hn='tmux attach -t ${HOSTNAME} || tmux new-session -t ${HOSTNAME}'
command -v fzf &> /dev/null && alias preview='fzf --height=60% --preview-window=right:60% --layout=reverse --preview="bat -p --color=always --line-range 1:100 {} || head -100"'
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
alias mnt='mount | grep -E ^/dev | column -t'
command -v tree &> /dev/null && alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...
#-------------------------------------------------------------
# The ls family
#-------------------------------------------------------------
# Add colors for filetype and  human-readable sizes by default on 'ls':
alias ls='ls -h --color'
alias l="ls -lv --group-directories-first"
alias ll='ls -lhAF --color'
alias la='ll -A'           #  Show hidden files.
alias lx='ls -lXB'         #  Sort by extension.
alias lk='ls -lSr'         #  Sort by size, biggest last.
alias lt='ls -ltr'         #  Sort by date, most recent last.
alias lc='ls -ltcr'        #  Sort by/show change time,most recent last.
alias lu='ls -ltur'        #  Sort by/show access time,most recent last.
alias lls='ls -lhASrF --color'
alias llt='ls -lhAtrF --color'
alias lld='ls -Al --group-directories-first --color'
alias lsl="ls -lhFA | less"

#------------------------------------------------------------------------------
# FUNCTIONS
#------------------------------------------------------------------------------
function history-top() {
  history | awk '{CMD[$4]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n20
}
function tmux-ns() {
  tmux new-session -s "$1"
}

### GRC Colors - apt install grc (Put at end of .bashrc)
#------------------------------------------------------------------------------
## Colourify GCC Warnings and Errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
## Colourify Commands
GRC="$(type -p grc)"
if [[ "$TERM" != dumb ]] && [[ -n "$GRC" ]]; then
  alias colourify='$GRC -es --colour=auto'
  alias configure='colourify ./configure'
  alias blkid='colourify blkid'
  alias df='colourify df -h'
  #alias diff='colourify diff'
  alias docker='colourify docker'
  alias docker-machine='colourify docker-machine'
  alias du='colourify du -h'
  alias env='colourify env'
  alias free='colourify free -h'
  alias make='colourify make'
  alias gcc='colourify gcc'
  alias g++='colourify g++'
  alias ip='colourify ip'
  alias iptables='colourify iptables'
  alias as='colourify as'
  alias gas='colourify gas'
  alias ld='colourify ld'
  alias ls='colourify ls -h --color'
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
  alias getsebool='colourify setsebool'
  alias ifconfig='colourify ifconfig'
fi

# exa - ls replacement
#if [[ -f ~/bin/exa ]]; then
#  alias l='exa -l'
#  alias ll='exa -la'
#  alias llt='exa -la --tree --level=2'
#fi

#------------------------------------------------------------------------------
# Import alias/function definitions from file if exist.
#------------------------------------------------------------------------------
#if [[ -e "$HOME"/.bash_kenrc ]]; then source "$HOME"/.bash_kenrc ; fi
#if [[ -e "$HOME"/.bash_aliases ]]; then source "$HOME"/.bash_aliases ; fi
#if [[ -e "$HOME"/.bash_functions ]]; then source "$HOME"/.bash_functions ; fi
for file in "${HOME}"/{.bash_aliases,.bash_function,.bash_kenrc}; do [[ -r "$file" ]] && source "$file"; done; unset file

