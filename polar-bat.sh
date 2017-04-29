#!/bin/bash

MAC=00:22:D0:7D:A8:05

hciconfig_on()
{
	sudo hciconfig hci0 down;
	sudo hciconfig hci0 up;
}

polar_read()
{
	sudo gatttool -b $MAC --char-read -a 0x0027;
}

polar_return_bat()
{
	while read LINE; do 
		BAT=${LINE:33:2} #filter puls value from string
		BAT=$((16#$BAT)) #convert puls value from hex to dec
		echo $BAT%
	done < /dev/stdin

}

hciconfig_on
polar_read | polar_return_bat

#BAT=$((16#$BAT)) #convert puls value from hex to dec
