#!/bin/bash
trigger=$(/usr/bin/grep pro /proc/cpuinfo -c)
load=`cat /proc/loadavg | awk '{print $3}'`
response=`echo | awk -v T=$trigger -v L=$load 'BEGIN{if ( L > T){ print "greater"}}'`
if [[ $response = "greater" ]]
then
	mail -s "High load on $HOSTNAME - [ $load ]\n" $1
fi
