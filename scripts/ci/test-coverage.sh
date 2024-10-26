#!/bin/bash
set -e

# Configuration
COVERAGE_DIR="coverage"
ROOT_COVERAGE_REPORT="${COVERAGE_DIR}/combined-coverage.json"
CODECOV_TOKEN=${CODECOV_TOKEN} # Codecov token as environment variable

# Create coverage directory if it doesn't exist
mkdir -p "$COVERAGE_DIR"

# Run tests with coverage for all apps and libs
echo "Running test coverage for all apps and libraries..."
pnpm jest --workspaces --coverage --coverageDirectory="$COVERAGE_DIR"

# Check for Jest coverage files
if [ ! -d "$COVERAGE_DIR" ]; then
  echo "No coverage data found. Exiting."
  exit 1
fi

# Merge all coverage reports
echo "Merging coverage reports..."
npx nyc merge "$COVERAGE_DIR" > "$ROOT_COVERAGE_REPORT"

# Check if the merged coverage report was created
if [ ! -f "$ROOT_COVERAGE_REPORT" ]; then
  echo "Combined coverage report was not generated. Exiting."
  exit 1
fi

# Push coverage to Codecov
echo "Uploading combined coverage report to Codecov..."
npx codecov -f "$ROOT_COVERAGE_REPORT" -t "$CODECOV_TOKEN"
echo "Coverage report uploaded successfully."
