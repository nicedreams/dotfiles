#!/bin/bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ ~/.bash_functions                                                          ║
# ║ Custom functions that could be used across multiple systems                ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ FUNCTIONS                                                                  ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# Install commonly used apps
tools-install-apps() {
  # Apt Packages [Uncomment to include packages]
  apt_install=()
  apt_install+=(grc figlet tmux xclip rsync nano ncdu unzip wget curl openssh-server htop bash-completion util-linux lsb-release psmisc tree less vim git)
  apt_install+=( mailutils mutt)
  apt_install+=( python3 python3-pip)
  #apt_install+=( apt-transport-https ca-certificates gnupg2 software-properties-common)
  #apt_install+=( fd-find)
  #apt_install+=( ruby-full)
  apt_install+=( etckeeper)
  apt_install+=( lnav)
  apt_install+=( ranger atool highlight caca-utils w3m mediainfo poppler-utils)
  #apt_install+=( iputils-ping traceroute)
  #apt_install+=( dnsutils)
  apt_install+=( nmon)
  #apt_install+=( bmon iftop iotop nethogs hdparm pciutils lsof)
  #apt_install+=( virt-top)
  #apt_install+=( sysstat)
  #apt_install+=( vnstat)
  #apt_install+=( smartmontools hddtemp lm-sensors)
  #apt_install+=( libncurses5-dev libncursesw5-dev)
  #apt_install+=( gcc build-essentials)

  printf "%sFunction to install commonly used applications:\n${apt_install[*]}\n\n"
  read -p "Install selected packages [Y/N]? " -n 1 -r
  echo # move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    export DEBIAN_FRONTEND=noninteractive
    sudo apt-get install "${apt_install[@]}"
  fi
}

# broot function
br() {
    f=$(mktemp)
    (
  set +e
  broot --outcmd "$f" "$@"
  code=$?
  if [ "$code" != 0 ]; then
      rm -f "$f"
      exit "$code"
  fi
    )
    code=$?
    if [ "$code" != 0 ]; then
  return "$code"
    fi
    d=$(<"$f")
    rm -f "$f"
    eval "$d"
}

