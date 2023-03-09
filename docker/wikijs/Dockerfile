FROM ghcr.io/requarks/wiki:2

ARG SCRIPT_UID
ARG SCRIPT_GID
USER root
RUN addgroup -g $SCRIPT_GID fvtt && \
    adduser -D -u $SCRIPT_UID -G fvtt fvtt
#    deluser node && \
#    rm -rf /home/node && \

VOLUME /var/lib/wikijs
EXPOSE 3000

USER fvtt

