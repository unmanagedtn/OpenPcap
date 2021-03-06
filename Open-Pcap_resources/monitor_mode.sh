#!/bin/bash
# just ignore first parameter to remain consistent with Opi-Pcap
[ "$#" -ne 2 ] && echo "Usage: $0 mon0 channel_number" >&2 && exit 1

intf="mon0"
channel=$2

#echo "configuring $intf to monitor mode..."
#  iw dev mon0 del ; to delete mon0 

# site_survey will delete mon0:managed after it is done
# if mon0 is up, skip creating mon0
if ( ! ifconfig | grep mon0 > /dev/null 2>&1)
then
    iw phy phy0 interface add mon0 type monitor
    ifconfig mon0 up
else
	iwconfig mon0 mode monitor > /dev/null 2>&1
fi

# it should be in monitor mode at this point
if ( ! iwconfig mon0 | grep "Mode:Monitor" > /dev/null 2>&1)
then
    # for whatever reason, it is not in Monitor mode. Retry...
    cp /etc/config/wireless_wifi_sniffer /etc/config/wireless
    /etc/init.d/network restart
    iw phy phy0 interface add mon0 type monitor
    ifconfig mon0 up
fi

#echo "configuring $intf channel to $channel..." 
iw dev ${intf} set channel ${channel} > /dev/null || (>&2 echo "Error in setting Frequency"; exit 1)

exit 0

