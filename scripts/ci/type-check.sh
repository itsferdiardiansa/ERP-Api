#!/bin/bash
set -e

echo "Running TypeScript type checks..."
tsc --noEmit || { echo "Type checks failed. Exiting."; exit 1; }
echo "Type checks completed successfully."
