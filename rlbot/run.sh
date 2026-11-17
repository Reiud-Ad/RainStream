#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# GGLBot is the Torch-free launcher: it locates 000-runtime/GGLBotCore and the
# shared RLBot torch-archive, then execs the core with the library path set.
cd "$SCRIPT_DIR"
exec "$SCRIPT_DIR/GGLBot" "$@"
