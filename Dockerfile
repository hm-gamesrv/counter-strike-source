# =================
# 资源下载
# =================
FROM cm2network/steamcmd AS downloader

RUN /home/steam/steamcmd/steamcmd.sh \
    +@sSteamCmdForcePlatformType linux \
    +login anonymous \
    +app_update 232330 validate \
    +quit

# ===================
# 基座镜像
# ===================
FROM debian:trixie-slim AS base

EXPOSE 27015/udp 27015/tcp

ENV TZ=Asia/Shanghai

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1000 gamesrv \
    && useradd -u 1000 -g gamesrv -m -s /bin/bash gamesrv
RUN mkdir -p /app && chown 1000:1000 /app

COPY --from=downloader --chown=1000:1000 ["/home/steam/Steam/steamapps/common/Counter-Strike Source Dedicated Server", "/app"]
COPY --from=downloader --chown=1000:1000 ["/home/steam/steamcmd/linux64/steamclient.so", "/home/gamesrv/.steam/sdk64/steamclient.so"]
COPY --from=downloader --chown=1000:1000 ["/home/steam/steamcmd/linux64/steamclient.so", "/app/bin/linux64/steamclient.so"]
RUN rm -rf /app/cstrike/maps/*
COPY --chown=1000:1000 ["./patch/base/", "/app"]

WORKDIR /app
USER 1000:1000

# ===================
# 分支：对决
# ===================
FROM base AS versus

COPY --chown=1000:1000 ["./patch/versus/", "/app"]

CMD ["bash", "/app/start-server.sh", "+map", "aim_map_esl"]
