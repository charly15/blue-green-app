#!/bin/bash

ENV=$1
CONF="/etc/nginx/sites-available/app"

if [ "$ENV" = "blue" ]; then
  sudo sed -i '/upstream backend {/,/}/s/server .*;/server 127.0.0.1:3001;/' "$CONF"
elif [ "$ENV" = "green" ]; then
  sudo sed -i '/upstream backend {/,/}/s/server .*;/server 127.0.0.1:3002;/' "$CONF"
else
  echo "Uso: switch.sh {blue|green}"
  exit 1
fi

# Validar configuración
if sudo nginx -t; then
  echo "✓ Configuración Nginx válida"
  sudo systemctl reload nginx
else
  echo "✗ Error en la configuración de Nginx"
  exit 1
fi
