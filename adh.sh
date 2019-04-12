#!/bin/bash

# 02/2017 @MikeMakes
# GPU 3.0
# This has not warranties at all

# What does this do?
# Usage:
# adh [on/off] [$iface_name]


#############################	Useful things and error handling	##############

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # Directory where this script is (Commentable in case it is not neccesary)

PROGNAME=$(basename $0) # A slicker error handling routine by William Shotts (www.linuxcommand.org)
error_exit() {
	echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
	exit 1
}
	
#############################	The script starts here	##############################

WD=/etc/network
IFS=/etc/network/interfaces
ADH_IFS=/etc/network/interfaces.d/adhoc_ifaces

if [ -e /etc/network/interfaces.bck ]; then	# Ooops if there is alredy a backup we should be alredy in Ad-Hoc mode
	echo "Backup alredy exist. Ad-Hoc probably on, trying to turn it off and then continuing" # Just in case, we turn it off and try again (so we can 'restart' the network easily)
	.$DIR/ahoff.sh
else
	echo "Backup /etc/network/interfaces as /etc/network/interfaces/interfaces.bck" # Make backup
	cp /etc/network/interfaces /etc/network/interfaces.d/interfaces.bck || error_exit "$LINENO: Error creating backup"
fi

if [ ! -e $ADH_IFS ]; then # If there isnt this file (first time running),
	touch $ADH_IFS  && echo "allow-adhoc" >> $ADH_IFS # lets create it
fi

TURN=$1
IFACE_NAME=$2

# >adh on $iface_name
if [ $TURN = "on" ]; then 
	grep "$IFACE_NAME" $ADH_IFS && IFACE_EXISTS=true	# if we find $iface_name in adhoc_ifaces, this iface was alredy setup
	if [ ! $IFACE_EXISTS ]; then # If it is not there, it will:
		echo "Creating Ad-Hoc interface $IFACE_NAME in $ADH_IFS"
		echo "Please enter ssid:"
		read SSID
		echo "Please enter channel:"
		read CHANNEL
		echo "Please enter frequency:"
		read FREQ
		echo "Please enter password:"
		read PASS
		# Write all this down in $ADH_IFS
fi
	sudo systemctl stop dhcpcd.service # Stop dhcpl bc it could interfere with interfaces
	sudo ifdown ** && sudo ifup --allow=adhoc $IFACE_NAME
fi

# >adh off $iface_name
if [ $TURN = "off" ]; then
	sudo ifdown --allow=adhoc $iface_name && sudo ifup -a
	sudo systemctl start dhcpcd.service
fi
