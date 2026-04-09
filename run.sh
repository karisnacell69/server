#!/data/data/com.termux/files/usr/bin/bash

termux-wake-lock
ulimit -n 100000

# ===== AUTO DETECT TUNNEL =====
TUNNEL_ID=$(cloudflared tunnel list 2>/dev/null | awk 'NR==2 {print $1}')

if [ -z "$TUNNEL_ID" ]; then
  echo "❌ Tunnel not found!"
  echo "👉 Jalankan: cloudflared tunnel create anugerah-tunnel"
  exit 1
fi

echo "✅ Tunnel detected: $TUNNEL_ID"

while true; do
  pkill -f xray
  pkill -f cloudflared
  pkill -f python

  sleep 2

  cd ~/server

  python panel.py &

  sleep 3

  echo "🌐 Running Cloudflare Tunnel..."

  cloudflared tunnel run $TUNNEL_ID

  echo "⚠️ Tunnel crash, retry..."

  sleep 2
done
