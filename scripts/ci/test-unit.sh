#!/bin/bash
set -e

echo "Running unit tests..."
pnpm test:unit
echo "Unit tests completed."
