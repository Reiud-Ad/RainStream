#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# libtorch must be the same build the binary was linked against.
# Three cases, in order:
#   1. bob/Docker package - the .so files are shipped right next to the binary.
#   2. A system-wide /opt/libtorch (what the Docker build stage uses).
#   3. Running straight out of the repo on a dev machine, where RLBot5 keeps its copy.
# Getting this wrong makes the process die immediately with no output at all.
if compgen -G "$SCRIPT_DIR/libtorch_cpu.so" > /dev/null || compgen -G "$SCRIPT_DIR/libc10.so" > /dev/null; then
	TORCH_LIB="$SCRIPT_DIR"
elif [ -d "/opt/libtorch/lib" ]; then
	TORCH_LIB="/opt/libtorch/lib"
else
	TORCH_LIB="${XDG_DATA_HOME:-$HOME/.local/share}/RLBot5/bots/torch-archive/torch/lib"
fi

export LD_LIBRARY_PATH="$TORCH_LIB:${LD_LIBRARY_PATH:-}"
# Wine uses PATH to locate DLLs (closest equivalent to Windows PATH)
export PATH="$TORCH_LIB:$PATH"

cd "$SCRIPT_DIR"
exec "$SCRIPT_DIR/GGLBot" "$@"
