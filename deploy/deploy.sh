#!/bin/bash
set -e
REPO_OWNER="${REPO_OWNER:-charly15}"
IMAGE="ghcr.io/${REPO_OWNER}/blue-green-app:${GITHUB_REF_NAME:-latest}"

# Determinar entorno actual
if grep -q "3000" /etc/nginx/current_upstream.conf 2>/dev/null; then
  NEXT="green"
else
  NEXT="blue"
fi

echo "Deploying to $NEXT..."

# Pull image
sudo docker pull "$IMAGE"

# Run on the target port
if [ "$NEXT" = "green" ]; then
  sudo docker stop green || true
  sudo docker rm green || true
  sudo docker run -d --name green -e ENV=green -p 3001:3000 "$IMAGE"
else
  sudo docker stop blue || true
  sudo docker rm blue || true
  sudo docker run -d --name blue -e ENV=blue -p 3000:3000 "$IMAGE"
fi

# Switch traffic
sudo /home/deployer/deploy/switch.sh $NEXT

echo "Despliegue en $NEXT finalizado."
