#!/bin/sh
echo 'Starting cmd.sh' \
       && echo 'Ending cmd.sh' \
       && /usr/bin/supervisord -n -c /etc/supervisord.conf