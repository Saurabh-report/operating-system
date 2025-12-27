#!/bin/bash

# ==============================================================================
# Remote Server Monitoring Script
# Phase 5: Advanced Security and Monitoring
# 
# Description:
# This script is designed to run on the WORKSTATION. It connects to the 
# designated server IP via SSH and retrieves key performance metrics.
# ==============================================================================

# 1. Configuration Variables
SERVER_USER="admin_user"
SERVER_IP="192.168.56.10"
COMMAND="grep 'model name' /proc/cpuinfo | head -1"

echo "=============================================="
echo "   Connecting to Server: $SERVER_IP"
echo "   timestamp: $(date)"
echo "=============================================="

# 2. Check Reachability first (Ping check)
# -c 1 : send 1 packet
# -W 1 : wait max 1 second
if ping -c 1 -W 1 $SERVER_IP >/dev/null 2>&1; then
    echo "[STATUS] Server is ONLINE"
else
    echo "[STATUS] Server is OFFLINE or blocking Ping"
    exit 1
fi

echo ""
echo "--- 1. System Uptime & Load ---"
# 3. Retrieve Uptime
# Executing 'uptime' command remotely via SSH
ssh -o BatchMode=yes $SERVER_USER@$SERVER_IP "uptime"

echo ""
echo "--- 2. Memory Usage (MB) ---"
# 4. Retrieve RAM Statistics
# 'free -m' shows memory in Megabytes. We explicitly check 'Mem:' line.
ssh -o BatchMode=yes $SERVER_USER@$SERVER_IP "free -m"

echo ""
echo "--- 3. Disk Usage ---"
# 5. Retrieve Disk Statistics
# 'df -h' for human readable format. We filter for the root filesystem '/'.
ssh -o BatchMode=yes $SERVER_USER@$SERVER_IP "df -h | grep '/$'"

echo ""
echo "--- 4. Active Connections ---"
# 6. Check Active SSH Connections
# 'who' lists logged in users.
ssh -o BatchMode=yes $SERVER_USER@$SERVER_IP "who"

echo ""
echo "=============================================="
echo "   Monitoring Report Complete"
echo "=============================================="
