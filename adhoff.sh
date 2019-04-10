#!/bin/bash

# 02/2017 @MikeMakes
# GPU 3.0
# This has not warranties at all

# Turn off Ad-Hoc and restore the previous wlan configuration
# Used with adhon.sh is a easy way for tongle the Ad-Hoc


#############################	Useful things and error handling	##############

#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # Directory where this script is (Commentable in case it is not neccesary)

PROGNAME=$(basename $0) # A slicker error handling routine by William Shotts (www.linuxcommand.org)
error_exit() {
	echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
	exit 1
}

	
#############################	The script starts here	##############################

PI=false #Check if this is running in a rpi
grep 'BCM2708' /proc/cpuinfo && PI=true	# BCM27XX is the name of rpi's processor, if grep is succesful we are in a rpi
grep 'BCM2709' /proc/cpuinfo && PI=true # You could use this to identify differents rpis with caution, same versions of rpi share the same family chip
grep 'BCM2710' /proc/cpuinfo && PI=true # https://raspberrypi.stackexchange.com/questions/840/why-is-the-cpu-sometimes-referred-to-as-bcm2708-sometimes-bcm2835

if [ "$PI" = false ]; then sudo stop network-manager; fi #In case we are inside a regular pc, stop network-manager
#Restore interface config and removing backup
sudo cp /etc/network/interfaces.backup /etc/network/interfaces || error_exit "$LINENO: I couldn't restore the backup. Take care..."
sudo rm /etc/network/interfaces.backup || error_exit "$LINENO: I couldn't delete the backup. It's still out there..."
sudo iwconfig wlp2s0 mode Managed

sudo ifdown wlp2s0 #Turning off...
sudo ifup wlp2s0 # ...and on the wireless interface
if [ "$PI" = false ]; then sudo start network-manager; fi #In case we are inside a regular pc, restart network-manager
sudo iwlist wlp2s0 scan # Scan the networks available (this is needed with some networks adapters)
sudo iwconfig # Show actual interfaces settings
echo "All settings restored" && exit 0
