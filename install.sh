#!/data/data/com.termux/files/usr/bin/bash

# ===== CONFIG =====
PASSWORD="@Kosay389%"

# ===== COLOR =====
GREEN='\033[1;32m'
PINK='\033[1;35m'
CYAN='\033[1;36m'
RED='\033[1;31m'
NC='\033[0m'

clear

# ===== SOUND =====
beep() { printf '\a'; }

# ===== PASSWORD CHECK =====
echo -e "${PINK}🔐 ENTER ACCESS PASSWORD:${NC}"
read -s input

if [ "$input" != "$PASSWORD" ]; then
  echo -e "${RED}❌ WRONG PASSWORD! ACCESS DENIED${NC}"
  beep
  sleep 2
  exit
fi

echo -e "${GREEN}✅ ACCESS GRANTED${NC}"
beep
sleep 1

clear

# ===== MATRIX EFFECT =====
matrix() {
  echo -e "\033[1;32m"
  cols=$(tput cols)
  while true; do
    line=""
    for ((i=0; i<cols; i++)); do
      rand=$((RANDOM % 2))
      [ $rand -eq 0 ] && line="${line}0" || line="${line}1"
    done
    echo -e "$line"
    sleep 0.02
  done
}

# ===== HACKER TEXT =====
hacker_text() {
  echo -e "${CYAN}"
  echo "Initializing secure system..."
  sleep 0.5
  echo "Bypassing firewall..."
  sleep 0.5
  echo "Decrypting packets..."
  sleep 0.5
  echo "Injecting payload..."
  sleep 0.5
  echo "Access granted ✔"
  sleep 0.5
  echo -e "${NC}"
}

# ===== HEADER =====
echo -e "${PINK}"
echo "╔══════════════════════════════════════╗"
echo "║   💀 FLOREZA CYBER INSTALLER 💀     ║"
echo "║     LOCKED DEPLOY SYSTEM            ║"
echo "╚══════════════════════════════════════╝"
echo -e "${NC}"

beep
sleep 1

# ===== MATRIX =====
echo -e "${GREEN}ENTERING MATRIX...${NC}"
(matrix &) 
pid=$!

sleep 3

kill $pid
clear

# ===== HACKER TEXT =====
hacker_text

# ===== PROGRESS =====
loading() {
  for i in {1..30}; do
    echo -ne "${GREEN}█${NC}"
    sleep 0.03
  done
  echo ""
  beep
}

step() {
  echo -e "${PINK}➤ $1...${NC}"
  loading
}

# ===== INSTALL =====
step "Updating system"
pkg update -y > /dev/null 2>&1

step "Installing core packages"
pkg install -y python xray cloudflared git curl > /dev/null 2>&1

step "Installing Python modules"
pip install flask > /dev/null 2>&1

step "Cloning repository"
cd ~
rm -rf server
git clone https://github.com/karisnacell69/server.git > /dev/null 2>&1

step "Configuring environment"
cd server
chmod +x run.sh
[ ! -f users.json ] && echo "[]" > users.json

step "Optimizing system"
ulimit -n 100000

# ===== FINAL =====
echo -e "${GREEN}"
echo "╔══════════════════════════════════════╗"
echo "║        ✅ SYSTEM DEPLOYED            ║"
echo "║     Launching server now...          ║"
echo "╚══════════════════════════════════════╝"
echo -e "${NC}"

beep
sleep 2

# ===== RUN =====
./run.sh
