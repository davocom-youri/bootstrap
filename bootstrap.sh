 #!/bin/bash
CONFDIR="config"

if [ -e $PWD/bootstrap.sh ]
	then printf "\nValidated directory, continuing routine."; 
	else printf "\nYou must run this script from its directory!"
		printf "\nAborting!\n"
	exit
fi

printf "\nInstall dotfiles for $USER ? [y/N]\n"
read -n 1 CONTINUE
	if [ $CONTINUE == "y" ]; then
        printf "Copy dotfiles in $PWD/$CONFDIR to $HOME\n" 
    rm $HOME/.bashrc
    rm $HOME/.alias
    rm $HOME/.screenrc
    rm $HOME/.vimrc
    rm $HOME/.guake.autostart
    rm $HOME/.conkyrc
    rm $HOME/.config/autostart/conky.desktop
    cp $PWD/$CONFDIR/ssh_config $HOME/.ssh/config
        printf "n\Copied ssh_config"
    cp $PWD/$CONFDIR/.bashrc $HOME/.bashrc
        printf "\nCopied .bashrc"
    cp $PWD/$CONFDIR/.alias $HOME/.alias && sh $HOME/.bashrc
        printf "\nCopied .alias and Sourced $HOME/.bashrc"
    cp $PWD/$CONFDIR/.screenrc $HOME/.screenrc
        printf "\nCopied .screenrc"
    cp $PWD/$CONFDIR/.vimrc $HOME/.vimrc
        printf "\nCopied .vimrc"
    cp $PWD/$CONFDIR/.conkyrc $HOME/.conkyrc
        printf "\nCopied .conkyrc\n"
# Autostart
    mkdir $HOME/.config/autostart/ 
    cp $PWD/$CONFDIR/conky.desktop $HOME/.config/autostart/
        printf "Copied conky for autostart\n"
        printf "Dotfiles succesfully deployed into $HOME\n"
        printf "Have a lot of fun!\n"
fi

printf "\nBootstrap cron for $USER ? [y/N]\n"
	read -n 1 CONTINUE
		if [ $CONTINUE == "y" ]; then

TMPFILE="/tmp/bootstrap_$USER.cronout"
    printf "\n"
    printf "\n"
read -e -p "Please input alerting Mail: " -i "email@example.com" ALERTMAILADDR
read -e -p "Please input Backup Destination: " -i "/var/backup" BACKDIR
    printf "\n"
if [ ! -f $HOME/bin/vm-backup.sh ]; then
        cp $PWD/scripts/vm-backup.sh $HOME/bin/vm-backup.sh
        chmod +x $HOME/bin/vm-backup.sh
                printf "Copied vm-backup.sh to $HOME/bin\n"
    else
                printf "vm-backup.sh already exists in $HOME/bin\n"
fi
  
if [ ! -f $HOME/bin/diskcheck.sh ]; then
        cp $PWD/scripts/diskcheck.sh $HOME/bin/diskcheck.sh
        chmod +x $HOME/bin/diskcheck.sh
                printf "Copied diskcheck.sh to $HOME/bin\n"
    else
                printf "diskcheck.sh already exists in $HOME/bin\n"
fi  
  
if [ ! -f $HOME/bin/loadmon.sh ]; then
        cp $PWD/scripts/loadmon.sh $HOME/bin/loadmon.sh
        chmod +x $HOME/bin/loadmon.sh
                printf "Copied loadmon.sh to $HOME/bin\n"
    else
                printf "loadmon.sh already exists in $HOME/bin\n"
fi  
  
    printf "\nPurge existing crontab for $USER@$HOSTNAME ? [y/N]\n"
read -n 1 CONTINUE
	if [ $CONTINUE == "y" ]; then
crontab -r
fi

crontab -l > $TMPFILE
        echo "#DOTFILES.SH $(date)" >> $TMPFILE
        echo "#=================" >> $TMPFILE
        echo "# set VARIABLES  #" >> $TMPFILE
        echo "#=================" >> $TMPFILE
        echo "PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin" >> $TMPFILE
        echo "MAILTO="$ALERTMAILADDR"" >> $TMPFILE
        echo "#=================" >> $TMPFILE
        echo "# Examples        #" >> $TMPFILE
        echo "#=================" >> $TMPFILE
        echo "# .---------------- minute (0 - 59)" >> $TMPFILE
        echo "# |  .------------- hour (0 - 23)" >> $TMPFILE
        echo "# |  |  .---------- day of month (1 - 31)" >> $TMPFILE
        echo "# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ..." >> $TMPFILE
        echo "# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7)  OR sun,mon,tue,wed,thu,fri,sat" >> $TMPFILE
        echo "# |  |  |  |  |" >> $TMPFILE
        echo "# *  *  *  *  *  command to be executed" >> $TMPFILE
        echo "# *  *  *  *  *  command --arg1 --arg2 file1 file2 2>&1" >> $TMPFILE
        echo "#=================" >> $TMPFILE
        echo "# HW Checks       #" >> $TMPFILE
        echo "#=================" >> $TMPFILE
        echo "0 * * * * $HOME/bin/diskcheck.sh $ALERTMAILADDR >/dev/null 2>&1" >> $TMPFILE
        echo "0 * * * * $HOME/bin/loadmon.sh $ALERTMAILADDR >/dev/null 2>&1" >> $TMPFILE
        echo "#=================" >> $TMPFILE
        echo "# Config Backup   #" >> $TMPFILE
        echo "#=================" >> $TMPFILE
        echo "0 0 * * * /bin/tar cvzpf $BACKDIR/$HOSTNAME-config-\$(date +\%A).tar.gz /etc /var/spool /root" >> $TMPFILE
        echo "#=================" >> $TMPFILE
        echo "# VM-Backups      #" >> $TMPFILE
        echo "#=================" >> $TMPFILE
        echo "#30 0 * * * $HOME/bin/vm-backup.sh $BACKDIR DAVO-BOOSTER 2" >> $TMPFILE
crontab $TMPFILE
rm $TMPFILE  
    printf "\nCrontab succesfully deployed for $USER@$HOSTNAME"
    printf "\nHave a lot of fun!\n"
fi        
        
exit
