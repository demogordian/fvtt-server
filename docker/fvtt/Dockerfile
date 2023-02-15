FROM node:16-alpine

ARG SCRIPT_UID
ARG SCRIPT_GID
COPY entrypoint.sh /entrypoint.sh
RUN deluser node && \
    rm -rf /home/node && \
    mkdir -p /opt /var/lib/fvtt && \
    ln -s /usr/local/fvtt/current /opt/fvtt && \
    addgroup -g $SCRIPT_GID fvtt && \
    adduser -D -u $SCRIPT_UID -G fvtt fvtt && \
    chown fvtt /var/lib/fvtt && \
    chgrp fvtt /var/lib/fvtt && \
    chmod +x /entrypoint.sh

VOLUME /usr/local/fvtt
VOLUME /var/lib/fvtt
EXPOSE 30000


CMD /entrypoint.sh
