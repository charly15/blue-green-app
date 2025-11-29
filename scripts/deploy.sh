#!/bin/bash

ENV=$1
TAG=$2

if [ "$ENV" = "blue" ]; then
  PORT=3001
  NAME="blue"
elif [ "$ENV" = "green" ]; then
  PORT=3002
  NAME="green"
else
  echo "Uso: deploy.sh {blue|green} {tag}"
  exit 1
fi

echo "Deteniendo contenedor $NAME si existe..."
docker rm -f "$NAME" 2>/dev/null || true

echo "Descargando imagen con tag $TAG..."
docker pull ghcr.io/charly15/blue-green-app:"$TAG"

echo "Levantando $NAME en puerto $PORT con tag $TAG..."

docker run -d \
  --name "$NAME" \
  -e ENV="$ENV" \
  -p $PORT:3000 \
  ghcr.io/charly15/blue-green-app:"$TAG"


