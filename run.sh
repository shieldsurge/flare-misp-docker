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
sed -i "s|^stixtransclient.client.key\s*=\s*.*$|stixtransclient.client.key='$AIS_KEY_PATH'|" config.properties
sed -i "s|^stixtransclient.client.cert\s*=\s*.*$|stixtransclient.client.cert='$AIS_CERT_PATH'|" config.properties
sed -i "s|^client.ssl.key-store\s*=\s*.*$|client.ssl.key-store=file:'$AIS_P12_PATH'|" application.properties
sed -i "s|^server.ssl.key-store\s*=\s*.*$|server.ssl.key-store=file:'$AIS_P12_PATH'|" application.properties
sed -i "s|^server.ssl.key-store-password\s*=\s*.*$|server.ssl.key-store-password=$AIS_P12_PASS|" application.properties
sed -i "s|^server.ssl.key-password\s*=\s*.*$|server.ssl.key-password=$AIS_P12_PASS|" application.properties
sed -i "s|^server.ssl.key-alias\s*=\s*.*$|server.ssl.key-alias=$AIS_P12_ALIAS|" application.properties
sed -i "s|^2way.ssl.auth\s*=\s*.*$|2way.ssl.auth=$USE_CLIENT_KEY|" application.properties
sed -i "s|^misptransclient.post.baseurl\s*=\s*.*$|misptransclient.post.baseurl=https://$MISP_SERVER/events/|" config.properties
sed -i "s|^stixtransclient.misp.url\s*=\s*.*$|stixtransclient.misp.url=https://$MISP_SERVER/health/|" config.properties
sed -i "s|^stixtransclient.misp.key\s*=\s*.*$|stixtransclient.misp.key=$MISP_KEY|" config.properties
sed -i "s|^stixtransclient.source.collection\s*=\s*.*$|stixtransclient.source.collection=$COLLECTION|" config.properties
sed -i "s|^mtc.quartz.frequency\s*=\s*.*$|mtc.quartz.frequency=$FREQUENCY|" config.properties
sed -i "s|^rtimeout\s*=\s*.*$|rtimeout=$READ_TIMEOUT|" application.properties

JAR=$(ls /opt/mtc/*.jar)
sed -i "s|^java.*-jar mtc-rest-service-.*$|java -Xmx$JAVA_HEAP_SIZE -Duser.timezone=$TIMEZONE -jar $JAR &|" /opt/mtc/runFLAREmispService.sh

# Start the MISP FLARE service
cd /opt/mtc/
/opt/mtc/runFLAREmispService.sh

# Start supervisord
echo "Starting supervisord"
cd /
exec supervisord -c /etc/supervisor/conf.d/supervisord.conf
