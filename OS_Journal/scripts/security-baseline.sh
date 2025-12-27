#!/bin/bash

# ==============================================================================
# Security Baseline Verification Script
# Phase 5: Advanced Security and Monitoring
# 
# Description:
# This script runs on the server (remote execution supported) to verify that
# essential security controls from Phase 4 and Phase 5 are active and correctly
# configured.
# ==============================================================================

# 1. Print Header for cleaner output
echo "=============================================="
echo "   Security Baseline Verification Report"
echo "   $(date)"
echo "=============================================="

# 2. Function to check command execution status and print pass/fail
# Arguments: $1 = Test Name, $2 = Status Code (0=Success, otherwise Fail)
check_status() {
    if [ $2 -eq 0 ]; then
        echo "[MATCH] $1: Active/Verified"
    else
        echo "[FAIL!] $1: Inactive or Misconfigured"
    fi
}

echo ""
echo "--- 1. Firewall (UFW) Status ---"
# 3. Check if UFW is active. Quiet mode used for status check.
ufw status | grep -q "Status: active"
check_status "UFW Firewall Active" $?

# 4. Check if Default Deny Incoming policy is set
# We grep for 'deny (incoming)' in the verbose status output
if sudo ufw status verbose | grep -q "Default: deny (incoming)"; then
    echo "[MATCH] Default Deny Policy: Enforced"
else
    echo "[FAIL!] Default Deny Policy: Not Found"
fi

echo ""
echo "--- 2. SSH Hardening (sshd_config) ---"
# 5. Check if Password Authentication is Disabled
# Greps for the specific configuration line in /etc/ssh/sshd_config
# We look for "PasswordAuthentication no" that is NOT commented out (^)
grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config
check_status "Password Auth Disabled" $?

# 6. Check if Root Login is Disabled
grep -q "^PermitRootLogin no" /etc/ssh/sshd_config
check_status "Root Login Disabled" $?

echo ""
echo "--- 3. Access Control (AppArmor) ---"
# 7. Check if AppArmor module is loaded and status
if sudo aa-status --enabled 2>/dev/null; then
    echo "[MATCH] AppArmor: Enabled"
    # Show count of enforced profiles for detail
    ENFORCED_COUNT=$(sudo aa-status | grep "profiles in enforce mode" | awk '{print $1}')
    echo "        Enforced Profiles: $ENFORCED_COUNT"
else
    echo "[FAIL!] AppArmor: Disabled"
fi

echo ""
echo "--- 4. Intrusion Detection (Fail2Ban) ---"
# 8. Check if Fail2Ban service is running
systemctl is-active --quiet fail2ban
check_status "Fail2Ban Service" $?

# 9. Verify the SSHD Jail is active
if sudo fail2ban-client status sshd >/dev/null 2>&1; then
    echo "[MATCH] SSHD Jail: Active"
else
    echo "[FAIL!] SSHD Jail: Inactive"
fi

echo ""
echo "=============================================="
echo "   Verification Complete"
echo "=============================================="
