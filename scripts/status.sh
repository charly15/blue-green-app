#!/bin/bash
CONF="/etc/nginx/current_upstream.conf"

if [ ! -f "$CONF" ]; then
  echo "No se encontró el archivo de nginx."
  exit 1
fi

PORT=$(grep -o "300[01]" "$CONF")
if [ "$PORT" == "3000" ]; then
  echo "blue"
elif [ "$PORT" == "3001" ]; then
  echo "green"
else
  echo "unknown"
fi
