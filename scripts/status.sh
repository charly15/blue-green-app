#!/bin/bash

CONF="/etc/nginx/sites-available/app"

# Busca la línea del backend y extrae el puerto
PORT=$(grep -A2 "upstream backend" "$CONF" | grep -o "300[12]" | head -n1)

if [ "$PORT" = "3001" ]; then
  echo "blue"
elif [ "$PORT" = "3002" ]; then
  echo "green"
else
  echo "unknown"
fi
