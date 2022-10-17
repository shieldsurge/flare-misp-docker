#!/bin/bash

# Fix timezone (adapt to your local zone)
if [ -z "$TIMEZONE" ]; then
        echo "TIMEZONE is not set, please configure the local time zone manually later..."
else
        echo "$TIMEZONE" > /etc/timezone
        dpkg-reconfigure -f noninteractive tzdata >>/tmp/install.log
fi

# MISP configuration
echo "Creating FLARE MISP integration configuration file"
cd /opt/mtc/config/
sed -i "s|stixtransclient.client.key\s*=\s*.*$|stixtransclient.client.key='$AIS_KEY_PATH'|" config.properties
sed -i "s|stixtransclient.client.cert\s*=\s*.*$|stixtransclient.client.cert='$AIS_CERT_PATH'|" config.properties
sed -i "s|stixtransclient.misp.key\s*=\s*.*$|stixtransclient.misp.key='$MISP_KEY'|" config.properties
sed -i "s|stixtransclient.source.collection\s*=\s*.*$|stixtransclient.source.collection='$COLLECTION'|" config.properties

# Start the MISP FLARE service
cd /opt/mtc/
/opt/mtc/runFLAREmispService.sh

# Start supervisord
echo "Starting supervisord"
cd /
exec supervisord -c /etc/supervisor/conf.d/supervisord.conf
