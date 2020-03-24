#!/bin/bash
### Custom ~/.bash_aliases

#------------------------------------------------------------------------------
### COLORS
#------------------------------------------------------------------------------
# Normal Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White
# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White
# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White
#
NC="\e[m"               # Color Reset

alias ken-cpu-count='grep -c ^processor /proc/cpuinfo'

## nano
# force nano for sh color syntax highlighting when file has no .sh extension
alias nano-sh='nano -Y sh'

## ranger file manager
alias r='ranger'
alias ken-ranger-backups='ranger /mnt/ssd/ssd500-backup1/backups/rsyncsnap/'

## Easily download an MP3 from youtube on the command line
which youtube-dl &> /dev/null && alias youtube-mp3="youtube-dl --extract-audio --audio-format mp3"

## dstat
alias ken-dstat='dstat -lcmdsn'
alias ken-dstat-short='dstat -l --top-cpu -m -n --top-io --disk-util'
alias ken-dstat-long='dstat -c --top-cpu-adv --top-mem -d --top-io-adv -n -l'

## dmesg
alias ken-dmesg-err='dmesg -l err,crit,alert'

## processes
alias ken-ps-time='ps -eo pid,comm,lstart,etime,time,args'

## start web server (php/python3)
alias ken-www-php='php -S 0.0.0.0:8000'
alias ken-www-python='python3 -m http.server'

## display wan ip
#alias ken-wanip='curl http://ipecho.net/plain; echo'
#alias ken-wanip='curl curlmyip.com'
alias ken-wanip='curl ipv4.icanhazip.com'

## how far down the su rabbit hole are we
alias ken-sulevel='echo "logname:" $(logname) ; pstree -s $$ | grep sh- -o | wc -l'

## do df command showing file system and hiding tmpfs, devtmpfs, overlay
alias ken-df='df -hT --total -x tmpfs -x devtmpfs -x overlay'

## top10 du treesize current directory
alias ken-du='du -hxc --max-depth=1 | sort -h'

## apt update/upgrade
#alias ken-upgrade='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove --purge -y && sudo apt clean -y && sudo apt autoclean -y'
alias ken-upgrade='apt update && sudo apt full-upgrade -y --auto-remove'

## monitor important logs
#alias ken-logcheck='sudo grc tail -vf /var/log/{messages,syslog}'
#alias ken-logcheck='sudo grc grep -i -e fail -e error -e corrupt -e critical /var/log/{syslog,messages,kern.log}'
alias ken-logcheck='grc zgrep -i -e fail -e error -e corrupt -e critical /var/log/{syslog*,messages*,kern*}'

## watch cpu speed in realtime
alias ken-cpuspeed='watch -n1 "cat /proc/cpuinfo | grep "MHz""'

## search ps and format nicely (takes $1)
alias ken-search-ps='ps aux | grep -v grep | grep -i -e VSZ -e'

## weather on the console
alias ken-weather-report='curl wttr.in/85226'

## To recursively give directories read&execute and files read privileges:
#ken-reset-permissions() { find "$1" -type d -exec chmod 755 {} \; && find "$1" -type f -exec chmod 644 {} \; ; }
#alias ken-reset-permissions='chmod -R ugo-x,u+rwX,go+rX,go-w'

# Find duplicate files within current directory (finds by file size then checks mdhash)
alias ken-find-duplicates='find . -not -empty -type f -printf "%s\n" | sort -rn | uniq -d | xargs -I{} -n1 find . -type f -size {}c -print0 | xargs -0 md5sum | sort | uniq -w32 --all-repeated=separate'

### Show mount points within column format
alias ken-mount-list='mount |column -t'

### Show open ports using ss command
alias ken-ss='ss -tulanp'

### DOCKER
#alias ken-docker-remove-all='docker rm $(docker ps -a -q -f status=exited)'
alias ken-docker-remove-all='docker system purge'
alias ken-docker-run-portainer='docker run -d --name=portainer -v /srv/docker/portainer/data:/data -v /var/run/docker.sock:/var/run/docker.sock -e PGID=1001 -e PUID=1001 -e TZ=America/Phoenix -p 9000:9000 --restart no portainer/portainer'
alias ken-docker-run-dockermon='docker run -ti -v /var/run/docker.sock:/var/run/docker.sock icecrime/docker-mon'
alias ken-docker-run-nginx='docker run --name nginx-pwd -d -p 80:80 -v $(pwd):/usr/share/nginx/html nginx'
alias ken-docker-run-glances='docker pull nicolargo/glances && docker run --rm -v /var/run/docker.sock:/var/run/docker.sock:ro --pid host --network host -it docker.io/nicolargo/glances'

### SAMBA/CIFS MOUNTS
#alias ken-cifs-mount='sudo mount -t cifs -o uid=www-data,gid=www-data,dir_mode=0755,file_mode=0644 //192.168.2.7/share /mnt/samba/quickmount'
