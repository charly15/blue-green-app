# BGApp - Despliegue Blue-Green

## Descripción
Proyecto de despliegue Blue-Green usando Docker, Nginx y GitHub Actions.

## URL pública
http://157.245.233.250/

## Cómo probar
1. Probar puertos:
   - `curl http://157.245.233.250:3000` (BLUE)
   - `curl http://157.245.233.250:3001` (GREEN)
2. Probar reverse proxy:
   - `curl http://157.245.233.250/`
3. Cambiar entornos localmente:
   - `./scripts/switch.sh blue`
   - `./scripts/switch.sh green`

## Pipeline
- El pipeline se activa con tags `v*` y realiza:
  1. Build y push de la imagen a GHCR.
  2. SSH al servidor y despliega el contenedor alterno.
  3. Actualiza `/etc/nginx/current_upstream.conf` y recarga Nginx.

## Archivos importantes
- `.github/workflows/deploy.yml`
- `app/Dockerfile`
- `scripts/switch.sh`
- `nginx/sites-available-default`
- `nginx/current_upstream.conf.template`

## Evidencia
Se incluye la carpeta `evidence/` con:
- `port_checks.txt`
- `root_check.txt`
- `docker_ps.txt`
- `gh_actions_build_log.txt`
- `gh_actions_deploy_log.txt`
- screenshots (si aplica)

