#!/bin/bash
lighttpd -D -f /etc/lighttpd/lighttpd.conf &
/etc/init.d/dump1090-mutability start &
while true
        do
        nc  104.155.90.204 30005 | nc localhost 30104
        sleep 1
done
