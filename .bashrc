#!/bin/bash
# If not running interactively, don't do anything!
[[ $- != *i* ]] && return

#------------------------------------------------------------------------------
### COLORS (More colors in ~/.bash_aliases)
#------------------------------------------------------------------------------
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White
NC="\e[m"               # Color Reset

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

# Perform file completion in a case insensitive fashion
bind "set completion-ignore-case on"
# Immediately add a trailing slash when autocompleting symlinks to directories
bind "set mark-symlinked-directories on"

#------------------------------------------------------------------------------
### Import alias/function definitions from file if exist.
#------------------------------------------------------------------------------
if [[ -e "$HOME"/.bash_aliases ]]; then source "$HOME"/.bash_aliases ; fi
if [[ -e "$HOME"/.bash_functions ]]; then source "$HOME"/.bash_functions ; fi
if [[ -e "$HOME"/.bash_variables ]]; then source "$HOME"/.bash_variables ; fi

#------------------------------------------------------------------------------
### PS1 PROMPT
#------------------------------------------------------------------------------

## Set variable identifying the chroot you work in (used in the prompt below)
#------------------------------------------------------------------------------
if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
  debian_chroot="$(cat /etc/debian_chroot)"
fi

## Terminal color support else set PS1 with no colors
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  ## Set PS1 color depending on root or user (Yellow Hostname)
  #------------------------------------------------------------------------------
  if [[ "$UID" -eq 0 ]]; then PS1_USER_COLOR="\e[1;31m"; else PS1_USER_COLOR="\e[1;32m"; fi
  #------------------------------------------------------------------------------
  ## Style:  [username@hostname]~$
  #PS1="[${PS1_USER_COLOR}\u\e[m@\e[1;33m\h\e[m]\e[1;34m\w\e[m\$ "
  #------------------------------------------------------------------------------
  # Detect if ~/.bash_gitprompt exists then sources file and sets PS1 prompt
  if [[ -e "$HOME"/.bash_gitprompt ]]; then
    source "$HOME"/.bash_gitprompt
    # Style: CHROOT[hostname](username)[master !]~$
    #PS1="${debian_chroot:+($debian_chroot)}[${BYellow}\h${NC}](${PS1_USER_COLOR}\u${NC})\$(parse_git_branch)${BBlue}\w${NC}\$ "
    PS1="${debian_chroot:+($debian_chroot)}[\e[1;33m\h\e[m](${PS1_USER_COLOR}\u\e[m)\$(parse_git_branch)\e[1;34m\w\e[m\$ "
  else
    # Style: CHROOT[hostname](username)~$
    #PS1="${debian_chroot:+($debian_chroot)}[${BYellow}\h${NC}](${PS1_USER_COLOR}\u${NC})${BBlue}\w${NC}\$ "
    PS1="${debian_chroot:+($debian_chroot)}[\e[1;33m\h\e[m](${PS1_USER_COLOR}\u\e[m)\e[1;34m\w\e[m\$ "
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

#------------------------------------------------------------------------------
### SET TERMINAL
#------------------------------------------------------------------------------
#case "$TERM" in
#  xterm|screen|tmux|rxvt-unicode)
#    export TERM="$TERM-256color"
#  ;;
#esac
#case "$TERM" in
#  xterm|screen|tmux|rxvt-unicode)
#    export TERM="$TERM-256color"
#    echo "running as an x-terminal - $TERM"
#  ;;
#  *)
#    echo "not running as an x-terminal - $TERM"
#  ;;
#esac
#export TERM="screen-256color"

### Export Language
#------------------------------------------------------------------------------
#export "LC_ALL=en_US.UTF-8"
#export "LANG=en_US.UTF-8"
#export "LANGUAGE=en_US.UTF-8"

### Ncurses UTF8 Fix
#------------------------------------------------------------------------------
#export "NCURSES_NO_UTF8_ACS=1"

### Enable programmable completion features
#------------------------------------------------------------------------------
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then . /etc/bash_completion; fi

### SSH Hushlogin (create ~/.hushlogin if not exists)
#------------------------------------------------------------------------------
if [[ ! -r "$HOME"/.hushlogin ]]; then touch "$HOME"/.hushlogin; fi

#------------------------------------------------------------------------------
### MAIL
#------------------------------------------------------------------------------
# Check for new mail at login if not =0 and wait ## seconds before mail checks
MAILCHECK=60
#if [ -d $HOME/Maildir/ ]; then
#  export MAIL=$HOME/Maildir/
#  export MAILPATH=$HOME/Maildir/
#  export MAILDIR=$HOME/Maildir/
#elif [ -f /var/mail/$USER ]; then
#  export MAIL="/var/mail/$USER"
#fi

#------------------------------------------------------------------------------
### Default editor
#------------------------------------------------------------------------------
export VISUAL="/bin/nano"
export EDITOR="/bin/nano"

#------------------------------------------------------------------------------
### LESS Command Options
#-------------------------------------------------------------
# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
alias more='less'
export PAGER=less
export LESSCHARSET='latin1'
export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'
                # Use this if lesspipe.sh exists.
export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f \
:stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'
# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

