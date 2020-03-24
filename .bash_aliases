#!/bin/bash
### Custom ~/.bash_aliases
#------------------------------------------------------------------------------
### ALIASES
#------------------------------------------------------------------------------

# List how many CPU/Threads available
alias tools-cpu-count='grep -c ^processor /proc/cpuinfo'

## dstat
alias tools-dstat='dstat -lcmdsn'
alias tools-dstat-short='dstat -l --top-cpu -m -n --top-io --disk-util'
alias tools-dstat-long='dstat -c --top-cpu-adv --top-mem -d --top-io-adv -n -l'

## dmesg (show only err/crit/alert messages)
alias tools-dmesg-err='dmesg -l err,crit,alert'

## processes (list processes of current user)
alias tools-ps-time='ps -eo pid,comm,lstart,etime,time,args'

## display wan ip
#alias tools-show-wanip='curl http://ipecho.net/plain; echo'
#alias tools-show-wanip='curl curlmyip.com'
alias tools-show-wanip='curl ipv4.icanhazip.com'

## how far down the su (switch user) rabbit hole are we
alias tools-sulevel='echo "logname:" $(logname) ; pstree -s $$ | grep sh- -o | wc -l'

## do df command showing file system and hiding tmpfs, devtmpfs, overlay
alias tools-df='df -hT --total -x tmpfs -x devtmpfs -x overlay'

## top10 du treesize current directory
alias tools-du='du -hxc --max-depth=1 | sort -h'

## apt update/upgrade
#alias tools-upgrade='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove --purge -y && sudo apt clean -y && sudo apt autoclean -y'
alias tools-upgrade='apt update && sudo apt full-upgrade -y --auto-remove'

## check important logs for fail/error/corrupt/critial messages
#alias tools-logcheck='sudo grc tail -vf /var/log/{messages,syslog}'
#alias tools-logcheck='sudo grc grep -i -e fail -e error -e corrupt -e critical /var/log/{syslog,messages,kern.log}'
alias tools-logcheck='grc zgrep -i -e fail -e error -e corrupt -e critical /var/log/{syslog*,messages*,kern*} || zgrep -i -e fail -e error -e corrupt -e critical /var/log/{syslog*,messages*,kern*}'

## watch cpu speed in realtime
alias tools-cpuspeed='watch -n1 "cat /proc/cpuinfo | grep "MHz""'

## search ps and format nicely (takes $1)
alias tools-search-ps='ps aux | grep -v grep | grep -i -e VSZ -e'

# Find duplicate files within current directory (finds by file size then checks mdhash)
alias tools-find-duplicates='find . -not -empty -type f -printf "%s\n" | sort -rn | uniq -d | xargs -I{} -n1 find . -type f -size {}c -print0 | xargs -0 md5sum | sort | uniq -w32 --all-repeated=separate'

### Show mount points within column format
alias tools-mount-list='mount |column -t'

### Show open ports using ss command
alias tools-ss='ss -tulanp'

### DOCKER
#alias tools-docker-remove-all='docker rm $(docker ps -a -q -f status=exited)'
alias tools-docker-remove-all='docker system purge'
alias tools-docker-run-portainer='docker run -d --name=portainer -v /srv/docker/portainer/data:/data -v /var/run/docker.sock:/var/run/docker.sock -e PGID=1001 -e PUID=1001 -e TZ=America/Phoenix -p 9000:9000 --restart no portainer/portainer'
alias tools-docker-run-dockermon='docker run -ti -v /var/run/docker.sock:/var/run/docker.sock icecrime/docker-mon'
alias tools-docker-run-nginx='docker run --name nginx-pwd -d -p 80:80 -v $(pwd):/usr/share/nginx/html nginx'
alias tools-docker-run-glances='docker pull nicolargo/glances && docker run --rm -v /var/run/docker.sock:/var/run/docker.sock:ro --pid host --network host -it docker.io/nicolargo/glances'
