#!/bin/bash
# monitor-server.sh
# Purpose: Remotely monitors server performance via SSH.
# Usage: ./monitor-server.sh <user@ip>
# Author: [Your Student ID]

SERVER=$1

if [ -z "$SERVER" ]; then
    echo "Usage: $0 <user@ip>"
    exit 1
fi

echo "Connecting to $SERVER..."

ssh -T $SERVER << 'EOF'
    echo "========================================"
    echo "Remote Server Monitor: $(hostname)"
    echo "Date: $(date)"
    echo "========================================"
    
    echo "1. System Load (1, 5, 15 min):"
    uptime | awk -F'load average:' '{ print $2 }'
    echo ""

    echo "2. Memory Usage:"
    free -h | grep Mem
    echo ""

    echo "3. Disk Usage (Root):"
    df -h / | awk 'NR==2 {print $5 " Used (" $4 " Free)"}'
    echo ""

    echo "4. Active SSH Connections:"
    who | grep pts
EOF
