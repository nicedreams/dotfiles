#!/bin/bash
### Custom ~/.bash_functions

function MSG_ALERT() { printf "%s${White}${On_Red}${1}${NC}\n" ;}

# Print temp of zipcode on command line
function ken-weather() { curl -s "http://rss.accuweather.com/rss/liveweather_rss.asp?metric=2&locCode=85226" | sed -n '/Currently:/ s/.*: \(.*\): \([0-9]*\)\([CF]\).*/\2°\3, \1/p' ;}

# Make your directories and files access rights sane.
function ken-sane-permissions() { chmod -R u=rwX,g=rX,o= "$@" ;}

# Show formatted ps of user processes
function ken-ps-user() { ps $@ -u "${USER}" -o pid,%cpu,%mem,bsdtime,command ; }

## Netcat (fastest way to transfer files)
# (run both commands in current directory)
# netcat-dest-pv shows progress indicator where netcat-dest does not
function ken-netcat-dest-pv() { nc -q 1 -l -p 1234 | pv -pterb -s 100G | tar xv ;}
function ken-netcat-dest() { nc -q 1 -l -p 1234 | tar xv ;}   # Run on the receiving side
function ken-netcat-source() { tar cv . | nc -q 1 "$1" 1234 ;}    # $1 is the ip address to server

## ranger
function ranger() {
  if ! /usr/bin/ranger
  then
    read -rp "Ranger not found! Press any key to install ranger and utils!"
    apt install ranger atool highlight caca-utils w3m mediainfo poppler-utils
  fi
}

## fzf ken-notes
function ken-notes() {
  cd "${HOME}"/notes && fzf --bind "f1:execute($EDITOR {})" --bind "f2:execute(less -Rf {})" --bind "f3:execute(highlight -O ansi --force {} |less -RSf)" --bind "f4:execute(bat {})" --bind "ctrl-e:execute($EDITOR {})" --bind "enter:execute(bat --color=always {} || less -Rf {})" --preview-window=right:80% --preview "(bat -p --color=always --line-range 1:50 {} || head -50)" --color dark,hl:33,hl+:37,fg+:235,bg+:136,fg+:254 --color info:254,prompt:37,spinner:108,pointer:235,marker:235 || cd -
}

# simple note function
function note()
{
  # if file doesn't exist, create it
  [ -f "${HOME}"/.notes ] || touch "${HOME}"/.notes
  # no arguments, print file
  if [ "$#" = 0 ]
  then
    cat "${HOME}"/.notes
  # edit file
  elif [ "$1" = -e ]; then
    "${EDITOR}" "${HOME}"/.notes
  # add seperator
  elif [ "$1" = -s ]; then
    echo "-------------------------------------------------" >> "${HOME}"/.notes
  # add date/time to note
  elif [ "$1" = -d ]; then
    echo "$(date "+%c")" >> "${HOME}"/.notes
  # clear file
  elif [ "$1" = -c ]; then
    > "${HOME}"/.notes
  # add all arguments to file
  else
    echo "$@" >> "${HOME}"/.notes
  fi
}

# Write a horizontal line of characters
hr() {
  # shellcheck disable=SC2183
  printf '%*s\n' "${1:-$COLUMNS}" | tr ' ' "${2:-#}"
}

# dmesg export to file
function ken-dmesg-file { dmesg > /root/dmesg."$(date +%m.%d.%Y)".txt; }

## Recycle Bin (safe delete) -----------------------------------------
#function del()
#{
#  if [[ ! -d "/${HOME}/.local/share/Trash/files/" ]]; then printf "Creating directory\n"; mkdir -pv "/${HOME}/.local/share/Trash/files/"; fi
#  mv "$@" "/${HOME}/.local/share/Trash/files/"
#}