## Download/Update dotfiles from github via curl
dotfiles-download() { cd ${HOME}; curl -#L https://github.com/nicedreams/dotfiles/archive/master.tar.gz | tar -xzv --strip-components 1 --exclude={README.md,LICENSE} ; }

# Export sar data to file
tools-export-sar() { LC_ALL=C sar -A > /root/sar-${HOSTNAME}-$(printf '%(%Y-%m-%d_%H.%M.%S)T' -1).txt ; }

# Manage Services
tools-start() { systemctl start $@.service ; }
tools-stop() { systemctl stop $@.service ; }
tools-status() { systemctl status $@.service ; }
tools-restart() { systemctl restart $@.service ; }

# Sysstat - sar
tools-sar-cpu() { sar -h -u ALL ; }
tools-sar-cpu-cores() { sar -P ALL ; }
tools-sar-mem() { sar -h -r ; }
tools-sar-swap() { sar -h -S ; }
tools-sar-io() { sar -b ; }
tools-sar-io-dev() { sar -h -p -d ; }
tools-sar-load() { sar -q ; }
tools-sar-net() { sar -h -n DEV ; }

# strace
tools-whatfiles() { strace -fe trace=creat,open,openat,unlink,unlinkat $* ; }

## dmesg (show only err/crit/alert messages)
tools-dmesg-err() { dmesg -l err,crit,alert ; }

## processes (list processes of current user)
tools-ps-time() { ps -eo pid,comm,lstart,etime,time,args ; }

## display wan ip
tools-whatismyip() { curl ipv4.icanhazip.com ; }

## how far down the su (switch user) rabbit hole are we
tools-sulevel() { echo "logname:" $(logname) ; pstree -s $$ | grep sh- -o | wc -l ; }

## do df command showing file system and hiding tmpfs, devtmpfs, overlay
tools-df() { df -hT --total -x tmpfs -x devtmpfs -x overlay ; }

## top10 du treesize current directory
#tools-du() { du -hxc --max-depth=1 | sort -h ; }
#tools-du() { du -shx . | sort -h ; }
tools-du() { du -shx {,.[^.]}* | sort -hk1 ; }
#tools-du() { du -shx {,.[^.]}* 2>> /dev/null | sort -hk1 ; }

## apt update/upgrade
#tools-upgrade() { sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove --purge -y && sudo apt clean -y && sudo apt autoclean -y ; }
tools-upgrade() { sudo apt update && sudo apt full-upgrade -y --auto-remove ; }

## check important logs for fail/error/corrupt/critial messages
#tools-logcheck() { sudo grc tail -vf /var/log/{messages,syslog} ; }
#tools-logcheck() { sudo grc grep -i -e fail -e error -e corrupt -e critical /var/log/{syslog,messages,kern.log} ; }
tools-logcheck() { grc zgrep -i -e fail -e error -e corrupt -e critical /var/log/{syslog*,messages*,kern*} || zgrep -i -e fail -e error -e corrupt -e critical /var/log/{syslog*,messages*,kern*} ; }

## watch cpu speed in realtime
tools-cpu-speed() { watch -n1 "cat /proc/cpuinfo | grep "MHz"" ; }

## search ps and format nicely (takes $1)
tools-search-ps() { ps aux | grep -v grep | grep -i -e VSZ -e ; }

# Find duplicate files within current directory (finds by file size then checks mdhash)
tools-find-duplicates() { find . -not -empty -type f -printf "%s\n" | sort -rn | uniq -d | xargs -I{} -n1 find . -type f -size {}c -print0 | xargs -0 md5sum | sort | uniq -w32 --all-repeated=separate ; }

### Show mount points within column format
tools-mount-list() { mount |column -t ; }

### Show open ports using ss command
tools-ss() { ss -tulanp ; }

### DOCKER
#tools-docker-remove-all() { docker rm $(docker ps -a -q -f status=exited) ; }
tools-docker-remove-all() { docker system purge ; }
tools-docker-run-portainer() { docker run -d --name=portainer -v /srv/docker/portainer/data:/data -v /var/run/docker.sock:/var/run/docker.sock -e PGID=1001 -e PUID=1001 -e TZ=America/Phoenix -p 9000:9000 --restart no portainer/portainer ; }
tools-docker-run-dockermon() { docker run -ti -v /var/run/docker.sock:/var/run/docker.sock icecrime/docker-mon ; }
tools-docker-run-nginx() { docker run --name nginx-pwd -d -p 80:80 -v $(pwd):/usr/share/nginx/html nginx ; }
tools-docker-run-glances() { docker pull nicolargo/glances && docker run --rm -v /var/run/docker.sock:/var/run/docker.sock:ro --pid host --network host -it docker.io/nicolargo/glances ; }


## list processes using swap (enable one of three options)
tools-swap-usage() { find /proc -maxdepth 2 -path "/proc/[0-9]*/status" -readable -exec awk -v FS=":" '{process[$1]=$2;sub(/^[ \t]+/,"",process[$1]);} END {if(process["VmSwap"] && process["VmSwap"] != "0 kB") printf "%10s %-30s %20s\n",process["Pid"],process["Name"],process["VmSwap"]}' '{}' \; | awk '{print $(NF-1),$0}' | sort -hr | head | cut -d " " -f2- ; }

# umask of 022 allows only you to write data, but anyone can read data.
# umask of 077 is good for a completely private system. No other user can read or write your data.
tools-reset-umask022() { find "$@" -type d -print0 | xargs -0 chmod 0775 && find "$@" -type f -print0 | xargs -0 chmod 0664; }
tools-reset-umask002() { find "$@" -type d -print0 | xargs -0 chmod 0755 && find "$@" -type f -print0 | xargs -0 chmod 0644; }
tools-reset-sanitize() { chmod -R u=rwX,g=rX,o= "$@" ;}

# Show formatted ps of user processes
psu() { ps "$@" -u "${USER}" -o pid,%cpu,%mem,bsdtime,command  --cols $COLUMNS ; }

# Create tar/bzip2 of remote server - pull type backup
backup-tar-pull() {
  source="${1%/}"
  destination="${2%/}"
  if [[ -z "${source}" ]] || [[ -z "${destination}" ]]; then
    printf "%sCreate tar/bzip2 of remote server to local directory.\nRemote directories: /root /etc /home /usr/local/bin\n\nUsage:\n  backup-tar-pull user@server /destination\n\n"
  else
  ssh "${source}" tar -c -v --bzip2 \
    --ignore-case \
    --exclude=/*/{.cache,.git,.gvfs,.thumbnails,.local/share/Trash,.mozilla,.dotfiles,tmp,Downloads,ISO*,rdiff-backup,rsyncsnap,backup*,Sync,syncthing,git,restic*} \
    --exclude-caches-all \
    --exclude-vcs \
    --one-file-system \
    -f - /root/ /etc/ /home/ /usr/local/bin/ > \
    "${destination}"/"${source}"_"$(date +%Y-%m-%d_%H.%M.%S)".tar.bz2
  fi
}

# List terminal color pallet
tools-colors-terminal() { for i in {0..255}; do printf "\x1b[38;5;${i}mcolor%-5i\x1b[0m" "$i" ; if ! (( ("$i" + 1 ) % 8 )); then echo ; fi ; done; }

## Fail2log list all jail status and tail log
tools-fail2ban-status() {
  fail_list="$(fail2ban-client status |grep "list" |tr -d , |cut -f 2)"
  for i in "${fail_list}"
    do
      fail2ban-client status "$i"
  done
  tail -v /var/log/fail2ban.log
}

## Color log tail
tools-logtail-color() {
  #if [ $# -eq 0 ]; then sudo tail -f /var/log/{syslog,messages}; fi
  if [ $# -eq 1 ]; then sudo tail -f /var/log/{syslog,messages} | perl -pe 's/.*"$1".*/\e[1;31m$&\e[0m/g'; fi
}

## Show system status
tools-status() {
  printf "\n\e[30;42m  ***** SYSTEM INFORMATION *****  \e[0m\n"; hostnamectl
  printf "%s      Manufacturer: $(cat /sys/class/dmi/id/chassis_vendor)"
  printf "%s\n      Product Name: $(cat /sys/class/dmi/id/product_name)"
  printf "%s\n      Machine Type: $(vserver=$(lscpu | grep Hypervisor | wc -l); if [ $vserver -gt 0 ]; then echo "VM"; else echo "Physical"; fi)"
  printf "%s\n  Operating System: $(hostnamectl | grep "Operating System" | cut -d ' ' -f5-)"
  printf "%s\n            Kernel: $(uname -r)"
  printf "%s\n      Architecture: $(arch)"
  printf "%s\n    Processor Name: $(awk -F':' '/^model name/ {print $2}' /proc/cpuinfo | uniq | sed -e 's/^[ \t]*//')"
  printf "%s\n    System Main IP: $(hostname -I | awk '{print $0}')"
  printf "%s\n  Server Date/Time: $(printf '%(%m-%d-%Y %H:%M:%S)T' -1)"
  cputemp=$(</sys/class/thermal/thermal_zone0/temp); printf "%s\n   CPU Tempurature: $((cputemp/1000))c"
  printf "\n"
  printf "%s\n\e[30;42m  ***** SYSTEM UPTIME / LOAD *****\tCPU COUNT: $(grep -c "name" /proc/cpuinfo)\e[0m\n"; uptime
  printf "\n\e[30;42m  ***** MEMORY / SWAP *****  \e[0m\n"; free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'; free -m | awk 'NR==3{printf "  Swap Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
  printf "\n\e[30;42m  ***** DISK SPACE *****  \e[0m\n"; df -x tmpfs -x devtmpfs -x overlay -hT | sort -r -k 6,6
  disklow="$(df -PTh -x tmpfs -x devtmpfs -x cdrom -x overlay | grep -vE '^Filesystem' | awk '{ if($6 > 90) print $0 }')"; if [[ -n "${disklow[@]}" ]]; then printf "\n"; printf "%s\n" "--- WARNING DISK SPACE LOW (Used: >90%) ---" "${disklow[@]}"; fi
  printf "\n\e[30;42m  ***** TOP 10 [MEM / CPU / TIME] *****  \e[0m\n"; paste <(printf %s "$(ps -eo %mem,comm --sort=-%mem | head -n 11)") <(printf %s "$(ps -eo %cpu,comm --sort=-%cpu | head -n 11)") <(printf %s "$(ps -eo time,comm --sort=-time | head -n 11)") | column -s $'\t' -t
}

## Show docker/lxc/kvm
tools-virt() {
  printf "\n\e[30;42m  ***** RUNNING DOCKER CONTAINERS ***** \e[0m\n"; [[ -f "/usr/bin/docker" ]] && sudo docker ps
  printf "\n\e[30;42m  ***** RUNNING LXC CONTAINERS ***** \e[0m\n"; [[ -f "/usr/bin/lxc-ls" ]] && sudo lxc-ls -f | grep RUNNING
  printf "\n\e[30;42m  ***** RUNNING KVM GUESTS ***** \e[0m\n"; [[ -f "/usr/bin/virsh" ]] && sudo virsh list --all | grep running ; echo
}

## Write a horizontal line of characters
hr() {
  if [[ "$1" == "--help" ]]; then
    printf "Draws line of characters\n\nUsage:\n  hr <num> <symbol>\n  hr 80 *\n\nhr by itself will fill entire line with dashes\n"
  else
    #printf '%*s\n' "${1:-$COLUMNS}" | tr ' ' "${2:-#}"
    printf '%*s\n' "${1:-$COLUMNS}" | tr ' ' "${2:--}"
  fi
}

## will not overwrite files that have the same name
del()
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

### Netcat (fastest way to transfer files) --------------------------------------------------------------------
tools-netcat-fastest-transfer() {
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
compress() {
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
extract() {
  if [ -z "$1" ]; then
    # display usage if no parameters given
    printf "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>\\n"
    printf "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]\\n"
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

