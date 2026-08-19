#!/bin/bash
set -euo pipefail

cd /app && exec /app/srcds_run_64 \
    -game cstrike \
    -insecure \
    -ip 0.0.0.0 \
    -port 27015 \
    +maxplayers 16 \
    "$@"
