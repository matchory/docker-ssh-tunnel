#!/bin/sh
set -eux

# Copy the SSH keys at runtime, so they can be injected as secrets
rm -rf "${HOME}/.ssh"
mkdir "${HOME}/.ssh"
cp -R "${KEY_VOLUME}"/* "${HOME}/.ssh/"
chmod -R 600 "${HOME}"/.ssh/*

echo "Establishing tunnel from $(hostname):${LOCAL_PORT} via ${TUNNEL_HOST} to ${REMOTE_HOST}:${REMOTE_PORT}"

# shellcheck disable=SC2086
exec ssh ${SSH_ARGS} \
  -o TcpKeepAlive=yes \
  -o StrictHostKeyChecking=no \
  -o ExitOnForwardFailure=yes \
  -o "ConnectTimeout=${CONNECTION_TIMEOUT:-3}" \
  -o "ConnectionAttempts=${CONNECTION_ATTEMPTS:-3}" \
  -o "ServerAliveInterval=${SERVER_ALIVE_INTERVAL:-30}" \
  -N "${TUNNEL_HOST}" \
  -L "*:${LOCAL_PORT}:${REMOTE_HOST}:${REMOTE_PORT}"
