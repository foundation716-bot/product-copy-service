#!/usr/bin/env bash
set -euo pipefail

region="ap-northeast-2"
registry="980921712223.dkr.ecr.${region}.amazonaws.com"
image="${registry}/product-copy-service:latest"

aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "$registry" >/dev/null
docker pull "$image" >/dev/null
desired_id="$(docker image inspect "$image" --format '{{.Id}}')"
running_id="$(docker inspect product-copy-service --format '{{.Image}}' 2>/dev/null || true)"
if [[ "$desired_id" == "$running_id" ]]; then
  exit 0
fi

docker rm -f product-copy-service >/dev/null 2>&1 || true
docker run -d --name product-copy-service --restart=always -p 80:8000 -e APP_ENV=production "$image" >/dev/null
for attempt in {1..20}; do
  if curl -fsS http://127.0.0.1/health >/dev/null; then
    echo "Deployed ${desired_id}"
    exit 0
  fi
  sleep 2
done
echo 'Deployed container did not pass health check' >&2
exit 1
