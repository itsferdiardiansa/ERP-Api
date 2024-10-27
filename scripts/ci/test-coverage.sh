#!/bin/bash
set -e

# Directories for individual coverage reports
APPS_COVERAGE="coverage/unit"
LIBS_COVERAGE="coverage/integration"
COMBINED_COVERAGE="coverage/combined"
TEMP_COVERAGE="coverage/temp"

# Clear previous coverage reports
rm -rf "$APPS_COVERAGE" "$LIBS_COVERAGE" "$COMBINED_COVERAGE" "$TEMP_COVERAGE"
mkdir -p "$COMBINED_COVERAGE" "$TEMP_COVERAGE"

# Run unit and integration tests with coverage
echo "Running unit tests with coverage..."
jest --coverage --coverageDirectory="$APPS_COVERAGE" --selectProjects apps --passWithNoTests || { echo "Unit tests failed. Exiting."; exit 1; }

echo "Running integration tests with coverage..."
jest --coverage --coverageDirectory="$LIBS_COVERAGE" --selectProjects libs --passWithNoTests || { echo "Integration tests failed. Exiting."; exit 1; }

# Symlink coverage files into temp directory for merging
if [[ -f "$APPS_COVERAGE/coverage-final.json" && -f "$LIBS_COVERAGE/coverage-final.json" ]]; then
    ln -s "$PWD/$APPS_COVERAGE/coverage-final.json" "$TEMP_COVERAGE/unit-coverage.json"
    ln -s "$PWD/$LIBS_COVERAGE/coverage-final.json" "$TEMP_COVERAGE/integration-coverage.json"

    echo "Merging coverage reports..."
    npx nyc merge "$TEMP_COVERAGE" > "$COMBINED_COVERAGE/coverage.json"
    echo "Combined coverage report generated at $COMBINED_COVERAGE/coverage.json"
else
    echo "No coverage reports found to merge."
fi
