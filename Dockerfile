#syntax docker/dockerfile:1.6
FROM alpine:3.19
ARG KEY_VOLUME=/root/ssh
ENV KEY_VOLUME=${KEY_VOLUME}

RUN <<eot
set -eux
apk add --update --no-cache openssh-client
rm -rf /var/cache/apk/*
mkdir -p "${KEY_VOLUME}"
chmod 0700 "${KEY_VOLUME}"
eot

COPY --link --chmod=700 ./entrypoint.sh /entrypoint.sh

EXPOSE 1-65535
VOLUME "${KEY_VOLUME}"
ENTRYPOINT ["/entrypoint.sh"]
