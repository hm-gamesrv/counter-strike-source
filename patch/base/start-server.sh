#!/bin/bash
set -euo pipefail

cd /app

export LD_LIBRARY_PATH="/app/bin:/app/bin/linux64"

/app/srcds_linux64 \
    -game cstrike \
    -insecure \
    -nomaster \
    -ip 0.0.0.0 \
    -port 27015 \
    +sv_lan 1 \
    +maxplayers 16 \
    "$@" <&0 &
