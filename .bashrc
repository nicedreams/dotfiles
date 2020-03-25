#!/bin/bash
# ~/.bashrc
# Custom bashrc that could be used across multiple systems
#------------------------------------------------------------------------------

# If not running interactively, don't do anything!
[[ $- != *i* ]] && return

#------------------------------------------------------------------------------
### HISTORY
#------------------------------------------------------------------------------
export HISTSIZE=2000
export HISTFILESIZE=5000
export HISTCONTROL=ignoredups:erasedups    # don't put duplicate lines in the history.
#export HISTCONTROL=ignoreboth             # don't put duplicate lines or lines starting with space in the history.
export HISTTIMEFORMAT="$(echo -e '\e[1;36m')[%F %T]$(echo -e '\e[m') "
#export HISTTIMEFORMAT='%F %T'
export HISTFILE=~/.bash_history
export HISTIGNORE="history*:pwd:ls:l:ll:exit:sensor*"
# After each command, append to the history file and reread it
#export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

#------------------------------------------------------------------------------
### SHOPT OPTIONS
#------------------------------------------------------------------------------
shopt -s histappend     # append history list to HISTFILE on exit
shopt -s checkwinsize   # fix window sizes when termianl is resized
shopt -s cmdhist        # attempts to save all lines of a multiple-line command in the same history entry
shopt -s lithist        # multi-line commands are saved to the history with embedded newlines rather than using semicolon separators
shopt -s cdspell        # minor errors in the spelling of a directory component in a cd command will be corrected
shopt -s nocaseglob     # pathname expansion will be treated as case-insensitive (auto-corrects the case)
#shopt -s dotglob        # bash includes filenames beginning with a â€˜.â€™ in the results of filename expansion
#shopt -s globstar       # If set, the pattern "**" used in a pathname expansion context will match all files and zero or more directories and subdirectories.

bind "set completion-ignore-case on"      # Perform file completion in a case insensitive fashion
bind "set mark-symlinked-directories on"  # Immediately add a trailing slash when autocompleting symlinks to directories

#------------------------------------------------------------------------------
### Import alias/function definitions from file if exist.
#------------------------------------------------------------------------------
if [[ -e "$HOME"/.bash_kenrc ]]; then source "$HOME"/.bash_kenrc ; fi
if [[ -e "$HOME"/.bash_aliases ]]; then source "$HOME"/.bash_aliases ; fi
if [[ -e "$HOME"/.bash_functions ]]; then source "$HOME"/.bash_functions ; fi

#------------------------------------------------------------------------------
### PS1 PROMPT
#------------------------------------------------------------------------------

## Set variable identifying the chroot you work in (used in the prompt below)
#------------------------------------------------------------------------------
if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
  debian_chroot="$(cat /etc/debian_chroot)"
fi

## Terminal color support else set PS1 with no colors
#------------------------------------------------------------------------------
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  if [[ -e "$HOME"/.bash_gitprompt ]]
  then
    source "$HOME"/.bash_gitprompt
  else
    # Set PS1 color depending on root or user (Yellow Hostname)
    if [[ "$UID" -eq 0 ]]; then PS1_USER_COLOR="\e[1;31m"; else PS1_USER_COLOR="\e[1;32m"; fi
    PS1="${debian_chroot:+($debian_chroot)}[\e[1;33m\h\e[m](${PS1_USER_COLOR}\u\e[m)\e[1;34m\w\e[m\$ "        # Style: [hostname](username)~$
    #PS1="${debian_chroot:+($debian_chroot)}[${PS1_USER_COLOR}\u\e[m@\e[1;33m\h\e[m]\e[1;34m\w\e[m\$ "        # Style: [username@hostname]~$
  fi
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

#------------------------------------------------------------------------------
### Export path for root vs users
#------------------------------------------------------------------------------
if [[ "$UID" -eq 0 ]]; then
  PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
else
  PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
fi

## Set PATH so it includes user's private bin if it exists
#------------------------------------------------------------------------------
if [[ -d "$HOME/bin" ]] ; then
  PATH="$HOME/bin:$PATH"
  #PATH="${PATH:+${PATH}:}$HOME/bin"
fi

### Enable programmable completion features
#------------------------------------------------------------------------------
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then . /etc/bash_completion; fi

#------------------------------------------------------------------------------
### ALIASES
#------------------------------------------------------------------------------
alias top='top -E g'
alias ps='ps --forest'
alias less='less -S'
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
alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...
#-------------------------------------------------------------
# The ls family
#-------------------------------------------------------------
# Add colors for filetype and  human-readable sizes by default on 'ls':
alias ls='ls -h --color'
#alias ll='ls -lhAF --color'
alias ll="ls -lv --group-directories-first"
alias l='ls -lhF --color'
alias la='ll -A'           #  Show hidden files.
alias lx='ls -lXB'         #  Sort by extension.
alias lk='ls -lSr'         #  Sort by size, biggest last.
alias lt='ls -ltr'         #  Sort by date, most recent last.
alias lc='ls -ltcr'        #  Sort by/show change time,most recent last.
alias lu='ls -ltur'        #  Sort by/show access time,most recent last.
alias lls='ls -lhASrF --color'
alias llt='ls -lhAtrF --color'
alias lld='ls -Al --group-directories-first --color'

### GRC Colors - apt install grc (Put at end of .bashrc)
#------------------------------------------------------------------------------
## Colourify GCC Warnings and Errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
## Colourify Commands
GRC="$(type -p grc)"
if [[ "$TERM" != dumb ]] && [[ -n "$GRC" ]]; then
  alias colourify='$GRC -es --colour=auto'
  alias configure='colourify ./configure'
  alias blkid='colourify blkid'
  alias df='colourify df -h'
  alias diff='colourify diff'
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
