# Docker image for Dump1090 Mutability

This dockerfile is used to build a docker image of dump1090-mutability v1.15 modified by Ted Sluis:
https://github.com/tedsluis/dump1090

This version is based on Oliver Jowett -also known as Obj- dump1090-mutability v1.15:
https://github.com/mutability/dump1090

The following feature are added to the original version:
* Display a csv heatmap file.
* Adjust the opacity, intensity and radius of the heatmap from a movable panel.
* Load a heatmap from the dump1090 web directory or from the heatmap panel in the browser.
* Display a KML range/altitude file.
* Display dinstance range rings around the antenna.
* Provide moveable legends for the altitude colors and range rings.
* Toggle plane colors between Altitude colors and adb-s/mlat position colors.
* Toggle the heatmap, the range/altitude view and the range rings on and off (including their panel and legends).

# Usage

Download the dockerfile and build the image yourself:  

$ wget https://raw.githubusercontent.com/tedsluis/docker-dump1090/master/dockerfile
$ docker build -t tedsluis/dump1090-mutability:v1 .

Run it:    
$ docker run -p 80:8080 -p 30104:30104 tedsluis/dump1090-mutability:v1

(if you don't build the image yourself it will be downloaded from the Docker Hub)

Use the GUI:
http://IPADDRESS:8080/dump1090 

# Notes

This dockerfile will override the default Dump1090 config files:
/usr/share/dump1090-mutability/html/config.js   
/etc/default/dump1090-mutability   

This way my personal settings like lat/lon, metric and the location of my radarview.kml file are configured.

A heatmap file is downloaded from my personal dropbox to this image.

This dump1090 doesn't collect ADS-B data using a RTL SDR receiver. 
Instead it receives data using the BEAST_INPUT_PORT (30104, previously known as 30004).
In side the container I use netcat to copy 30005 traffic from an other dump1090 to the local 30104 BEAST input port.

Of cource you can modify the dockerfile and configure the location of your files and BEAST IP address.

Ted Sluis


