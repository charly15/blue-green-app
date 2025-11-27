#!/bin/bash
set -e

# Configuración
REPO_OWNER="${REPO_OWNER:-charly15}"
IMAGE="ghcr.io/${REPO_OWNER}/blue-green-app:${GITHUB_REF_NAME:-latest}"
CONF="/etc/nginx/current_upstream.conf"

# Inicializar archivo nginx si no existe
if [ ! -f "$CONF" ]; then
    echo "server 127.0.0.1:8080;" | sudo tee "$CONF"
fi

# Detectar contenedor activo
CURRENT_PORT=$(grep -o "808[01]" "$CONF")
if [ "$CURRENT_PORT" == "8080" ]; then
    NEW_PORT=8081
    NEW_NAME=green
else
    NEW_PORT=8080
    NEW_NAME=blue
fi

echo "Deploying $NEW_NAME on port $NEW_PORT..."

# Borrar contenedor viejo si existe y levantar el nuevo
docker rm -f "$NEW_NAME" 2>/dev/null || true
docker run -d --name "$NEW_NAME" -p "$NEW_PORT":3000 --restart always "$IMAGE"

# Esperar a que el contenedor esté listo
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
echo "server 127.0.0.1:$NEW_PORT;" | sudo tee "$CONF"
sudo nginx -t && sudo systemctl reload nginx

echo "Switcheo completado. Contenedor activo: $NEW_NAME"
