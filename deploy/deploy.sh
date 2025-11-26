#!/bin/bash
set -e

NEW_TAG=$1
IMAGE_NAME="ghcr.io/charly15/blue-green-app"
NEW_IMAGE="$IMAGE_NAME:$NEW_TAG"

APP_DIR="/home/deployer/app"
ENV_FILE="$APP_DIR/.env"
NGINX_DIR="/etc/nginx"

if [ ! -f "$ENV_FILE" ]; then
    echo "CURRENT_PRODUCTION=green" > "$ENV_FILE"
fi

source "$ENV_FILE"

if [ "$CURRENT_PRODUCTION" = "blue" ]; then
    INACTIVE_SLOT="green"
    INACTIVE_PORT="3001"
    CONF_FILE="green.conf"
else
    INACTIVE_SLOT="blue"
    INACTIVE_PORT="3000"
    CONF_FILE="blue.conf"
fi

echo "Pulling new image..."
docker pull $NEW_IMAGE

echo "Stopping old container..."
docker stop $INACTIVE_SLOT || true
docker rm $INACTIVE_SLOT || true

echo "Starting new container $INACTIVE_SLOT..."
docker run -d \
  --name $INACTIVE_SLOT \
  -p $INACTIVE_PORT:3000 \
  -e APP_COLOR=$INACTIVE_SLOT \
  $NEW_IMAGE

sleep 10

echo "Switching Nginx to $INACTIVE_SLOT..."
sudo cp $NGINX_DIR/$CONF_FILE $NGINX_DIR/current_upstream.conf
sudo nginx -t
sudo systemctl reload nginx

echo "CURRENT_PRODUCTION=$INACTIVE_SLOT" > "$ENV_FILE"

echo "Deployment finished."
