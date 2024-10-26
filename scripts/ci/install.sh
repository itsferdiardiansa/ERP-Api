#!/bin/bash
set -e

echo "Installing dependencies with pnpm..."
pnpm install --frozen-lockfile
echo "Dependencies installed."
