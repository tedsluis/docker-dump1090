# More info at:
# https://github.com/tedsluis/docker-dump1090
# https://hub.docker.com/r/tedsluis/dump1090-mutability

# Build:  $ docker build -t tedsluis/dump1090-mutability:v1 .

# Run:    $ docker run -d -h dump01 -p 8080:80 -p 30104:30104 tedsluis/dump1090-mutability:v1
# or :    $ docker run -d -h dump01 -p 8080:80 -p 30104:30104 tedsluis/dump1090-mutability:v1 /usr/share/dump1090-mutability/startdump1090.sh <IP address of your own remote dump1090 source>

FROM debian:latest

MAINTAINER Ted Sluis, Utrecht, The Netherlands, ted.sluis@gmail.com

# Required settings
RUN sed -i 's/exit 101/exit 0/g' /usr/sbin/policy-rc.d
ENV DEBIAN_FRONTEND noninteractive

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

# clone, build and install dump1090 from source.
# note: You can also replace the https://github.com/tedsluis/dump1090.git repo with https://github.com/mutability/dump1090.git, but that one needs a slidely different config.js!
RUN cd /tmp/dump1090 && git clone https://github.com/tedsluis/dump1090.git /tmp/dump1090
RUN cd /tmp/dump1090 && dpkg-buildpackage -b
RUN cd /tmp          && dpkg -i dump1090-mutability_1.15~dev_amd64.deb

# Download heatmapdata file:
# note: In case of building an container based on https://github.com/mutability/dump1090.git you don't need this line.
RUN wget -O /usr/share/dump1090-mutability/html/heatmapdata.csv https://dl.dropboxusercontent.com/u/17865731/dump1090-20150916/heatmapdata.csv

# Download config files.
# note: If you use other config files, be sure you configure them before building the image. Don't use the default config files, because you won't be able to configure them!
RUN wget -O /usr/share/dump1090-mutability/html/config.js       https://raw.githubusercontent.com/tedsluis/docker-dump1090/master/config.js
RUN wget -O /etc/default/dump1090-mutability                    https://raw.githubusercontent.com/tedsluis/docker-dump1090/master/dump1090-mutability

# Open the firewall for http and incoming BEAST-format
EXPOSE 80
EXPOSE 30104

# Configure the webserver:
RUN lighty-enable-mod dump1090

# Create startdump1090.sh script
# note: Change the default IP address of the remote dump1090 source in the startdump1090.sh script or specify the script with the IP address while you start the container!
RUN wget -O /usr/share/dump1090-mutability/startdump1090.sh https://raw.githubusercontent.com/tedsluis/docker-dump1090/master/startdump1090.sh
RUn chmod 775 /usr/share/dump1090-mutability/startdump1090.sh

# Start lighttp, BEAST-format input and Dump1090
CMD ["/bin/bash", "/usr/share/dump1090-mutability/startdump1090.sh"]
