#!/bin/bash
set -e

# Konfigurasi
SERVICES_DIR="apps"
PUSH_TARGET=${1:-"all"}
DOCKER_REGISTRY=${DOCKER_REGISTRY:-"docker.io"}
DOCKER_USERNAME=${DOCKER_USERNAME}
DOCKER_TAG=${DOCKER_TAG}  # Menggunakan tag yang diterima dari GitHub Actions

# Login ke Docker registry
echo "Logging in to Docker registry $DOCKER_REGISTRY..."
echo "$DOCKER_PASSWORD" | docker login "$DOCKER_REGISTRY" -u "$DOCKER_USERNAME" --password-stdin
echo "Docker login successful."

# Fungsi untuk membangun dan mendorong Docker image untuk layanan tertentu
docker_push_service() {
  local service_name=$1
  local image_name="$DOCKER_REGISTRY/$DOCKER_USERNAME/$service_name:$DOCKER_TAG"

  echo "Building Docker image for service: $service_name"
  docker build -t "$image_name" "$SERVICES_DIR/$service_name"

  echo "Pushing Docker image $image_name..."
  docker push "$image_name"
  echo "Docker image pushed successfully for $service_name."
}

# Push service tertentu atau semua services
if [ "$PUSH_TARGET" == "all" ]; then
  echo "Building and pushing Docker images for all services..."
  for service in $(ls -d $SERVICES_DIR/*); do
    service_name=$(basename "$service")
    docker_push_service "$service_name"
  done
else
  docker_push_service "$PUSH_TARGET"
fi

echo "Docker push process completed."
