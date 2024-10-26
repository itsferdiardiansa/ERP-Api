#!/bin/bash
set -e

echo "Running TypeScript type checks..."
pnpm type-check
echo "TypeScript type checks completed."
