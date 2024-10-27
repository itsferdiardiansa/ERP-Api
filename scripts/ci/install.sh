#!/bin/bash
set -e

echo "Installing dependencies..."
pnpm install --frozen-lockfile || { echo "Installation failed. Exiting."; exit 1; }
echo "Dependencies installed successfully."
