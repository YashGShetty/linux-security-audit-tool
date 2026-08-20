#!/bin/bash
## This script performs a basic security audit of a Linux system

echo "===== LINUX SECURITY AUDIT ====="
echo "Run on: $(date)"

##Checking for root users

echo ""
echo "[1] Checking for users with UID 0 (root privileges)..."
awk -F: '$3 == 0 {print $1}' /etc/passwd

##Checking for ssh misconfigs

echo ""
echo "[2] Checking SSH configuration..."

if grep -q "^PermitRootLogin yes" /etc/ssh/sshd_config 2>/dev/null; then
    echo "  WARNING: Root login via SSH is permitted"
else
    echo "  OK: Root login is restricted or not explicitly enabled"
fi

if grep -q "^PasswordAuthentication yes" /etc/ssh/sshd_config 2>/dev/null; then
    echo "  WARNING: Password authentication is enabled (key-based login is safer)"
else
    echo "  OK: Password authentication is disabled or not explicitly enabled"
fi
