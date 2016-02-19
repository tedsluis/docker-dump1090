#!/bin/bash
#
# note: The default remote dump1090 is a dump1090 hosted on the google cloud. It may not be up and running.
# Set our own IP address of your dump1090 source here and build the docker image or 
# specify this /usr/share/dump1090-mutability/startdump1090.sh script with the IP address of your dump1090 source while you launch the container.
#
# check for startup parameter(s)
if [ $# -gt 1 ] ; then
	echo "Too many parameters specified! Only an IP address is allowed!"
	exit 1;
fi
#
# Chech if IP is valid:
if [ $# -eq 1 ] ; then
	if [[ $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
		ip=$1
	else 
		echo "IP address $1 is not valid!"
		exit 2;
	fi
else 	
	# Default IP address of remote dump1090 source:
	ip="130.211.68.85"
fi
#
# Check if IP address is reachable:
if ping -c 1 $ip &> /dev/null ; then
	echo "IP address $ip is reachable!"
else
	echo "IP address $1 is unreachable!"
	echo "If you don't have a reachable IP address you can specify 127.0.0.1 to test the container."
	exit 3;
fi
#
echo "Trying to get BEAST-format data from ${ip}:30005."
#
# Start the web server:
lighttpd -D -f /etc/lighttpd/lighttpd.conf &
#
# Start dump190:
/etc/init.d/dump1090-mutability start &
#
# Never ending loop in order to reconnect when the connection ever gets broken:
while true
        do
	# copy BEAST-format traffic from a remote dump1090 (port 30005) to the container (port 30104).
        nc  $ip 30005 | nc localhost 30104
	echo "Connection with ${ip}:30005 broken. Retry...."
        sleep 2
done
