#!/bin/bash

echo "Run migrations"
sleep 30 && php /var/www/app/artisan migrate

echo "Run app"
/usr/bin/supervisord -n
