#!/bin/bash

# MISP configuration
echo "Creating FLARE MISP integration configuration file"
cd /opt/mtc/config/

# Start supervisord
echo "Starting supervisord"
cd /
exec supervisord -c /etc/supervisor/conf.d/supervisord.conf
