# =================
# Download
# =================
FROM debian:trixie-slim AS download

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget unzip ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/depot-downloader \
    && wget -qO /opt/depot-downloader/DepotDownloader-linux-x64.zip \
    https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_3.4.0/DepotDownloader-linux-x64.zip \
    && unzip /opt/depot-downloader/DepotDownloader-linux-x64.zip -d /opt/depot-downloader

RUN /opt/depot-downloader/DepotDownloader -os linux -validate -dir /download -app 232330 -depot 232330 -manifest 8012076251401872268
RUN /opt/depot-downloader/DepotDownloader -os linux -validate -dir /download -app 232330 -depot 232336 -manifest 4365247718224700910
RUN /opt/depot-downloader/DepotDownloader -os linux -validate -dir /download -app 90 -depot 1006 -manifest 6403079453713498174 

# ===================
# Prune
# ===================
FROM download AS prune

COPY --from=download --chown=1000:1000 ["/download", "/app"]
COPY --from=download --chown=1000:1000 ["/download/linux64/steamclient.so", "/app/bin/linux64/steamclient.so"]
COPY --chown=1000:1000 ["./patch/base/", "/app"]

RUN rm -rf /app/cstrike/maps/*

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

COPY --from=prune --chown=1000:1000 ["/app/linux64/steamclient.so", "/home/gamesrv/.steam/sdk64/steamclient.so"]
COPY --from=prune --chown=1000:1000 ["/app", "/app"]

WORKDIR /app
USER 1000:1000

# ===================
# 分支：对决
# ===================
FROM base AS versus

COPY --chown=1000:1000 ["./patch/versus/", "/app"]

CMD ["bash", "/app/start-server.sh", "+map", "aim_map_esl"]
