#!/bin/bash
COLOR=$1
if [ "$COLOR" != "blue" ] && [ "$COLOR" != "green" ]; then
  echo "Uso: ./switch.sh [blue|green]"
  exit 1
fi

PORT=$([ "$COLOR" = "blue" ] && echo "3001" || echo "3002")

sudo tee /etc/nginx/current_upstream.conf > /dev/null <<EOF
upstream backend {
    server 127.0.0.1:$PORT;
}
EOF

sudo systemctl reload nginx
echo "Nginx recargado. Contenedor activo: $COLOR"
