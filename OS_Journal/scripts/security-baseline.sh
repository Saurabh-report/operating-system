#!/bin/bash
# security-baseline.sh
# Purpose: Verifies key security configurations on the Ubuntu Server.
# Author: [Your Student ID]

echo "========================================"
echo "Security Baseline Verification"
echo "========================================"

# 1. Check UFW Status
echo "[*] Checking Firewall Status..."
if sudo ufw status | grep -q "Status: active"; then
    echo "    [PASS] UFW is active."
else
    echo "    [FAIL] UFW is inactive!"
fi

# 2. Check SSH Root Login
echo "[*] Checking SSH Root Login..."
if grep -q "^PermitRootLogin no" /etc/ssh/sshd_config; then
    echo "    [PASS] Root login disabled in config."
else
    echo "    [FAIL] Root login might be enabled (or default)."
fi

# 3. Check for Null Passwords
echo "[*] Checking for empty passwords..."
if awk -F: '($2 == "") {print $1}' /etc/shadow | grep -q .; then
    echo "    [FAIL] Users with empty passwords found!"
else
    echo "    [PASS] No empty passwords found."
fi

# 4. Check AppArmor Status
echo "[*] Checking AppArmor..."
if aa-status --enabled 2>/dev/null; then
    echo "    [PASS] AppArmor is enabled."
else
    echo "    [FAIL] AppArmor is NOT enabled."
fi

echo "========================================"
echo "Verification Complete."
