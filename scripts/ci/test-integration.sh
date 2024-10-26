#!/bin/bash
set -e

echo "Running integration tests..."
pnpm test:integration
echo "Integration tests completed."
