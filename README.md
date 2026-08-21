# Linux Security Audit Tool
#

A Bash script that performs a quick security audit of a Linux system, checking for common misconfigurations and generating a timestamped, color-coded report.

## Features
- Detects unauthorized accounts with UID 0 (root privileges)
- Audits SSH configuration (root login, password authentication)
- Finds world-writable files in /etc
- Lists users with sudo privileges
- Checks recent failed login attempts
- Color-coded PASS/WARN/FAIL output with a final security score
- Saves every run to a timestamped log file

## Usage
```bash
chmod +x audit.sh
./audit.sh
```

Some checks (like reading /var/log/auth.log) may require running with sudo:
```bash
sudo ./audit.sh
```

## Sample Output
===== LINUX SECURITY AUDIT =====
Run on: Friday 21 August 2026 10:18:57 AM IST

[1] Checking for users with UID 0 (root privileges)...
[PASS] Only root has UID 0

[2] Checking SSH configuration...
[PASS] Root login is restricted or not explicitly enabled
[PASS] Password authentication is disabled or not explicitly enabled

===== SECURITY SCORE: 5/5 =====


## Author
Yash G Shetty
