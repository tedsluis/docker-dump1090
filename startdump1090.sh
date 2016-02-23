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
	# Default IP address of remote dump1090 source (currently a dump1090 instance in the google cloud):
	ip="130.211.68.85"
fi
#
# Start the web server:
/usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf &
#
# Start dump190:
/etc/init.d/dump1090-mutability start &
#
echo "Trying to get BEAST-format data from ${ip}:30005."
# Never ending loop in order to reconnect when the connection ever gets broken:
while true
        do
	#
	# Check if IP address is reachable:
	if /bin/ping -c 1 $ip &> /dev/null ; then
		echo "IP address $ip is reachable using ping!"
	else
		echo "IP address $ip is unreachable using ping!"
	fi
	#
	# Check if port 30005 is open (5 seconds timeout):
	echo -n "Remote port check:"
	/bin/nc -z -v -w5 $ip 30005
	#
	# Netstat info
	echo "Netstat:"
	/bin/netstat 
	#
	# copy BEAST-format traffic from a remote dump1090 (port 30005) to the container (port 30104).
	echo "nc $ip 30005 | nc localhost 30104" 
        /bin/nc  $ip 30005 | /bin/nc localhost 30104
	echo "Connection with ${ip}:30005 broken. Retry...."
	#
	# Wait 2 seconds before retry
        sleep 2
done
