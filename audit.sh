#!/bin/bash
## This script performs a basic security audit of a Linux system

LOGFILE="audit_report_$(date +%F_%H-%M-%S).txt"
exec > >(tee -a "$LOGFILE") 2>&1

echo "===== LINUX SECURITY AUDIT ====="
echo "Run on: $(date)"
##sleep 2
##Checking for root users

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

score=0
total=0

pass() {
    score=$((score+1))
    total=$((total+1))
    echo -e "  ${GREEN}[PASS]${NC} $1"
}

warn() {
    total=$((total+1))
    echo -e "  ${YELLOW}[WARN]${NC} $1"
}

fail() {
    total=$((total+1))
    echo -e "  ${RED}[FAIL]${NC} $1"
}


echo ""
echo "[1] Checking for users with UID 0 (root privileges)..."
root_users=$(awk -F: '$3 == 0 {print $1}' /etc/passwd)

if [[ "$root_users" == "root" ]]; then
    pass "Only root has UID 0"
else
    fail "Unexpected UID 0 accounts found: $root_users"
fi
##sleep 2

##Checking for ssh misconfigs

echo ""
echo "[2] Checking SSH configuration..."
##sleep 2

if grep -q "^PermitRootLogin yes" /etc/ssh/sshd_config 2>/dev/null; then
    fail " Root login via SSH is permitted"
else
    pass " Root login is restricted or not explicitly enabled"
fi
##sleep 1.5

if grep -q "^PasswordAuthentication yes" /etc/ssh/sshd_config 2>/dev/null; then
    fail " Password authentication is enabled (key-based login is safer)"
else
    pass " Password authentication is disabled or not explicitly enabled"
fi
##sleep 2

##checking for world-executable files

echo ""
echo "[3] Checking for world-writable files in /etc..."
##sleep 2

world_writable=$(find /etc -xdev -type f -perm -0002 2>/dev/null)

if [[ -z "$world_writable" ]]; then
    pass " No world-writable files found in /etc"
else
    fail " WARNING: World-writable files found:"
    for f in $world_writable; do
        echo "    - $f"
    done
fi
##sleep 2

##checking for admin privileges 

echo ""
echo "[4] Checking users with sudo privileges..."
##sleep 2

sudo_users=$(getent group sudo | cut -d: -f4)

if [[ -z "$sudo_users" ]]; then
    warn " No users found in the sudo group"
else
    pass " Users with sudo access: $sudo_users"
fi
##sleep 2

##checking for failed logging attempts

echo ""
echo "[5] Checking recent failed login attempts..."

failed_logins=$(grep "Failed password" /var/log/auth.log 2>/dev/null | tail -5)

if [[ -z "$failed_logins" ]]; then
    pass " No recent failed login attempts found"
else
    warn " Recent failed login attempts:"
    echo "$failed_logins"
fi

echo ""
echo -e "${BOLD}${MAGENTA}===== SECURITY SCORE: $score/$total =====${NC}"
