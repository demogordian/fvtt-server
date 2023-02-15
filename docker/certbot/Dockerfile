FROM certbot/certbot:latest

ARG SCRIPT_UID
ARG SCRIPT_GID
RUN addgroup -g ${SCRIPT_GID} fvtt && \
    adduser -D -u ${SCRIPT_UID} -G fvtt fvtt
USER fvtt
