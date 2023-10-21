#!/usr/bin/env bash

#chmod -R 777 /var/symfony

if [ "$ENVIRONMENT" != "development" ]
then
    composer run-script env-required-scripts
else
    composer run-script entry-point-scripts-dev
fi

#chmod -R 777 /var/symfony

# Execute Docker CMD
exec "$@"