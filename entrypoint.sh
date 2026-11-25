#!/bin/sh
set -e
if [ -z "$UUID" ]; then echo "UUID env var is required" >&2; exit 1; fi
WS_PATH="${WS_PATH:-/tk-rail}"
PORT="${PORT:-8080}"
mkdir -p /usr/local/etc/xray
cat > /usr/local/etc/xray/config.json <<EOF
{
  "log": {"loglevel": "warning"},
  "inbounds": [{
    "port": $PORT,
    "protocol": "vless",
    "settings": {"clients": [{"id": "$UUID"}], "decryption": "none"},
    "streamSettings": {"network": "ws", "wsSettings": {"path": "$WS_PATH"}}
  }],
  "outbounds": [{"protocol": "freedom"}]
}
EOF
exec /usr/local/bin/xray run -c /usr/local/etc/xray/config.json
