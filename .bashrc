#!/bin/bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Custom bashrc that could be used across multiple systems                   ║
# ╚════════════════════════════════════════════════════════════════════════════╝
# If not running interactively, don't do anything!
#[[ $- != *i* ]] && return
#[[ -z "$PS1" ]] && return
case $- in *i*) ;; *) return;; esac

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

bind "set completion-ignore-case on"      # Perform file completion in a case insensitive fashion
bind "set mark-symlinked-directories on"  # Immediately add a trailing slash when autocompleting symlinks to directories

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
# ║ git PS1 Prompt Functions                                                   ║
# ╚════════════════════════════════════════════════════════════════════════════╝
parse_git_branch() {
  BRANCH="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
  if [ ! "${BRANCH}" == "" ]; then
    if [ "${BRANCH}" == "master" ]; then
      BRANCH="\e[1;32m${BRANCH}\e[m"
    else
      BRANCH="\e[1;35m${BRANCH}\e[m"
    fi
    STAT="$(parse_git_dirty)"
    echo -e "[${BRANCH}${STAT}] "
  fi
}
#------------------------------------------------------------------------------
parse_git_dirty() {
  status="$(git status 2>&1 | tee)"
  #clean="$(echo -n "${status}" 2> /dev/null | grep "Your branch is up to date" &> /dev/null; echo "$?")"
  dirty="$(echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?")"
  untracked="$(echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?")"
  ahead="$(echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?")"
  newfile="$(echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?")"
  renamed="$(echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?")"
  deleted="$(echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?")"
  bits=''
  #if [ "${clean}" == "0" ]; then bits="\e[1;32m✔${bits}"; fi
  if [ "${renamed}" == "0" ]; then bits="\e[1;31m>${bits}\e[m"; fi
  if [ "${ahead}" == "0" ]; then bits="\e[1;31m+${bits}\e[m"; fi
  if [ "${newfile}" == "0" ]; then bits="\e[1;34m*${bits}\e[m"; fi
  if [ "${untracked}" == "0" ]; then bits="\e[1;33m?${bits}\e[m"; fi
  if [ "${deleted}" == "0" ]; then bits="\e[1;31mx${bits}\e[m"; fi
  if [ "${dirty}" == "0" ]; then bits="\e[1;31m!${bits}\e[m"; fi
  if [ ! "${bits}" == "" ]; then echo " ${bits}"; else echo ""; fi
}

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ PS1 PROMPT                                                                 ║
# ╚════════════════════════════════════════════════════════════════════════════╝
# Set variable identifying the chroot you work in (used in the prompt below)
if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
  debian_chroot="$(cat /etc/debian_chroot)"
fi

## Terminal color support else set PS1 with no colors
# Use fancyprompt script if exists
if [[ -e "${HOME}"/.bash_fancyprompt ]]; then
  source "${HOME}"/.bash_fancyprompt
else
  # Use normal colored prompt
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # Get color variable depending on root(red) or user(green)
    if [[ "$UID" -eq 0 ]]; then export PS1_USER_COLOR="\e[1;91m"; else export PS1_USER_COLOR="\e[1;92m"; fi

    # Set PS1 color depending on root(red) or user(green)
    export PS1="${debian_chroot:+($debian_chroot)}[\[\e[1;93m\]\h\[\e[m\]](\[\e[${PS1_USER_COLOR}\]\u\[\e[m\])\[\e[1;34m\]\w\[\e[m\]\\$ "  # Style: [hostname](username)~$
    #export PS1="${debian_chroot:+($debian_chroot)}[\[${PS1_USER_COLOR}\]\u\[\e[m\]@\[\e[1;33m\]\h\[\e[m\]]\[\e[1;34m\]\w\[\e[m\]\\$ "  # Style: [username@hostname]~$
    
    # Append git branch to current PS1
    export PS1="$PS1\$(parse_git_branch)"
  else
    # Basic PS1 without color
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
  fi
