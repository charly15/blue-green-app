#!/bin/bash
set -e

IMAGE="ghcr.io/charly15/blue-green-app:${GITHUB_REF_NAME:-latest}"
CONF="/etc/nginx/current_upstream.conf"

# Inicializar nginx si no existe
if [ ! -f "$CONF" ]; then
    echo "upstream backend { server 127.0.0.1:3000; }" | sudo tee "$CONF"
fi

# Detectar contenedor activo
ACTIVE=$(bash /home/deployer/blue-green-app/scripts/status.sh)
if [ "$ACTIVE" == "blue" ]; then
    NEW_PORT=3001
    NEW_NAME=green
elif [ "$ACTIVE" == "green" ]; then
    NEW_PORT=3000
    NEW_NAME=blue
else
    # Default a blue si desconocido
    NEW_PORT=3000
    NEW_NAME=blue
fi

echo "Deploying $NEW_NAME on port $NEW_PORT..."

# Borrar contenedor viejo y levantar nuevo
docker rm -f "$NEW_NAME" 2>/dev/null || true
docker run -d --name "$NEW_NAME" -p "$NEW_PORT":3000 --restart always "$IMAGE"

# Esperar a que arranque
for i in {1..10}; do
    if curl -s http://127.0.0.1:$NEW_PORT >/dev/null; then
        break
    fi
    echo "Esperando contenedor $NEW_NAME..."
    sleep 2
done

if ! curl -s http://127.0.0.1:$NEW_PORT >/dev/null; then
    echo "Error: el contenedor $NEW_NAME no arrancó correctamente"
    exit 1
fi

# Actualizar nginx
bash /home/deployer/blue-green-app/scripts/switch.sh $NEW_NAME
echo "Deploy completado. Contenedor activo: $NEW_NAME"
