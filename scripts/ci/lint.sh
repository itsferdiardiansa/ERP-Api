#!/bin/bash
set -e

echo "Running lint checks..."
eslint --config eslint.config.js "apps/*/src/**/*.{js,ts}" "libs/*/src/**/*.{js,ts}" --ignore-pattern '**/*.test.*' --ignore-pattern '**/*.spec.*' || { echo "Linting failed. Exiting."; exit 1; }
echo "Lint checks completed successfully."
