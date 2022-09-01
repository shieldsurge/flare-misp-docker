#!/bin/bash

# MISP configuration
echo "Creating FLARE MISP integration configuration file"
cd /opt/mtc/config/
sed -i "s|stixtransclient.client.key\s*=\s*.*$|stixtransclient.client.key='$AIS_KEY_PATH'|" config.properties
sed -i "s|stixtransclient.client.cert\s*=\s*.*$|stixtransclient.client.cert='$AIS_CERT_PATH'|" config.properties
sed -i "s|stixtransclient.misp.key\s*=\s*.*$|stixtransclient.misp.key='$MISP_KEY'|" config.properties

# Start supervisord
echo "Starting supervisord"
cd /
exec supervisord -c /etc/supervisor/conf.d/supervisord.conf
