#!/bin/bash

    if [[ $USER != "root" ]]; then 
        printf "\nThis script must be run as root!\n" 
        exit 1
    fi

systemctl stop winbind.service
net cache flush
rm -rfi /var/lib/samba/*.tdb
systemctl start winbind.service
