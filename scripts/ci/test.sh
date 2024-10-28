#!/bin/bash
set -e

TARGET=${1:-all}     # Default to 'all' if no argument is provided

echo "Running tests for target: $TARGET"

# Set Jest command based on coverage
JEST_COMMAND="pnpm exec jest --selectProjects"

# Select the target for testing
case "$TARGET" in
  apps)
    $JEST_COMMAND apps
    ;;
  libs)
    $JEST_COMMAND libs
    ;;
  all)
    $JEST_COMMAND apps libs
    ;;
  *)
    echo "Invalid target specified. Use 'apps', 'libs', or 'all'."
    exit 1
    ;;
esac

echo "Tests completed successfully for $TARGET"