## will not overwrite files that have the same name
function del()
{
  local trash_dir="$HOME/.Trash"
  if [[ ! -d "$trash_dir" ]]; then mkdir -pv "$trash_dir"; fi
  for file in "$@" ; do
    if [[ -d "${file}" ]] ; then
      local already_trashed="${trash_dir}"/"$(basename $file)"
      if [[ -n "$(/bin/ls -d $already_trashed*)" ]] ; then
        local count="$(/bin/ls -d $already_trashed* | /usr/bin/wc -l)"
        count=$((++count))
        /bin/mv --verbose "$file" "$trash_dir/$file$count"
        continue
      fi
    fi
    /bin/mv --verbose --backup=numbered "${file}" "${HOME}"/.Trash
  done
}
# ----------------------------------------------------------------------

## list processes using swap (enable one of three options)
function ken-swap-usage() {
  ## Listing all process swap space usage  
  #for file in /proc/*/status ; do awk '/VmSwap|Name/{printf $2 " " $3}END{ print ""}' $file; done | sort -k 2 -n -r | less
  ## Display processes using swap space sorted by used space
  #find /proc -maxdepth 2 -path "/proc/[0-9]*/status" -readable -exec awk -v FS=":" '{process[$1]=$2;sub(/^[ \t]+/,"",process[$1]);} END {if(process["VmSwap"] && process["VmSwap"] != "0 kB") printf "%10s %-30s %20s\n",process["Pid"],process["Name"],process["VmSwap"]}' '{}' \; | awk '{print $(NF-1),$0}' | sort -h | cut -d " " -f2-
  ## Display top ten processes using swap space
  find /proc -maxdepth 2 -path "/proc/[0-9]*/status" -readable -exec awk -v FS=":" '{process[$1]=$2;sub(/^[ \t]+/,"",process[$1]);} END {if(process["VmSwap"] && process["VmSwap"] != "0 kB") printf "%10s %-30s %20s\n",process["Pid"],process["Name"],process["VmSwap"]}' '{}' \; | awk '{print $(NF-1),$0}' | sort -hr | head | cut -d " " -f2- 
}

#function ken-reset-permissions()  { find "$1" -type d -exec chmod 2775 {} \; && find "$1" -type d -exec chmod g+s {} \; && find "$1" -type f -exec chmod 0664 {} \; ; }

## when was linux installed (date/time) [broken]
#function ken-installed-date() { ls -lact --full-time /etc | tail -1 | awk '{print $6,$7}' ; }

# FILE/DIR BACKUP ---------------------------------------------------
## Make backup before editing file
function safeedit() {
cp "$1" "${1}"."$(date +%Y-%m-%d_%H.%M.%S)" && "$EDITOR" "$1"
}

## Create date stamp backup of file or directory
function ken-backup-file() {
  cp "$@" "$*".backup-"$(date +%Y-%m-%d_%H.%M.%S)"
  echo "Created backup copy of $PWD/$* to $PWD/$*-$(date "+%Y-%m-%d_%H.%M.%S")" || echo "Error occured while creating backup!" 
}

## Create date stamp gzip of file or directory
function ken-backup-dir() {
  tar -czvf "$*".backup-"$(date +%Y-%m-%d_%H.%M.%S)".tar.gz "$@"
  echo "Created gzip of $PWD/$* to $PWD/$*-$(date "+%Y-%m-%d_%H.%M.%S")" || echo "Error occured while creating backup!"
}

## Create gzip backup of lxc container
function ken-backup-lxc() {
  lxc-stop -n "$(basename "$1")"
  tar --numeric-owner -cpzvf LXC-"$HOSTNAME"-"$(basename "$1")"-"$(date +%Y.%m.%d-%H.%M.%S)".tar.gz "$1"
  echo "Created gzip of $* to $PWD/$*-$(date "+%Y-%m-%d_%H.%M.%S")" || echo "Error occured while creating backup!"
}

# -----------------------------------------------------------------------

## cheat.sh website command search database
function ken-cheatsh() { curl cheat.sh/"$1"; }

