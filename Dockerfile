FROM alpine:3.2
MAINTAINER Moritz Friedrich <moritz@matchory.com>

RUN apk add --update openssh-client && rm -rf /var/cache/apk/*

CMD rm -rf /root/.ssh && \
    mkdir /root/.ssh && \
    cp -R /root/ssh/* /root/.ssh/ && \
    chmod -R 600 /root/.ssh/* && \
    ssh \
    $SSH_ARGS \
    -o StrictHostKeyChecking=no \
    -N $TUNNEL_HOST \
    -L *:$LOCAL_PORT:$REMOTE_HOST:$REMOTE_PORT && \
    while true; do sleep 30; done;

EXPOSE 1-65535
