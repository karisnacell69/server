#!/data/data/com.termux/files/usr/bin/bash

# ===== CONFIG =====
PASSWORD="@Kosay389%"

# ===== COLOR =====
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PINK='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'

clear

# ===== SOUND =====
beep() { printf '\a'; }

# ===== PASSWORD =====
if [ -n "$1" ]; then
  input="$1"
else
  echo -e "${PINK}🔐 ENTER ACCESS PASSWORD:${NC}"
  read input
fi

if [ "$input" != "$PASSWORD" ]; then
  echo -e "${RED}❌ WRONG PASSWORD! ACCESS DENIED${NC}"
  beep
  sleep 2
  exit 1
fi

echo -e "${GREEN}✅ ACCESS GRANTED${NC}"
beep
sleep 1
clear

# ===== COLORFUL PROGRESS BAR =====
progress_bar() {
  width=40
  for ((i=0; i<=width; i++)); do
    percent=$(( i * 100 / width ))

    case $((i % 6)) in
      0) color=$RED ;;
      1) color=$GREEN ;;
      2) color=$YELLOW ;;
      3) color=$BLUE ;;
      4) color=$PINK ;;
      5) color=$CYAN ;;
    esac

    filled=$(printf "%${i}s" | tr ' ' '█')
    empty=$(printf "%$((width-i))s")

    printf "\r${color}[%-40s] %3d%%${NC}" "$filled$empty" "$percent"
    sleep 0.02
  done
  echo ""
  beep
}

step() {
  echo -e "${PINK}➤ $1${NC}"
  progress_bar
}

# ===== INSTALL =====
step "Updating system"
pkg update -y > /dev/null 2>&1

step "Installing packages"
pkg install -y python xray cloudflared git curl > /dev/null 2>&1

step "Installing python module"
pip install flask > /dev/null 2>&1

step "Cloning repository"
cd ~
rm -rf server
git clone https://github.com/karisnacell69/server.git > /dev/null 2>&1

step "Configuring server"
cd server
chmod +x run.sh
[ ! -f users.json ] && echo "[]" > users.json

step "Optimizing system"
ulimit -n 100000

# ===== FINAL =====
echo -e "${GREEN}"
echo "======================================"
echo "     ✅ INSTALL SUCCESS & RUNNING      "
echo "======================================"
echo -e "${NC}"

sleep 2

# ===== RUN =====
./run.sh
