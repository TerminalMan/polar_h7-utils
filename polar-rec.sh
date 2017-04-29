#!/bin/bash

MAC=00:22:D0:7D:A8:05
LOGFILE=$(date +'%Y-%m-%d')-puls.txt

hciconfig_on()
{
	sudo hciconfig hci0 down;
	sudo hciconfig hci0 up;
}

polar_read()
{
	sudo gatttool -b $MAC --char-write-req -a 0x0013 -n 0100 --listen;
}

polar_stop()
{
	sudo gatttool -b $MAC --char-write-req -a 0x0013 -n 0000;
}

polar_return_puls()
{
	while read LINE; do 
		if [[ $LINE == *":"* ]]; then
			PULS=${LINE:39:2} #filter puls value from string
			PULS=$((16#$PULS)) #convert puls value from hex to dec
			echo $PULS
		fi
	done < /dev/stdin
}

hciconfig_on
polar_read | polar_return_puls | ts >> $LOGFILE
polar_stop