## Find Top10 most used commands in history
function ken-history10() { history | awk '{print $4}' | sort  | uniq --count | sort --numeric-sort --reverse | head -10; }

# List contents of /etc/cron.*
function ken-cron-ls() { ls -l /etc/cron.{hourly,daily,weekly,monthly}; echo; tail -v -n20 /etc/crontab; echo; cat /mnt/noauto/old-ssd/var/spool/cron/crontabs/*; }

# List terminal color pallet
function ken-show-colors() { for i in {0..255}; do printf "\x1b[38;5;${i}mcolor%-5i\x1b[0m" "$i" ; if ! (( ("$i" + 1 ) % 8 )); then echo ; fi ; done; }

## Fail2log list all jail status and tail log
function ken-fail2ban-status() {
  fail_list="$(fail2ban-client status |grep "list" |tr -d , |cut -f 2)"
  for i in "${fail_list}"
    do
      fail2ban-client status "$i"
  done
  tail -v /var/log/fail2ban.log
}

## Color log tail
function ken-logtail-color() {
  if [ $# -eq 0 ]; then
    sudo tail -f /var/log/{syslog,messages}
  fi
  if [ $# -eq 1 ]; then
    sudo tail -f /var/log/{syslog,messages} | perl -pe 's/.*"$1".*/\e[1;31m$&\e[0m/g'
  fi
}

## Show system status
function ken-status {
  printf "\n\e[30;42m  ***** SYSTEM INFORMATION *****  \e[0m\n"; hostnamectl
  printf "%s\n\e[30;42m  ***** SYSTEM UPTIME / LOAD *****\tCPU COUNT: $(grep -c "name" /proc/cpuinfo)\e[0m\n"; uptime
  printf "\n\e[30;42m  ***** MEMORY *****  \e[0m\n"; free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
  printf "\n\e[30;42m  ***** DISK SPACE *****  \e[0m\n"; df -x tmpfs -x devtmpfs -x overlay -hT |sort -r -k 6,6
  printf "\n\e[30;42m  ***** TOP 10 [MEM / CPU / TIME] *****  \e[0m\n"; paste <(printf %s "$(ps -eo %mem,comm --sort=-%mem | head -n 11)") <(printf %s "$(ps -eo %cpu,comm --sort=-%cpu | head -n 11)") <(printf %s "$(ps -eo time,comm --sort=-time | head -n 11)") | column -s $'\t' -t
}

## Show docker/lxc/kvm
function ken-virt {
  printf "\n\e[30;42m  ***** RUNNING DOCKER CONTAINERS ***** \e[0m\n"; [[ -f "/usr/bin/docker" ]] && docker ps
  printf "\n\e[30;42m  ***** RUNNING LXC CONTAINERS ***** \e[0m\n"; [[ -f "/usr/bin/lxc-ls" ]] && lxc-ls -f | grep RUNNING
  printf "\n\e[30;42m  ***** RUNNING KVM VIRTUAL MACHINES ***** \e[0m\n"; [[ -f "/usr/bin/virsh" ]] && virsh list --all | grep running ; echo
}

### Compress/Decompress ----------------------------------------------------------

## Compress files based on extension
function ken-compress() {
   FILE=$1
   shift
   case $FILE in
      *.tar)     tar cvf  $FILE $* ;;
      *.tar.gz)  tar czvf $FILE $* ;;
      *.gzip)    tar czvf $FILE $* ;;
      *.tgz)     tar czvf $FILE $* ;;
      *.tar.bz2) tar cjvf $FILE $* ;;
      *.bz2)     tar cjvf $FILE $* ;;
      *.tar.xz)  tar cJvf $FILE $* ;;
      *.xz)      tar cJvf $FILE $* ;;
      *.zip)     zip $FILE $* ;;
      *.rar)     rar $FILE $* ;;
      *)         echo "Filetype not recognized" ;;
   esac
}

## Universal extract files
function ken-extract {
  if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
  else
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
  fi
}
