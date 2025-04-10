#!/bin/bash

# 检查必要的环境变量
if [ -z "$REMOTE_PORT" ] || [ -z "$LOCAL_HOST" ] || [ -z "$LOCAL_PORT" ] || [ -z "$REMOTE_USER" ]; then
    echo "错误: 必要的环境变量未设置"
    exit 1
fi

# 确定要连接的服务器IP
if [ -n "$IP_SERVER" ]; then
    echo "使用动态IP服务: $IP_SERVER"
    SERVER_IP=$(curl -s "$IP_SERVER")
    echo "获取到IP: $SERVER_IP"
else
    SERVER_IP="$REMOTE_SERVER"
    echo "使用配置的服务器: $SERVER_IP"
fi

# 检查服务器是否可连接
echo "检查服务器连接性..."
nc -z -w 5 "$SERVER_IP" 22 >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "错误: 无法连接到服务器 $SERVER_IP 的SSH端口 (22)"
    exit 1
fi

# 建立SSH隧道
echo "建立隧道: ${REMOTE_USER}@${SERVER_IP}:${REMOTE_PORT} -> ${LOCAL_HOST}:${LOCAL_PORT}"
exec ssh -R "${REMOTE_PORT}:${LOCAL_HOST}:${LOCAL_PORT}" \
    -N \
    -o "ServerAliveInterval=60" \
    -o "ExitOnForwardFailure=yes" \
    "${REMOTE_USER}@${SERVER_IP}"