fi

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
# ║ Add fzf to PATH                                                            ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#if [[ -x ${HOME}/.fzf/bin/fzf ]]; then PATH="${PATH}:${HOME}/.fzf/bin/"; fi
if [[ -f ${HOME}/.fzf.bash ]]; then source ${HOME}/.fzf.bash; fi

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
# ║ LESS                                                                 ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#export LESS="-JMQR#3NSi~"
#export LESS="-JMQRNSi"
#export LESS="-JMQRSni"
export LESS="-R"
export MANPAGER='less -s -M +Gg'       # display percentage into document
# https://unix.stackexchange.com/questions/119/colors-in-man-pages/147
#export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
#export LESS_TERMCAP_md=$'\e[1;33m'     # begin blink
#export LESS_TERMCAP_so=$'\e[01;44;37m' # begin reverse video
#export LESS_TERMCAP_us=$'\e[01;37m'    # begin underline
#export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
#export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
#export LESS_TERMCAP_ue=$'\e[0m'        # reset underline
#---------------------------
#export LESS_TERMCAP_mb=$'\e[1;32m'
#export LESS_TERMCAP_md=$'\e[1;32m'
#export LESS_TERMCAP_me=$'\e[0m'
#export LESS_TERMCAP_se=$'\e[0m'
#export LESS_TERMCAP_so=$'\e[01;33m'
#export LESS_TERMCAP_ue=$'\e[0m'
#export LESS_TERMCAP_us=$'\e[1;4;31m'

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ DEFAULT EDITOR / VIEWER                                                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝
export EDITOR="vim"
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
diff='diff --color'
#command -v colordiff &> /dev/null && alias diff='colordiff'
command -v curl &> /dev/null && alias get-wanip="curl http://ipecho.net/plain; echo"
command -v tmux &> /dev/null && alias tmux-hn='tmux attach -t ${HOSTNAME} || tmux new-session -t ${HOSTNAME}'
command -v fzf &> /dev/null && alias preview='fzf --height=60% --preview-window=right:60% --layout=reverse --preview="bat -p --color=always --line-range 1:100 {} || head -100"'
command -v vim &> /dev/null && alias vi='vim'
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
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ The LS Family                                                              ║
# ╚════════════════════════════════════════════════════════════════════════════╝
# Add colors for filetype and  human-readable sizes by default on 'ls':
alias ls='ls -h --color'
alias l="ls -lv --group-directories-first --color"
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
# Calculator
calc() { echo "$(( $@ ))"; }
#------------------------------------------------------------------------------
# Create date stamp backup copy of file or directory
backupfile() { cp "$@" "$*"-"$(date +%Y-%m-%d_%H.%M.%S)"; echo "Created backup copy of $PWD/$* to $PWD/$*-$(date "+%Y-%m-%d_%H.%M.%S")" ; }
# Create date stamp backup gzip of file or directory
backupdir() { if ! tar -czvf "$*"-"$(date +%Y-%m-%d_%H.%M.%S)".tar.gz "$@" ; then echo "Error occured while creating backup!"; else echo "Created gzip of $PWD/$* to $PWD/$*-$(date "+%Y-%m-%d_%H.%M.%S")"; fi ; }
# Make backup before editing file
safeedit() { cp "$1" "${1}"."$(date +%Y-%m-%d_%H.%M.%S)" && "$EDITOR" "$1" ; }
#------------------------------------------------------------------------------
# Shorter version of note function called notes
notes() {
  notesfile="${HOME}/.notes"
  if [[ ! -e ${notesfile} ]]; then touch ${notesfile}; fi
  case "$1" in
    [1-9]*) line=$(sed -n "${1}"p "${notesfile}"); eval "${line}" ;;
    --clear) > "${notesfile}" ;;
    -e) ${EDITOR} "${notesfile}" ;;
    -h) printf "%snotes\t\t:displays notes\n  NUM\t\t:run line number as command\n  --clear\t:clear notesfile\n  -e\t\t:edit notesfile\n  notesfile\t:${notesfile}\n" ;;
    *) if [[ -z "$1" ]]; then cat -n "${notesfile}"; else printf '%s \n' "$*" >> "${notesfile}"; fi ;;
  esac
}

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Git Aliases / Functions                                                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝
# Git log
alias git-log="git --no-pager log --all --color=always --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' | less -r -X +/[^/]HEAD"
alias git-logf="git --no-pager log --all --color=always --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' | sed -r -e 's/\\|(\\x1b\\[[0-9;]*m)+\\\\(\\x1b\\[[0-9;]*m)+ /├\\1─╮\\2/' -e 's/(\\x1b\\[[0-9;]+m)\\|\\x1b\\[m\\1\\/\\x1b\\[m /\\1├─╯\\x1b\\[m/' -e 's/\\|(\\x1b\\[[0-9;]*m)+\\\\(\\x1b\\[[0-9;]*m)+/├\\1╮\\2/' -e 's/(\\x1b\\[[0-9;]+m)\\|\\x1b\\[m\\1\\/\\x1b\\[m/\\1├╯\\x1b\\[m/' -e 's/╮(\\x1b\\[[0-9;]*m)+\\\\/╮\\1╰╮/' -e 's/╯(\\x1b\\[[0-9;]*m)+\\//╯\\1╭╯/' -e 's/(\\||\\\\)\\x1b\\[m   (\\x1b\\[[0-9;]*m)/╰╮\\2/' -e 's/(\\x1b\\[[0-9;]*m)\\\\/\\1╮/g' -e 's/(\\x1b\\[[0-9;]*m)\\//\\1╯/g' -e 's/^\\*|(\\x1b\\[m )\\*/\\1⎬/g' -e 's/(\\x1b\\[[0-9;]*m)\\|/\\1│/g' | less -r -X +/[^/]HEAD"
# Lazy git commit
alias git-lazy-commit="git commit -am "$*" && git push"
# Delete all local git branches that have been merged and deleted from remote
alias git-prune-local="git fetch --all --prune"
# Git commit browser
git-show() {
  local commit_hash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
  local view_commit="$commit_hash | xargs -I % sh -c 'git show --color=always %'"
  git log --color=always \
    --format="%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" "$@" | \
  fzf --no-sort --tiebreak=index --no-multi --reverse --ansi \
    --header="enter to view, alt-y to copy hash" --preview="$view_commit" \
    --bind="enter:execute:$view_commit | less -R" \
    --bind="alt-y:execute:$commit_hash | xclip -selection clipboard"
}

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ TMUX                                                                       ║
# ╚════════════════════════════════════════════════════════════════════════════╝
tmux-ns() { tmux new-session -s "$1" ; }
alias tmux-new-tripanewindow='tmux new-window \; split-window -v \; select-pane -t 1 \; split-window -h \; select-pane -t 3 \; set-option -w monitor-activity off \;'
#------------------------------------------------------------------------------
# TMUX global variables
export TMUX_CPU_COUNT="grep -c ^processor /proc/cpuinfo"
#------------------------------------------------------------------------------
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
      printf "%s  $(tmux ls)\\n"
      printf "╚════════════════════════════════════════════════════════════════════════════╝\\n"
    fi
  fi
fi
#------------------------------------------------------------------------------
# Attach to active TMUX session or start new session if none available after login
#if [[ -z "${TMUX}" || "${SSH_CLIENT}" || "${SSH_TTY}" || ${EUID} = 0 ]]; then tmux attach || tmux new-session ; fi
# If ssh detected attach to existing tmux session or create new one
#if [[ -n "${SSH_CONNECTION}" || "${SSH_CLIENT}" ]]; then tmux attach || tmux new-session -t ${HOSTNAME}; fi

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Import alias/function definitions from file if exist.                      ║
# ╚════════════════════════════════════════════════════════════════════════════╝
for file in "${HOME}"/{.bash_colors,.bash_aliases,.bash_functions}; do [[ -r "$file" ]] && source "$file"; done; unset file
#------------------------------------------------------------------------------
