# Docker image for Dump1090 Mutability

Try the dump1090 application in an easy way.   
You only need a X86_64 or AMD64 Linux docker host. No RTL-SDR receiver required.

While running this dump1090 docker container you are able to view airplanes in your web browser.   
You can always rebuild it in minutes from the latest source code.

These docker images are based on dump1090-mutability v1.15 by Oliver Jowett -also known as Obj- and my own fork with heatmap and rangeview:

* https://github.com/mutability/dump1090 (version v1.15)
* https://github.com/tedsluis/dump1090 (version v1.15_heatmaprangeview)

Note: You must use the desired github source at build time and specify the dump1090 version (1.15 or v1.15_heatmaprangeview) upon runtime.

It is build on the latest Debian image (X86_64,ADM64) according the default installation instruction by Obj. Some packages were added, because they are not default available in the official Debian Docker image. The way in which the Lighttpd and Dump1090 services are started is slidely different as is usual with containers. The configuration is of course without user interaction.

# Heatmap & rangeview features

In my fork of dump1090-mutability v1.15 I have added the following features:
* Display a csv heatmap file.
* Adjust the opacity, intensity and radius of the heatmap from a movable panel.
* Load a heatmap from the dump1090 web directory or from the heatmap panel in the browser.
* Display a KML range/altitude file.
* Display distance range rings around the antenna.
* Provide movable legends for the altitude colors and range rings.
* Toggle plane colors between Altitude colors and adb-s/mlat position colors.
* Toggle the heatmap, the range/altitude view and the range rings on and off (including their panel and legends).

# Docker Hub

The following images are available at docker hub https://hub.docker.com/r/tedsluis/dump1090-mutability:

* tedsluis/dump1090-mutability:v1 (initialversion)
* tedsluis/dump1090-mutability:v1.15 (latest version by obj)
* tedsluis/dump1090-mutability:1.15_heatmaprangeview (my fork)

# FlightAware ADS-B flight tracking forum

At FlightAware ADS-B flight tracking forum you can find two related topics:

