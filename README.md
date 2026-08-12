# Counter-Strike: Source Server

## 1. 简述

CS 起源插件服务器

**特点：**

- 添加 metamod / sourcemod 插件平台

**可用版本：**

| 游戏模式 | 镜像 tag        |
| -------- | --------------- |
| 对决     | `versus-latest` |

## 2. 资源占用信息

### 2.1. 端口

| 端口号 | 协议 | 说明         |
| ------ | ---- | ------------ |
| 27015  | UDP  | 游戏联机端口 |
| 27015  | TCP  | RCON 端口    |

## 3. 构建与运行

### 3.1. 构建并运行（Docker）

```bash
docker build --target versus -t counter-strike-source:versus-temp . && \
    docker run --rm -it \
        -p 27015:27015/udp \
        -p 27015:27015/tcp \
        counter-strike-source:versus-temp
```

### 3.2. 运行服务器（Podman）

```bash
IMAGE=ghcr.io/hm-gamesrv/counter-strike-source:versus-latest

if ! podman pull "$IMAGE"; then
    exit 1
fi

podman run --rm -it \
    --name counter-strike-source-versus \
    --userns keep-id \
    --network pasta \
    -p 27015:27015/udp \
    -p 27015:27015/tcp \
    "$IMAGE"
```
