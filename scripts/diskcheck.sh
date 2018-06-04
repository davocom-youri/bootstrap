#!/bin/sh
# +1 2 http://www.cyberciti.biz/tips/shell-script-to-watch-the-disk-space.html
# 0 * * * * diskcheck.sh email@example.com >/dev/null 2&1

df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read output;
  do
    echo $output
    usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
    partition=$(echo $output | awk '{ print $2 }' )
      if [ $usep -ge 90 ]; then
        echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)" |
        mail -s "Alert: Almost out of disk space $usep%" $1
      fi
done
