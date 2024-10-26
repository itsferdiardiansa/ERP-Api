#!/bin/bash
set -e

# Configuration
SERVICES_DIR="apps"                        # Directory containing the services
PUSH_TARGET=${1:-"all"}                    # Defaults to "all" if no specific service specified
DOCKER_REGISTRY=${DOCKER_REGISTRY:-"docker.io"} # Default registry
DOCKER_USERNAME=${DOCKER_USERNAME}         # Docker username (set as an env variable)
DOCKER_TAG=${DOCKER_TAG:-"latest"}         # Docker tag to use for all images (default is "latest")

# Login to Docker registry
echo "Logging in to Docker registry $DOCKER_REGISTRY..."
echo "$DOCKER_PASSWORD" | docker login "$DOCKER_REGISTRY" -u "$DOCKER_USERNAME" --password-stdin
echo "Docker login successful."

# Function to build and push Docker image for a specific service
docker_push_service() {
  local service_name=$1
  local image_name="$DOCKER_REGISTRY/$DOCKER_USERNAME/$service_name:$DOCKER_TAG"

  echo "Building Docker image for service: $service_name"
  docker build -t "$image_name" "$SERVICES_DIR/$service_name"

  echo "Pushing Docker image $image_name..."
  docker push "$image_name"
  echo "Docker image pushed successfully for $service_name."
}

# Push specified service or all services
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