#!/bin/bash

systemctl stop salt minion
rm -rfi /etc/salt
zypper in salt-minion htop pydf ncdu 
systemctl start salt-minion
systemctl enable salt-minion
