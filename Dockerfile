FROM buildpack-deps AS server-package
ARG TERRARIA_SERVER_VERSION
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
