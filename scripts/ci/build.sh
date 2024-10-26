#!/bin/bash
set -e

# Configuration
SERVICES_DIR="apps"       # Directory containing the services
BUILD_TARGET=${1:-"all"}  # Default to "all" if no service specified

# Function to build a specific service
build_service() {
  local service_name=$1
  echo "Building service: $service_name"
  
  if [ -d "$SERVICES_DIR/$service_name" ]; then
    pnpm --filter "$service_name" build
    echo "Build completed for $service_name"
  else
    echo "Service $service_name does not exist in $SERVICES_DIR. Skipping."
  fi
}

# Build specified service or all services
if [ "$BUILD_TARGET" == "all" ]; then
  echo "Building all services..."
  for service in $(ls -d $SERVICES_DIR/*); do
    service_name=$(basename "$service")
    build_service "$service_name"
  done
else
  build_service "$BUILD_TARGET"
fi

echo "Build process completed."
