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

It is build on the latest Debian Jessie image (X86) according the default installation instruction by Obj. 
Some packages were added, because they are not default available in the official Debian Docker image.
The way in which the Lightttpd and Dump1090 services are started is slidely different as is usual with containers.
The configuration is of course without user interaction.

Docker Hub:
https://hub.docker.com/r/tedsluis/dump1090-mutability

Youtube:
https://www.youtube.com/watch?v=Qz4XSFRjLTI

FlightAware ADS-B flight tracking forum, Heatmap & range/altitude view for dump1090-mutability v1.15:
http://discussions.flightaware.com/post180185.html

Using the dump1090-mutability with a heatmap and radarview:
<a href="http://www.youtube.com/watch?feature=player_embedded&v=Qz4XSFRjLTI"
 target="_blank"><img src="https://dl.dropboxusercontent.com/u/17865731/dump1090-20150916/dump1090.jpg" 
alt="dump1090-mutability with heatmap & radarview" width="600" height="400" border="10" /></a>

# Usage

Download the dockerfile and build the image yourself:  
$ wget https://raw.githubusercontent.com/tedsluis/docker-dump1090/master/dockerfile  
$ docker build -t tedsluis/dump1090-mutability:v1 .

Run it:    
$ docker run -d -h dump01 -p 8080:80 -p 30104:30104 tedsluis/dump1090-mutability:v1

(if you don't build the image yourself it will be downloaded from the Docker Hub)

note: You can changes the setting remote BEAST input source in the startdump1090.sh and rebuild the docker image. Or you can specify you own remote source dump1090 IP address like this:

$ docker run -d -h dump01 -p 8080:80 -p 30104:30104 tedsluis/dump1090-mutability:v1 /usr/share/dump1090-mutability/startdump1090.sh "your remote source dump1090 IP"

To use th GUI, go to your browser and type:
http://IPADDRESS:8080/dump1090 

# Notes

This dockerfile will override the default Dump1090 config files:
*/usr/share/dump1090-mutability/html/config.js   
*/etc/default/dump1090-mutability   

This way my personal settings like lat/lon, metric and the location of my 'radarview.kml' file are configured.

A 'heatmapdata.csv' file is downloaded from my personal dropbox to this image. 
The 'raderview.kml' is hosted from the same dropbox. It is not copied to the container, since it must be publicly accessible for the Google Map API.

Of course you should modify the dockerfile and configure the location of your own config files, heatmapdata.csv and radarview.kml files and your own remote BEAST IP address.

# 30005 Data source

This dump1090 doesn't collect ADS-B data using an antenna and a RTL SDR receiver. 
Instead it receives data using the BEAST_INPUT_PORT (30104, previously known as 30004).

In side the container I use netcat to copy 30005 traffic from an remote dump1090 to the local 30104 BEAST input port.
The remote dump1090 is located in the Google cloud running on a 60 days free trail (valid until 9 februari 2016 and most likely continued with an other free trail account). This remote dump1090 gets his 30005 BEAST data from a raspberry pi located in my home in Utrecht, in the Netherlands. I leave this service available as long as it is not abused.

Build & run the dump1090-mutability docker image from scratch:
<a href="http://www.youtube.com/watch?feature=player_embedded&v=h4YyFDTS6CQ"
 target="_blank"><img src="https://dl.dropboxusercontent.com/u/17865731/dump1090-20150916/dump1090.jpg"
alt="dump1090-mutability with heatmap & radarview" width="600" height="400" border="10" /></a>
 

Ted Sluis


