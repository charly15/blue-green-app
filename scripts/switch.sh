#!/bin/bash
COLOR=$1
if [ "$COLOR" != "blue" ] && [ "$COLOR" != "green" ]; then
  echo "Uso: ./switch.sh [blue|green]"
  exit 1
fi

if [ "$COLOR" = "blue" ]; then
  sudo tee /etc/nginx/current_upstream.conf > /dev/null <<EOF
upstream backend {
    server 127.0.0.1:3000;
}
EOF
  echo "Cambiado a BLUE (3000)"
else
  sudo tee /etc/nginx/current_upstream.conf > /dev/null <<EOF
upstream backend {
    server 127.0.0.1:3001;
}
EOF
  echo "Cambiado a GREEN (3001)"
fi

sudo systemctl reload nginx
echo "Nginx recargado."
