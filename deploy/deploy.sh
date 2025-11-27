#!/bin/bash
set -e

# Variables
REPO_OWNER="${REPO_OWNER:-charly15}"
IMAGE="ghcr.io/${REPO_OWNER}/blue-green-app:${GITHUB_REF_NAME:-latest}"
CONF="/etc/nginx/current_upstream.conf"

# Inicializar archivo nginx si no existe
if [ ! -f "$CONF" ]; then
    echo "upstream backend { server 127.0.0.1:3001; }" | sudo tee "$CONF"
fi

# Detectar contenedor activo según nginx
CURRENT_COLOR=$(grep -o "3001" "$CONF" | grep -q 3001 && echo "blue" || echo "green")
if [ "$CURRENT_COLOR" == "blue" ]; then
    NEW_COLOR="green"
    NEW_PORT=3002
else
    NEW_COLOR="blue"
    NEW_PORT=3001
fi

echo "Deploying $NEW_COLOR on port $NEW_PORT..."

# Borrar contenedor viejo si existe y levantar el nuevo
docker rm -f "$NEW_COLOR" 2>/dev/null || true
docker run -d --name "$NEW_COLOR" -p "$NEW_PORT":3000 --restart always "$IMAGE"

# Esperar que el contenedor esté listo
for i in {1..10}; do
    if curl -s http://127.0.0.1:$NEW_PORT >/dev/null; then
        break
    fi
    echo "Esperando contenedor $NEW_COLOR..."
    sleep 2
done

if ! curl -s http://127.0.0.1:$NEW_PORT >/dev/null; then
    echo "Error: el contenedor $NEW_COLOR no arrancó correctamente"
    exit 1
fi

# Actualizar nginx
echo "upstream backend { server 127.0.0.1:$NEW_PORT; }" | sudo tee "$CONF"
sudo nginx -t && sudo systemctl reload nginx

echo "Switcheo completado. Contenedor activo: $NEW_COLOR"
