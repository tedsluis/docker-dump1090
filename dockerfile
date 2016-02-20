# More info at:
# https://github.com/tedsluis/docker-dump1090
# https://github.com/tedsluis/dump1090
# https://github.com/mutability/dump1090
# https://hub.docker.com/r/tedsluis/dump1090-mutability
# http://discussions.flightaware.com/post180185.html
# https://www.youtube.com/watch?v=h4YyFDTS6CQ

# This dockerfile can be used to build the original dump1090-mutability (v1.15) or my fork with the heatmap and rangeview features.
# Use the 'docker build --build-arg DUMP1090VERSION=<version>' to specify the correct git source!

# Build it yourself:  
#                      $ docker build --build-arg DUMP1090VERSION=v1.15_heatmaprangeview -t tedsluis/dump1090-mutability:v1.15_heatmaprangeview .
#                  or: $ docker build --build-arg DUMP1090VERSION=v1.15 -t tedsluis/dump1090-mutability:v1.15 .

# Run it:    
#                      $ docker run -d -h dump01 -p 8080:80 tedsluis/dump1090-mutability:v1.15_heatmaprangeview
#                  or: $ docker run -d -h dump01 -p 8080:80 tedsluis/dump1090-mutability:v1.15
                      
# Or run it with a different BEAST source:    
#                      $ docker run -d -h dump01 -p 8080:80 tedsluis/dump1090-mutability:v1.15_heatmaprangeview /usr/share/dump1090-mutability/startdump1090.sh <IP address of your own remote dump1090 source>
#                  or: $ docker run -d -h dump01 -p 8080:80 tedsluis/dump1090-mutability:v1.15 /usr/share/dump1090-mutability/startdump1090.sh <IP address of your own remote dump1090 source>

FROM debian:latest

MAINTAINER Ted Sluis, Utrecht, The Netherlands, ted.sluis@gmail.com

# Required settings
RUN sed -i 's/exit 101/exit 0/g' /usr/sbin/policy-rc.d
ENV DEBIAN_FRONTEND noninteractive

# Get build argument: the dump1090 version
ARG DUMP1090VERSION=v1.15_heatmaprangeview
# To be sure it is version "v1.15_heatmaprangeview" or just "v1.15" 
RUN if [ "$DUMP1090VERSION" != "v1.15_heatmaprangeview" ];then DUMP1090VERSION="v1.15"

# Install required packages:
RUN apt-get update && apt-get install -y \
	apt-utils \
	cron      \
	curl	  \
	dialog    \
 	git       \
        lighttpd  \
	netcat	  \
	python2.7 \
	wget

# Update to the latest software packages:
RUN apt-get update && apt-get upgrade -y

# Install required packages for building dump1090:
RUN apt-get update && apt-get install -y \
	debhelper        \
	dpkg-dev         \ 
	librtlsdr-dev    \
	librtlsdr0       \
	libusb-1.0-0-dev \
	pkg-config       \
	rtl-sdr 

# Prepare for install
RUN ln /usr/bin/python2.7 /usr/bin/python2
RUN mkdir /tmp/dump1090

# Clone the correct dump1090 version depending on the dump1090 fork you want to run:
RUN if [ "$DUMP1090VERSION" == "v1.15_heatmaprangeview" ];then cd /tmp/dump1090 && git clone https://github.com/tedsluis/dump1090.git   /tmp/dump1090 ; fi
RUN if [ "$DUMP1090VERSION" == "v1.15"                  ];then cd /tmp/dump1090 && git clone https://github.com/mutability/dump1090.git /tmp/dump1090 ; fi
# Build and install dump1090 from source.
RUN cd /tmp/dump1090 && dpkg-buildpackage -b
RUN cd /tmp          && dpkg -i dump1090-mutability_1.15~dev_amd64.deb

# Download heatmapdata file:
# note: In case of building an container based on https://github.com/mutability/dump1090.git you don't need this line.
RUN if [ "$DUMP1090VERSION" == "v1.15_heatmaprangeview" ];then wget -O /usr/share/dump1090-mutability/html/heatmapdata.csv https://dl.dropboxusercontent.com/u/17865731/dump1090-20150916/heatmapdata.csv ; fi

# Download config files.
# note: If you use other config files, be sure you configure them before building the image. Don't use the default config files, because you won't be able to configure them!
# Download the correct config.js version depending on the dump1090 fork you want to run:
RUN if [ "$DUMP1090VERSION" == "v1.15_heatmaprangeview" ];then wget -O /usr/share/dump1090-mutability/html/config.js       https://raw.githubusercontent.com/tedsluis/docker-dump1090/master/config.js     ; fi
RUN if [ "$DUMP1090VERSION" == "v1.15                 " ];then wget -O /usr/share/dump1090-mutability/html/config.js       https://raw.githubusercontent.com/tedsluis/docker-dump1090/master/config.js.org ; fi
RUN wget -O /etc/default/dump1090-mutability                    https://raw.githubusercontent.com/tedsluis/docker-dump1090/master/dump1090-mutability

# Open the firewall for http and incoming BEAST-format
EXPOSE 80
EXPOSE 30104

# Configure the webserver:
RUN lighty-enable-mod dump1090

# Create startdump1090.sh script
# note: Change the default IP address of the remote dump1090 source in the startdump1090.sh script or specify the script with the IP address while you start the container!
RUN wget -O /usr/share/dump1090-mutability/startdump1090.sh https://raw.githubusercontent.com/tedsluis/docker-dump1090/master/startdump1090.sh
RUN chmod 775 /usr/share/dump1090-mutability/startdump1090.sh

# Add labels
LABEL architecture="AMD64,X86_64"
LABEL dump1090version=$DUMP1090VERSION

# Start lighttp web server, BEAST-format input (netcat) and Dump1090
CMD ["/bin/bash", "/usr/share/dump1090-mutability/startdump1090.sh"]
