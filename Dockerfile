FROM buildpack-deps AS server-package
ARG TERRARIA_SERVER_VERSION
#RUN wget https://www.terraria.org/api/download/pc-dedicated-server/terraria-server-${TERRARIA_SERVER_VERSION}.zip -cO terraria_server.zip
ADD https://www.terraria.org/api/download/pc-dedicated-server/terraria-server-${TERRARIA_SERVER_VERSION}.zip terraria_server.zip
RUN unzip terraria_server.zip -d /tmp/terraria
WORKDIR /opt/terraria
RUN cp -r /tmp/terraria/${TERRARIA_SERVER_VERSION}/Linux/* . && \
    rm System* Mono* monoconfig mscorlib.dll

FROM mono:6-slim
RUN apt-get update && apt-get install -y libmono-cil-dev && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*
WORKDIR /opt/terraria
COPY --from=server-package /opt/terraria .
ADD server.sh .
ENTRYPOINT [ "./server.sh" ]
# CMD ["${TERRARIA_MAX_PLAYERS:+-players}", "${TERRARIA_MAX_PLAYERS}", "${TERRARIA_PASSWORD:+-pass}", "${TERRARIA_PASSWORD}", "${TERRARIA_MOTD:+-motd}", "${TERRARIA_MOTD}", "${TERRARIA_WORLD_PATH:+-world}", "${TERRARIA_WORLD_PATH}", "${TERRARIA_AUTOCREATE:+-autocreate}", "${TERRARIA_AUTOCREATE}", "${TERRARIA_WORLD_NAME:+-worldname}", "${TERRARIA_WORLD_NAME}", "${TERRARIA_SEED:+-seed}", "${TERRARIA_SEED}"]
# '${TERRARIA_MAX_PLAYERS:+-players}' '${TERRARIA_MAX_PLAYERS}' '${TERRARIA_PASSWORD:+-pass}' '${TERRARIA_PASSWORD}' '${TERRARIA_MOTD:+-motd}' '${TERRARIA_MOTD}' '${TERRARIA_WORLD_PATH:+-world}' '${TERRARIA_WORLD_PATH}' '${TERRARIA_AUTOCREATE:+-autocreate}' '${TERRARIA_AUTOCREATE}' '${TERRARIA_WORLD_NAME:+-worldname}' '${TERRARIA_WORLD_NAME}' '${TERRARIA_SEED:+-seed}' '${TERRARIA_SEED}'
# CMD ["${TERRARIA_MAX_PLAYERS:+-players}"
#     "${TERRARIA_MAX_PLAYERS}",
#     "-pass",
#     "${TERRARIA_PASSWORD}",
#     "-motd",
#     "${TERRARIA_MOTD}",
#     "-world",
#     "${TERRARIA_WORLD_PATH}",
#     "-autocreate",
#     "${TERRARIA_AUTOCRATE}",
#     "-worldname",
#     "${TERRARIA_WORLD_NAME}",
#     "-seed",
#     "${TERRARIA_SEED}"
# ]