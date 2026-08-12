#!/bin/bash

./srcds_run \
    -game cstrike \
    -insecure \
    -ip 0.0.0.0 \
    -port 27015 \
    +maxplayers 16 \
    "$@"