#------------------------------------------------------------------------------
### SSH Agent Start
#------------------------------------------------------------------------------
###/home/ken/.bashrc (ssh-agent)
#if [[ -z "$SSH_AUTH_SOCK" ]] ; then
#  eval `ssh-agent`
#  ssh-add
#fi

#------------------------------------------------------------------------------
### TMUX
#------------------------------------------------------------------------------
### Display TMUX session @ login
display_tmux="Y"
if [[ "${display_tmux}" == "Y" ]]; then
  # Do nothing if root else tmux if user
  if [[ "${UID}" -ne 0 ]]; then
    ### List TMUX active sessions after login
    if [[ -z "${TMUX}" ]]; then
      if ! tmux ls &> /dev/null; then
        printf "%s${BBlue}-------------------------------------------------------------------------------${NC}"
        printf "%s\n${BBlue}TMUX: No Active Sessions!${NC}\n"
      else
        printf "%s${BBlue}-------------------------------------------------------------------------------${NC}"
        printf "%s\n${BGreen}TMUX:\t"; tmux ls; printf "%s${NC}"
      fi
    fi
    ### Attach to active TMUX session or start new session if none available after login
    #if [ -z "$TMUX" ] && [ -n "$SSH_TTY" ] && [[ $- =~ i ]]; then tmux attach-session || tmux new-session ; fi
  fi
fi

### TMUX global variables
export TMUX_CPU_COUNT="grep -c ^processor /proc/cpuinfo"

#------------------------------------------------------------------------------
### LOGIN GREETINGS
#------------------------------------------------------------------------------
display_greeting="Y"
if [[ "${display_greeting}" == "Y" ]]; then
  greet_time="$(date "+%H")"
  #weather_report="$(curl -s "http://rss.accuweather.com/rss/liveweather_rss.asp?metric=2&locCode=85226" | sed -n '/Currently:/ s/.*: \(.*\): \([0-9]*\)\([CF]\).*/\2°\3, \1/p')"
  if [ "$greet_time" -lt 12 ]; then greeting="Good morning"
  elif [ "$greet_time" -lt 18 ]; then greeting="Good afternoon"
  else greeting="Good evening"; fi
  printf "%s${BBlue}-------------------------------------------------------------------------------${NC}\n"
  if [[ "${UID}" -ne 0 ]]; then
    printf "%s${BBlue}$greeting ${PS1_USER_COLOR}$(whoami)${NC}.\n${BYellow}It is $(date "+%c") on $HOSTNAME${NC}.\n"  # print date/hostname
    if [[ -z "${TMUX}" ]]; then
      #printf "%s${BGreen}The weather is ${weather_report} in Chandler, AZ${NC}.\n"                                       # print local weather
      printf "%s${BCyan}This is BASH ${BRed}${BASH_VERSION%.*}${BCyan}\nDISPLAY on ${BRed}$DISPLAY${NC}\n"               # print bash version and display
    fi
  else
    printf "%s${BBlue}$greeting ${PS1_USER_COLOR}$(whoami)${NC}.\n${BYellow}It is $(date "+%c") on $HOSTNAME${NC}.\n"  # print date/hostname
  fi
  printf "%s${BBlue}-------------------------------------------------------------------------------${NC}\n"
fi

#------------------------------------------------------------------------------
### Use dircolors if exist
#------------------------------------------------------------------------------
[[ -e "$HOME"/.dircolors ]] && eval "$(dircolors --sh $HOME/.dircolors)"

#------------------------------------------------------------------------------
### ALIASES
#------------------------------------------------------------------------------
#alias tmux='tmux -2'
#alias tmux='tmux new-session -n $HOSTNAME'
#alias ssh='TERM=xterm-256color ssh'
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
#-------------------------------------------------------------
# The 'ls' family
#-------------------------------------------------------------
# Add colors for filetype and  human-readable sizes by default on 'ls':
alias ls='ls -h --color'
alias lx='ls -lXB'         #  Sort by extension.
alias lk='ls -lSr'         #  Sort by size, biggest last.
alias lt='ls -ltr'         #  Sort by date, most recent last.
alias lc='ls -ltcr'        #  Sort by/show change time,most recent last.
alias lu='ls -ltur'        #  Sort by/show access time,most recent last.
alias ll="ls -lv --group-directories-first"
alias lm='ll |more'        #  Pipe through 'more'
alias lr='ll -R'           #  Recursive ls.
alias la='ll -A'           #  Show hidden files.
alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...
alias l='ls -lhF --color'
#alias ll='ls -lhAF --color'
alias lls='ls -lhASrF --color'
alias llt='ls -lhAtrF --color'
alias lld='ls -Al --group-directories-first --color'

### ALIASES - Git dotfiles
#------------------------------------------------------------------------------
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'    # dotfiles git alias command
alias dotfiles-ls='dotfiles ls-tree -r HEAD --name-only'        # list files
alias dotfiles-remove='dotfiles rm --cached'            # remove files
alias dotfiles-reset='dotfiles fetch origin && dotfiles reset --hard origin/master' # replace local files with remote

### fzf util for bash (https://github.com/junegunn/fzf)
#------------------------------------------------------------------------------
#[ -f ~/.fzf.bash ] && source "$HOME"/.fzf.bash
if [[ -f ~/.fzf.bash ]]; then source "$HOME"/.fzf.bash; fi

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
