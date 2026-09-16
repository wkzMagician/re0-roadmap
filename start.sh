#!/bin/sh
set -eu
cd -- "$(dirname -- "$0")"

if ! command -v node >/dev/null 2>&1 || ! command -v npm >/dev/null 2>&1; then
  echo "Node.js and npm are required. Install a supported Node.js LTS version:" >&2
  echo "https://nodejs.org/en/download" >&2
  echo "Choose the current LTS version for your OS and include npm." >&2
  echo "Requires Node.js 20.19+ (20.x) or 22.12+." >&2
  echo "After installation, open a new terminal and run: sh start.sh" >&2
  exit 1
fi

if [ ! -d node_modules ]; then
  echo "Installing dependencies..."
  npm ci
fi

echo "Starting Readmap. Press Ctrl+C to stop."
exec npm run dev -- --host 127.0.0.1 --port 5173 --strictPort --open
