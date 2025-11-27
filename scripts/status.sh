#!/bin/bash
CONF="/etc/nginx/sites-available/app"

PORT=$(grep -o "300[01]" "$CONF")

if [[ "$PORT" == "3000" ]]; then
  echo "blue"
elif [[ "$PORT" == "3001" ]]; then
  echo "green"
else
  echo "unknown"
fi
