# Ad-Hoc
These scripts come in handy for creating and [Ad-Hoc network](https://en.wikipedia.org/wiki/Wireless_ad_hoc_network) over WiFi with any ubuntu pc or raspberry pi (there are also instructions for Windows 7, I suppose other win versions should be similar).

An [Ad-Hoc network](https://en.wikipedia.org/wiki/Wireless_ad_hoc_network) like this is decentralised, does not rely on a pre-existing infrastructure and devices can join it "on the fly"

I made these scripts so I could automatize this setup and use the rpi as the brain of teleoperated robots, without needing routers, antennas, or other hardware at all. I used them in this [project](https://github.com/MikeMakes/Phoebe).  
This type of network could be useful for swarm robots or sensors clouds since each device perform as a node, fowarding data throught himself if needed.

### Interfaces
From [interfaces(5) manpages](http://manpages.ubuntu.com/manpages/trusty/man5/interfaces.5.html):  
>/etc/network/interfaces contains network interface configuration information for the ifup(8) and ifdown(8) commands. This is where you configure how your system is connected to the network.

More info:  
* https://help.ubuntu.com/lts/serverguide/network-configuration.html
* https://www.cyberciti.biz/faq/setting-up-an-network-interfaces-file/

You will see two interfaces files in this repo
* interfaces.adhocPI (for a raspberry pi) _not all network drivers works in adhoc mode_
* interfaces.adhocNOTPI (for a standard pc)
You need to check that each device in the network has a different IP in his interface file. If you can recognize wich device are you running this in, you could assign the same interface file to it with the same ip everytime (As I do).  
I dont remember why the raspberry pi has another wireles interface (wlan1) but there it is and it works.

### Bash scripts
There are two scripts; adhon.sh (setup adhoc) & adhoff.sh (restore previous configuration).

* Adhon.sh simply backups your currents settings (copying /etc/network/interfaces file as /etc/network/interfaces.backup), overwrites them with the Ad-Hoc configuration (copying interface.adhocX as /etc/network/interfaces), and restarts interfaces (because this file apply to the ifup & ifdown commands).   
If the script believes that Ad-Hoc is alredy activated (=if you run adhon.sh with a file called /etc/network/interfaces.backup) it will turn it off with adhoff.sh (restoring previous configuration) and then will continue to bring Ad-Hoc up.

* Adhoff.sh does the inverse job of adhon.sh; restore previous configuration (copying /etc/network/interfaces.backup file as /etc/network/interfaces) and restarting interfaces.
