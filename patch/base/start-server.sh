#!/bin/bash
set -euo pipefail

cd /app

export LD_LIBRARY_PATH="/app/bin:/app/bin/linux64"

# 后台启动 srcds 以便转发容器停止信号。
# 不能直接 exec 成 PID 1：SIGTERM 默认动作会被内核忽略，docker stop 会卡到超时。
pid=0
trap 'if [ "$pid" -gt 0 ]; then kill -TERM "$pid"; fi' TERM INT

/app/srcds_linux64 \
    -game cstrike \
    -insecure \
    -ip 0.0.0.0 \
    -port 27015 \
    +maxplayers 16 \
    "$@" &

pid=$!

# 等 srcds 退出，退出码原样返回给容器
wait "$pid"
