#!/data/data/com.termux/files/usr/bin/bash

termux-wake-lock
ulimit -n 100000

while true; do
  pkill -f xray
  pkill -f cloudflared
  pkill -f python

  sleep 2

  cd ~/server

  python panel.py &

  sleep 3

  cloudflared tunnel run anugerah-tunnel --protocol http2 --no-autoupdate

  sleep 2
done
