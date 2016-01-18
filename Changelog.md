Change log 

V0.1 initial beta release
V0.2 kill command added to stop program's if already running during update sequence
V0.3 Kill command removed as could cause .db corruption with couch and sickbeard
V0.4 Clean shutdown added for all three programs
V0.5 Added support for https, script detects whether ssl enabled (mostly for shutdown commands)
V0.6 fixed multiple directory errors on first run of the script. (please note the added fix for sabtosickbeard.py read/write errors at the bottom of the guide)
V0.65 removed reference to installing kyleks sudo package as suggested by barmalej2 in post 32 of this topic, and modified script to run SAB as root (for the time being). Various code clean ups 
V0.7 changed from midgetspy sickbeard repo to mr-orange repo, for failed download ep handling (See instructions for setup)
V0.75 Code cleanup
V0.8 Changed Mr-orange repo to Echel0n as Mr-Orange is no more! also added extra lines for issues when deleting sabnzbd folder not being able to reinstall.
v0.9 re-write to include user options to install SABnzbd, CouchPoato, SickBeard, Headphones, Mylar and NZBtoMedia scripts. Also includes python binding to include automatic updates for postprocessing scripts (this can be turned off with version 0.95)
V0.92 Error when starting Mylar with script freezing. Code cleanup.
V0.95 error with python fixed if bindmount set to 0
V0.98 rewrite to take advantage of python2.7.5 which allows env to call python correctly across the filesystem. No more need for messy hacks, hashbang editing, update failures or bindmounting
