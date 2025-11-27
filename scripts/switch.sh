#!/bin/bash

ENV=$1
CONF="/etc/nginx/sites-available/app"

if [ "$ENV" = "blue" ]; then
  sed -i 's/server 127.0.0.1:3002;/server 127.0.0.1:3001;/' "$CONF"
elif [ "$ENV" = "green" ]; then
  sed -i 's/server 127.0.0.1:3001;/server 127.0.0.1:3002;/' "$CONF"
else
  echo "Uso: switch.sh {blue|green}"
  exit 1
fi

sudo systemctl reload nginx
