#!/data/data/com.termux/files/usr/bin/bash

clear
echo "🚀 INSTALL VLESS PANEL by KARISNA CELL..."

sleep 1

# Update system
pkg update -y

# Install dependencies
pkg install -y python xray cloudflared git curl

# Install python lib
pip install flask

# Clone repo
cd ~
rm -rf server
git clone https://github.com/karisnacell69/server.git

cd server

# Permission
chmod +x run.sh

# Create DB
[ ! -f users.json ] && echo "[]" > users.json

echo ""
echo "✅ INSTALL SUCCESS!"
echo "🌐 Starting server..."
echo ""

sleep 2

# Run server
./run.sh
