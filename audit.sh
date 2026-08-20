#!/bin/bash
## This script performs a basic security audit of a Linux system

echo "===== LINUX SECURITY AUDIT ====="
echo "Run on: $(date)"
echo ""
echo "[1] Checking for users with UID 0 (root privileges)..."
awk -F: '$3 == 0 {print $1}' /etc/passwd
