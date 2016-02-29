# NSA-Autonzb
This script will download and install SABNzbd, Couchpotato, SickRage, Headphones, and Mylar to your Zyxel NAS. It has been written to work with Entware-ng on an NSA325. It should work on other Zyxel Nas's as the do script worked on the 310 320 and 540 series. This script will install all required packages, and with minimal user input start up each service during boot of the nas or whenever the script is run.

Please see the forum thread for the script at http://forum.nas-central.org/viewtopic.php?f=249&t=10881 for more info

This is still a work in progress and V0.1 is an initial port from my previous script which was based on the same Nas running FFP.

Install instructions

Download Files from https://github.com/burbulence/Autonzb.git

Place autonzb.conf into /opt/usr/etc/config with read/write attributes.

place NZBautomator into /opt/etc/init.d (Note no file extension)

chmod a+x /opt/etc/init.d/NZBautomator

Start the script by rebooting the nas or run "sh /opt/etc/init.d/NZBautomator start"


Config Folders /opt/usr/etc/config

nzbget config folder /opt/share/nzbget

SAB SickRage Couchpotato Headphones Mylar data folders /opt/share



 
