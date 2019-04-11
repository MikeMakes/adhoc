#!/bin/bash

# 02/2017 @MikeMakes
# GPU 3.0
# This has not warranties at all

# What does this do?


#############################	Useful things and error handling	##############

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # Directory where this script is (Commentable in case it is not neccesary)

PROGNAME=$(basename $0) # A slicker error handling routine by William Shotts (www.linuxcommand.org)
error_exit() {
	echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
	exit 1
}
	
#############################	The script starts here	##############################

if [ -e /etc/network/interfaces.bck ]; then	# Ooops if there is alredy a backup we should be alredy in Ad-Hoc mode
	echo "Backup alredy exist. Ad-Hoc probably on, trying to turn it off and then continuing" # Just in case, we turn it off and try again (so we can 'restart' the network easily)
	.$DIR/ahoff.sh
else
	echo "Backup /etc/network/interfaces as /etc/network/interfaces/interfaces.bck" # Make backup
	cp /etc/network/interfaces /etc/network/interfaces.d/interfaces.bck || error_exit "$LINENO: Error creating backup"
fi


# >adh on $iface_name
# 	si no -e /etc/network/interfaces.d/adhoc_ifaces
# 		configurar /etc/network/interfaces.d/adhoc_ifaces; ssid, channel, pass, freq... con allow-adhoc $iface_name
# 		Escribir en interfaces "source /etc/network/interfaces.d/adhoc_ifaces"
#	else
#		grep -allow-adhoc xxx xxx xxx y si no esta ahi $iface_name: configurar nueva iface $iface_name: ssid, channel, pass, freq... en /etc/network/interfaces.d/adhoc_ifaces
# 	Desactivar dhcpl, ifdown ifup --allow=adhoc $iface_name	


# >adh off $iface_name 
# 	ifdown allow-adhoc $iface_name 
#	ifup -a
#	dhcpl