* [Running Dump1090 Mutability in Docker container](http://discussions.flightaware.com/post184999.html)
* [Heatmap & range/altitude view for dump1090-mutability v1.15](http://discussions.flightaware.com/post180185.html)
* [Raspberry Pi + Docker = From blank SD to feeding in 15 mins](http://discussions.flightaware.com/post187461.html)

# Screenshot and video

[Using the dump1090-mutability with a heatmap and radarview (on youtube)](https://www.youtube.com/watch?v=Qz4XSFRjLTI)
<a href="http://www.youtube.com/watch?feature=player_embedded&v=Qz4XSFRjLTI"
 target="_blank"><img src="https://dl.dropboxusercontent.com/u/17865731/dump1090-20150916/dump1090.jpg" 
alt="dump1090-mutability with heatmap & radarview" width="600" height="400" border="10" /></a>

# Live view
Watch my dump1090 fork with heatmap and rangeview in the Google cloud: http://130.211.68.85/dump1090/gmap.html   
(This dump1090 runs on a 60-day free trail that is available until 9 april 2016, more info at https://cloud.google.com/free-trial/)


# Usage

### Download 
This step is optional: If you don't build the image your self it will be downloaded the first time you try to run it. In case continue at 'Run it:'.   
Download the dockerfile (select the version you want: The first is with heatmap & rangeview, the seconds is without):  
````
$ wget https://raw.githubusercontent.com/tedsluis/docker-dump1090/master/dockerfile  
or
$ wget -O dockerfile https://raw.githubusercontent.com/tedsluis/docker-dump1090/master/dockerfile.org
````

At this stage you may want to edit the dockerfile and change, for example:

* the time zone.
* the URL of your own config files (config.js and dump1090-mutability).
* your own ADS-B BEAST source IP address.
* the URL of your own heatmapdata.csv and rangeview.kml files (if you use the heatmap & rangeview source).
* the URL of your own dump1090-mutability fork.

Check the comments inside the dockerfile for more info.

### Build it:
Build the image (select the version you want):
````
$ docker build -t tedsluis/dump1090-mutability:v1.15_heatmaprangeview .
or
$ docker build -t tedsluis/dump1090-mutability:v1.15 .
````
### Run it
Run it (select the version you want):    
If you did not build the image yourself it will be downloaded from the Docker Hub.
````
$ docker run -d -h dump80 -p 8080:80 tedsluis/dump1090-mutability:v1.15_heatmaprangeview
or
$ docker run -d -h dump80 -p 8080:80 tedsluis/dump1090-mutability:v1.15
````

note: You can changes the setting remote BEAST input source in the startdump1090.sh and rebuild the docker image. Or you can specify you own remote source dump1090 IP address like this:

````
$ docker run -d -h dump01 -p 8080:80 tedsluis/dump1090-mutability:v1.15_heatmaprangeview /usr/share/dump1090-mutability/startdump1090.sh "your remote source dump1090 IP"
or
$ docker run -d -h dump01 -p 8080:80 tedsluis/dump1090-mutability:v1.15 /usr/share/dump1090-mutability/startdump1090.sh "your remote source dump1090 IP"
````

### Use it
To use th GUI, go to your browser and type:
http://IPADDRESS_DOCKERHOST:8080/dump1090 


### Run multiple containers
To run multiple dump1090 docker containers on the same host (past the following 4 lines to the commandline all at ones):
````
for i in {81..99} 
do 
docker run -h dump${i} -d -p 80${i}:80  tedsluis/dump1090-mutability:v1.15_heatmaprangeview   
done
```` 

Check if they are really running:
````
$ docker ps
````

They all get a different port name which you can use in your web browser:

http://IPADDRESS_DOCKERHOST:8081/dump1090/gmap.html
http://IPADDRESS_DOCKERHOST:8082/dump1090/gmap.html
http://IPADDRESS_DOCKERHOST:8084/dump1090/gmap.html
http://IPADDRESS_DOCKERHOST:8085/dump1090/gmap.html
http://IPADDRESS_DOCKERHOST:8086/dump1090/gmap.html
http://IPADDRESS_DOCKERHOST:8087/dump1090/gmap.html
http://IPADDRESS_DOCKERHOST:8088/dump1090/gmap.html
http://IPADDRESS_DOCKERHOST:8089/dump1090/gmap.html
http://IPADDRESS_DOCKERHOST:8090/dump1090/gmap.html
http://IPADDRESS_DOCKERHOST:8091/dump1090/gmap.html
http://IPADDRESS_DOCKERHOST:8092/dump1090/gmap.html
http://IPADDRESS_DOCKERHOST:8093/dump1090/gmap.html
http://IPADDRESS_DOCKERHOST:8094/dump1090/gmap.html
http://IPADDRESS_DOCKERHOST:8095/dump1090/gmap.html
http://IPADDRESS_DOCKERHOST:8096/dump1090/gmap.html
http://IPADDRESS_DOCKERHOST:8097/dump1090/gmap.html
http://IPADDRESS_DOCKERHOST:8098/dump1090/gmap.html
http://IPADDRESS_DOCKERHOST:8099/dump1090/gmap.html

You are probably thinking "why run 20 or more dump1090 containers on one host?". Well, for a couple of reasons:

* To proof that it is possible without any performance issue. Infact you can run hundreds of dump1090 containers on a linux host with just 4GB of RAM and a quad core.
* To show new possibilities. Imagine running hundreds of dump1090 containers in the cloud serving thousands of visitors. A load balancer could be used to distribute the load over the dump1090 instances.

### Manage the containers
Check the resource consumption per docker container and notice that it is very low compared to a VM or a raspberry:
````
$ docker stats $(docker ps -a -q)
````
A containers consumes only around 20MB memory and 2% CPU (of one of your cores).

Only the dump1090, the lighttp web server and the netcat (nc) services are running:
````
docker top <container_id>
````

To stop a container, use:
````
docker stop <container_id>
````

Or stop all your containers all at ones:
````
docker stop $(docker ps -a -q)
````

Or kill them all at ones (much faster):
````
docker kill $(docker ps -a -q)
````

Start a docker container again:
```` 
docker start <container_id>
````

Start all your containers all at ones:
````
docker start $(docker ps -a -q)
````

Remove the containers all at ones:
````
docker rm $(docker ps -a -q)
````

# Notes

These dockerfiles will override the default Dump1090 config files:

* /usr/share/dump1090-mutability/html/config.js   
* /etc/default/dump1090-mutability   

This way my personal settings like lat/lon, metric and the location of my 'radarview.kml' file are configured.

A 'heatmapdata.csv' file is downloaded from my personal dropbox to this image. 
The 'raderview.kml' is hosted from the same dropbox. It is not copied to the container, since it must be publicly accessible for the Google Map API.

Of course you should modify the dockerfile and configure the location of your own config files, heatmapdata.csv and radarview.kml files and your own remote BEAST IP address.

# 30005 Data source

This dump1090 doesn't collect ADS-B data using an antenna and a RTL SDR receiver.  
Instead it receives data using the BEAST_INPUT_PORT (30104, previously known as 30004).  

In side the container I use netcat to copy 30005 traffic from an remote dump1090 to the local 30104 BEAST input port.  
The remote dump1090 is located in the Google cloud running on a 60 days free trail (valid until 9 april 2016 and most likely continued with an other free trail account). This remote dump1090 gets his 30005 BEAST data from a raspberry pi located in my home in Utrecht, in the Netherlands. I leave this service available as long as it is not abused.

# Build & run video

[Build & run the dump1090-mutability docker image from scratch (on Youtube)](https://www.youtube.com/watch?v=h4YyFDTS6CQ)
<a href="http://www.youtube.com/watch?feature=player_embedded&v=h4YyFDTS6CQ"
 target="_blank"><img src="https://dl.dropboxusercontent.com/u/17865731/dump1090-20150916/dump1090-build.png"
alt="dump1090-mutability with heatmap & radarview" width="600" height="400" border="10" /></a>
 
  
Ted Sluis  
ted.sluis@gmail.com

