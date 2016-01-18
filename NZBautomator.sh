#!/ffp/bin/sh
. /ffp/start/config.cfg

####################################################################################################
#Version 0.98
#############
# This script 'should' download install and configure your folder structure to enable SABnzbd, 
# CouchPotato Sickbeard Headphones and NzbtoMedia scripts. you can set which of them to install via 
# config.cfg by setting each to either 0 or 1.
# It is configured to install the most up to date source code of the programs.
# SickBeard CouchPotato Headphones and NzbtoMedia  download from GitHub therefore it is necessary to install GIT before running this script.
# It has been written to complete a fresh install from scratch on first run of the script or to update the programs
# should one be available.
############################################################################################################
######################################Do not edit the lines below##########################################

#if [ "$bindmount" == 1 ];then
#python="/usr/bin/python"
#else
#python="/ffp/bin/python"
#fi

###############################
#get current SAB version number
###############################

if [ "$SABnzbd" == 1 ]; then

sabpkg=$(wget http://sabnzbd.org/download/ -O - | grep "Linux" | awk -F'"' '{print $2}' | awk -F'/download' '{print $1}')
sablcl=`echo $sabpkg | sed 's/.*\(SAB.*\.gz\).*/\1/'`
sabtmpdir=`printf "SABnzbd" && echo $sabpkg | sed 's/.*SABnzbd\(.*\)-.*/\1/'`

fi

##########################################################
#create directories and retrieve required restart info
##########################################################

cd "$useradmin"

if [ ! -d "$sabdata" ]
        then
            mkdir -p -m 777 "$sabdata"
            mkdir -p -m 777 "$useradmin"/configuration/sabnzbd
            mkdir -p -m 777 "$useradmin"/download/complete/movie 
            mkdir -p -m 777 "$useradmin"/download/complete/tv
            mkdir -p -m 777 "$useradmin"/download/incomplete
            chmod -R 777 "$useradmin"

	else
		if [ `grep -w -m 1 enable_https $sabconfig | cut -d ' ' -f 3` == 1 ] ;
		then
		sab_port=`grep -w -m 1 https_port $sabconfig | cut -d ' ' -f 3 | sed s/'""'//`;
		else
		sab_port=`grep -w -m 1 port $sabconfig | cut -d ' ' -f 3 | sed s/'""'//`;
		fi
fi

#########################################################################################################################
#bindmount python
#this binds ffp/bin python to usr/bin python - used by postprocessing scripts so no manual updating of the hashbang is needed
#########################################################################################################################
#
#if [ "$bindmount" == 1 ];then
#   mount --bind /ffp/bin/python2.7 /usr/bin/python
#fi

################################
#install SSL Certificates
################################

if [ ! -f /ffp/etc/ssl/certs/cacert.pem ]
	then
	wget http://curl.haxx.se/ca/cacert.pem -O /ffp/etc/ssl/certs/cacert.pem
	git config --system http.sslcainfo /ffp/etc/ssl/certs/cacert.pem
fi

################################
#install Sabnzbd
################################

if [ "$SABnzbd" == 1 ]; then

   if [ ! -d "$sabbackup" ]
	then
	mkdir "$sabbackup"
   fi
     
   cd "$sabbackup"

     if [ "$sablcl" != *.gz ]
	then
	rm -f "$sabbackup"/*

     wget "$sabpkg" -O "$sablcl"
            tar xvzf "$sablcl" 
            cp -ru "$sabtmpdir"/* "$sabdata"
	    rm -r "$sabtmpdir"
 
     elif [ ! -f "$sabdata"/SABnzbd.py ]; then
            wget "$sabpkg" -O "$sablcl"
            tar xvzf "$sablcl" 
            cp -ru "$sabtmpdir"/* "$sabdata"
	    rm -r "$sabtmpdir"

     else
            echo "SAB Already up-to-date."
sleep 2     
     fi
fi

#################################
#Install Couchpoato
#################################

if [ "$CouchPotato" == 1 ]; then
   if [ -d "$couchdata" ]; then
	cd "$couchdata"
	git pull https://github.com/RuudBurger/CouchPotatoServer	
	  else
	git clone https://github.com/RuudBurger/CouchPotatoServer "$couchdata"
	mkdir -p -m 777 "$couchconfig"
   sleep 2
   fi
fi
   
#################################
#Install Sickbeard
#################################

if [ "$SickBeard" == 1 ]; then
   if [ -d "$sickdata" ]; then 
      cd "$sickdata"
      git pull  https://github.com/SiCKRAGETV/SickRage.git
   else
      git clone https://github.com/SiCKRAGETV/SickRage.git	  "$sickdata"
      mkdir -p -m 777 "$sickconfig"
   sleep 2
   fi
fi   

#################################
#Install Headphones
#################################

if [ "$Headphones" == 1 ]; then
   if [ -d "$headdata" ]; then 
      cd "$headdata"
      git pull https://github.com/rembo10/headphones.git
   else
      git clone https://github.com/rembo10/headphones.git "$headdata"
        mkdir -p -m 777 "$headconfig"
   sleep 2
   fi
fi

#################################
#Install Mylar
#################################

if [ "$Mylar" == 1 ]; then
  if [ ! -d "$mylarconfig" ]; then
        mkdir -p -m 777 "$mylarconfig"
  fi
   if [ -d "$mylardata" ]; then 
      cd "$mylardata"
      git pull https://github.com/evilhero/mylar.git
   else
      git clone https://github.com/evilhero/mylar.git "$mylardata"
   sleep 2
   fi
fi

#################################
#Install NzbtoMedia scripts
#################################
if [ "$NzbtoMedia" == 1 ]; then
   if [ -d "$nzbtomedia" ]; then 
	cd "$nzbtomedia"
	git pull https://github.com/clinton-hall/nzbToMedia.git
	else
	git clone https://github.com/clinton-hall/nzbToMedia.git "$nzbtomedia"
   sleep 2
   fi
fi

#################################
#Start all programs
#################################
if [ "$SABnzbd" == 1 ]; then

   if pgrep -f SABnzbd.py
	then
	if [[ `grep -w -m 1 enable_https $sabconfig | cut -d ' ' -f 3` == 1 ]]; then
		wget -q --delete-after "https://localhost:$sab_sslport/sabnzbd/api?mode=shutdown&ma_username=$sab_user&ma_password=$sab_pass&apikey=$sab_api"
		else
		wget -q --delete-after "http://localhost:$sab_port/sabnzbd/api?mode=shutdown&ma_username=$sab_user&ma_password=$sab_pass&apikey=$sab_api"
	fi
sleep 5
	 $python "$sabdata"/SABnzbd.py -b 0 -d -f "$sabconfig" PYTHON_EGG_CACHE=/tmp
	else
		if [ -f "$sabconfig" ]
			then
			PYTHON_EGG_CACHE=/tmp $python "$sabdata"/SABnzbd.py -b 0 -d -f "$sabconfig" 
			else
			PYTHON_EGG_CACHE=/tmp $python "$sabdata"/SABnzbd.py -b 0 -d -s 0.0.0.0:8085 -f "$sabconfig" 
                sleep 5
		fi
   fi
   else
   echo "SABnzbd not Installed"
fi



if [ "$CouchPotato" == 1 ]; then
   
if [ -f $CPID_FILE ]; then
      #grab pid from pid file
      Pid=$(/bin/cat $CPID_FILE)
      i=0
      kill $Pid
      echo -n " Waiting for $CPKG_NAME to shut down: "
      while [ -d /proc/$Pid ]; do
         sleep 1
         let i+=1
         /bin/echo -n "$i, "
         if [ $i = 45 ]; then
            echo -n "Tired of waiting, killing $CPKG_NAME now"
            kill -9 $Pid
            rm -f $CPID_FILE
            echo "$CPKG_NAME Shutdown"
         fi
      done
      rm -f $CPID_FILE
fi
      
sleep 2

   echo -n "Starting $CPKG_NAME"
   $python "$couchdata"/CouchPotato.py --daemon --data_dir $CCONFIG_DIR --config $CCONFIG_DIR/settings.conf --pid_file $CPID_FILE
   fi



sleep 5

if [ "$SickBeard" == 1 ]; then

if [ -f $SPID_FILE ]; then
      #grab pid from pid file
      Pid=$(/bin/cat $SPID_FILE)
      i=0
      kill $Pid
      echo -n " Waiting for $SPKG_NAME to shut down: "
      while [ -d /proc/$Pid ]; do
         sleep 1
         let i+=1
         /bin/echo -n "$i, "
         if [ $i = 45 ]; then
            echo -n "Tired of waiting, killing $SPKG_NAME now"
            kill -9 $Pid
            rm -f $SPID_FILE
            echo "$SPKG_NAME Shutdown"
         fi
      done
      rm -f $SPID_FILE
fi
      
sleep 2

   echo -n "Starting $SPKG_NAME"
   $python "$sickdata"/SickBeard.py --datadir "$sickconfig" --config "$sickconfig"/config.ini -d --pidfile $SPID_FILE
   fi


sleep 5

if [ "$Headphones" == 1 ]; then
   if pgrep -f Headphones.py
      then
      if [[ `grep -w -m 1 enable_https $headconfig/config.ini | cut -d ' ' -f 3` == 1 ]]; then
         wget -q --delete-after https://localhost:$head_port/api?apikey=$head_api&cmd=shutdown
      else
         wget -q --delete-after http://localhost:$head_port/api?apikey=$head_api&cmd=shutdown
      fi

sleep 5

   $python "$headdata"/Headphones.py --datadir "$headconfig" --config "$headconfig"/config.ini  -d
   else
   $python "$headdata"/Headphones.py --datadir "$headconfig" --config "$headconfig"/config.ini -d 
   fi
   else
   echo "Headphones not Installed"
fi

if [ "$Mylar" == 1 ]; then
   if pgrep -f Mylar.py
      then
      if [[ `grep -w -m 1 enable_https $mylarconfig/config.ini | cut -d ' ' -f 3` == 1 ]]; then
         wget -q --delete-after https://localhost:$mylar_port/api?apikey=$mylar_api&cmd=shutdown
      else
         wget -q --delete-after http://localhost:$mylar_port/api?apikey=$mylar_api&cmd=shutdown
      fi

sleep 5

   $python "$mylardata"/Mylar.py --datadir "$mylarconfig" --config "$mylarconfig"/config.ini  -d
   else
   $python "$mylardata"/Mylar.py --datadir "$mylarconfig" --config "$mylarconfig"/config.ini -d 
   fi
   else
   echo "Mylar not Installed"
fi
