FROM alpine:3.2
MAINTAINER Moritz Friedrich <moritz@matchory.com>

RUN apk add --update openssh-client && rm -rf /var/cache/apk/*

CMD rm -rf /root/.ssh && \
    mkdir /root/.ssh && \
    cp -R /root/ssh/* /root/.ssh/ && \
    chmod -R 600 /root/.ssh/* && \
    echo "Establishing tunnel from $(hostname):${LOCAL_PORT} via ${TUNNEL_HOST} to ${REMOTE_HOST}:${REMOTE_PORT}" && \
    ssh \
    ${SSH_ARGS} \
    -o TcpKeepAlive=yes \
    -o StrictHostKeyChecking=no \
    -o ExitOnForwardFailure=yes \
    -o "ConnectTimeout=${CONNECTION_TIMEOUT:-3}" \
    -o "ConnectionAttempts=${CONNECTION_ATTEMPTS:-3}" \
    -o "ServerAliveInterval=${SERVER_ALIVE_INTERVAL:-30}" \
    -N "${TUNNEL_HOST}" \
    -L "*:${LOCAL_PORT}:${REMOTE_HOST}:${REMOTE_PORT}" && \
    while true; do sleep 30; done;

EXPOSE 1-65535
