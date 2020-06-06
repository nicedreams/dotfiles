#!/bin/bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ ~/.bash_functions                                                          ║
# ║ Custom functions that could be used across multiple systems                ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ FUNCTIONS                                                                  ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# The default umask 002 used for normal user / default umask for the root user is 022
# umask of 022 allows only you to write data, but anyone can read data. / umask of 002 is good when you share data with other users in the same group.
# umask of 077 is good for a completely private system. No other user can read or write your data.
#function tools-reset-permissions() { find "$@" -type d -exec chmod 0755 {} \; && find "$@" -type f -exec chmod 0664 {} \; ;}
function tools-reset-umask022() { find "$@" -type d -print0 | xargs -0 chmod 0775 && find "$@" -type f -print0 | xargs -0 chmod 0664; }
function tools-reset-umask002() { find "$@" -type d -print0 | xargs -0 chmod 0755 && find "$@" -type f -print0 | xargs -0 chmod 0644; }

# Show formatted ps of user processes
function tools-ps-user() { ps "$@" -u "${USER}" -o pid,%cpu,%mem,bsdtime,command ; }
function psu() { ps "$@" -u "${USER}" -o pid,%cpu,%mem,bsdtime,command ; }

# dmesg export to file
function tools-dmesg-file { dmesg > /root/dmesg."$(date +%m.%d.%Y)".txt; }

## cheat.sh website command search database
function tools-cheatsh() { curl cheat.sh/"$1"; }

## Find Top10 most used commands in history
function tools-history10() { history | awk '{print $4}' | sort  | uniq --count | sort --numeric-sort --reverse | head -10; }

# List contents of /etc/cron.*
function tools-cron-ls() { echo "######################"; ls -l /etc/cron.{hourly,daily,weekly,monthly}; echo "######################"; tail -v -n20 /etc/crontab; echo "######################"; crontab -l ;}

# List terminal color pallet
function tools-show-colors() { for i in {0..255}; do printf "\x1b[38;5;${i}mcolor%-5i\x1b[0m" "$i" ; if ! (( ("$i" + 1 ) % 8 )); then echo ; fi ; done; }

## Fail2log list all jail status and tail log
function tools-fail2ban-status() {
  fail_list="$(fail2ban-client status |grep "list" |tr -d , |cut -f 2)"
  for i in "${fail_list}"
    do
      fail2ban-client status "$i"
  done
  tail -v /var/log/fail2ban.log
}

## Color log tail
function tools-logtail-color() {
  if [ $# -eq 0 ]; then
    sudo tail -f /var/log/{syslog,messages}
  fi
  if [ $# -eq 1 ]; then
    sudo tail -f /var/log/{syslog,messages} | perl -pe 's/.*"$1".*/\e[1;31m$&\e[0m/g'
  fi
}

## Show system status
function tools-status {
  printf "\n\e[30;42m  ***** SYSTEM INFORMATION *****  \e[0m\n"; hostnamectl
  printf "%s\n\e[30;42m  ***** SYSTEM UPTIME / LOAD *****\tCPU COUNT: $(grep -c "name" /proc/cpuinfo)\e[0m\n"; uptime
  printf "\n\e[30;42m  ***** MEMORY *****  \e[0m\n"; free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
  printf "\n\e[30;42m  ***** DISK SPACE *****  \e[0m\n"; df -x tmpfs -x devtmpfs -x overlay -hT |sort -r -k 6,6
  printf "\n\e[30;42m  ***** TOP 10 [MEM / CPU / TIME] *****  \e[0m\n"; paste <(printf %s "$(ps -eo %mem,comm --sort=-%mem | head -n 11)") <(printf %s "$(ps -eo %cpu,comm --sort=-%cpu | head -n 11)") <(printf %s "$(ps -eo time,comm --sort=-time | head -n 11)") | column -s $'\t' -t
}

## Show docker/lxc/kvm
function tools-virt {
  printf "\n\e[30;42m  ***** RUNNING DOCKER CONTAINERS ***** \e[0m\n"; [[ -f "/usr/bin/docker" ]] && docker ps
  printf "\n\e[30;42m  ***** RUNNING LXC CONTAINERS ***** \e[0m\n"; [[ -f "/usr/bin/lxc-ls" ]] && lxc-ls -f | grep RUNNING
  printf "\n\e[30;42m  ***** RUNNING KVM VIRTUAL MACHINES ***** \e[0m\n"; [[ -f "/usr/bin/virsh" ]] && virsh list --all | grep running ; echo
}

### Netcat (fastest way to transfer files) --------------------------------------------------------------------
function tools-netcat-fastest-transfer {
[ ! -f /bin/nc ] && printf "netcat command not found at /bin/nc\n" && exit 1
case "$1" in
  --receive|--server)
    printf "%sStarting receiver/server and accepting files into: $(pwd)\nWaiting for sender...\n"
    nc -q 1 -l -p 1234 | tar xv
  ;;
  --receive-pv|--server-pv)
    printf "%sStarting receiver/server with progress and accepting files into: $(pwd)\nWaiting for sender...\n"
    nc -q 1 -l -p 1234 | pv -pterb -s 100G | tar xv
  ;;
  --send)
    printf "%sStarting transfer of files in current directory to $2\nVerify server is running --receive first if having issues.\n"
    [ -z "${$2}" ] && printf "Address of receiver/server not entered.\n" && exit 1
    tar cv . | nc -q 1 "$2" 1234
    shift
  ;;
  *)
printf "%s
  Uses netcat and tar to transfer files from sender to receiver as fast as
  possible without encryption over port 1234.
  Use only over LAN.  Not recommended for transfers over internet.

  Usage:
    $0 <OPTION>

  OPTIONS:
    --receive|--server
        Use this on server side first to prepare receiving files from sender.
        Files will be transferred to current directory command was ran in.
        Server stops listening after it receives a transfer from sender.

    --receive-pv|--server-pv
        Same as --receive but with transfer status using pv utility.

    --send <ip_address_of_server>
        Use this on sender side to send contents of current directory
        to receiver (server).  This will immediately start the transfer of all
        contents in current directory.
        (Example: $0 --send 192.168.1.100)
\n"
  ;;
esac
}

### Compress files based on extension ---------------------------------------------------------
function compress() {
   FILE=$1
   shift
   case $FILE in
      *.tar)     tar -cvf  $FILE $* ;;
      *.tar.gz|*.gzip|*.tgz)  tar -czvf $FILE $* ;;
      *.tar.bz2|*.bz2) tar -cjvf $FILE $* ;;
      *.tar.xz|*.xz)  tar -cJvf $FILE $* ;;
      *.zip)     zip $FILE $* ;;
      *.rar)     rar $FILE $* ;;
      *)         echo "Filetype not recognized" ;;
   esac
}

### Universal extract files -----------------------------------------------------------------------
function extract {
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
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)    tar -xvf "$n"    ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)    7z x ./"$n"    ;;
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

