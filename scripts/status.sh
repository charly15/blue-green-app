#!/bin/bash

echo "=== Estado contenedores ==="
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}"

echo
CURRENT_COLOR=$(grep -oP '(?<=127.0.0.1:30)\d' /etc/nginx/current_upstream.conf 2>/dev/null)
if [ "$CURRENT_COLOR" = "0" ]; then
  echo "Nginx apunta a: BLUE (3000)"
elif [ "$CURRENT_COLOR" = "1" ]; then
  echo "Nginx apunta a: GREEN (3001)"
else
  echo "Nginx no tiene upstream definido."
fi
