#!/bin/bash
## This script performs a basic security audit of a Linux system

echo "===== LINUX SECURITY AUDIT ====="
echo "Run on: $(date)"
##sleep 2
##Checking for root users

echo ""
echo "[1] Checking for users with UID 0 (root privileges)..."
##sleep 2
awk -F: '$3 == 0 {print $1}' /etc/passwd
##sleep 2

##Checking for ssh misconfigs

echo ""
echo "[2] Checking SSH configuration..."
##sleep 2

if grep -q "^PermitRootLogin yes" /etc/ssh/sshd_config 2>/dev/null; then
    echo "  WARNING: Root login via SSH is permitted"
else
    echo "  OK: Root login is restricted or not explicitly enabled"
fi
##sleep 1.5

if grep -q "^PasswordAuthentication yes" /etc/ssh/sshd_config 2>/dev/null; then
    echo "  WARNING: Password authentication is enabled (key-based login is safer)"
else
    echo "  OK: Password authentication is disabled or not explicitly enabled"
fi
##sleep 2

##checking for world-executable files

echo ""
echo "[3] Checking for world-writable files in /etc..."
##sleep 2

world_writable=$(find /etc -xdev -type f -perm -0002 2>/dev/null)

if [[ -z "$world_writable" ]]; then
    echo "  OK: No world-writable files found in /etc"
else
    echo "  WARNING: World-writable files found:"
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
    echo "  No users found in the sudo group"
else
    echo "  Users with sudo access: $sudo_users"
fi
##sleep 2

