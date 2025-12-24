# Week 7: Security Audit and System Evaluation

## 1. Security Audit Report

I conducted a final security audit using **Lynis** and **Nmap**.

### Lynis Audit Results
*   **Initial Hardening Index**: 62
*   **Final Hardening Index**: 81

**Key Findings & Remediation:**
1.  **Finding**: SSH Root Login enabled. -> **Fixed** (Disabled in Phase 4).
2.  **Finding**: Firewall inactive. -> **Fixed** (Enabled UFW in Phase 4).
3.  **Finding**: Password aging not set. -> **Risk Accepted** (Lab environment).

### Network Security (Nmap)
Scanning from workstation: `nmap -p- 192.168.56.10`

**Result:**
```text
PORT   STATE SERVICE
22/tcp open  ssh
```
*Analysis*: Only Port 22 is open, which validates the firewall configuration.

## 2. Service Inventory

| Service | Status | Justification |
| :--- | :--- | :--- |
| `sshd` | Running | Required for remote administration. |
| `systemd-journald` | Running | Required for system logging. |
| `cron` | Running | Required for scheduled tasks (updates). |
| `snapd` | Stopped | Disabled to save resources (Optimisation). |

## 3. Final Reflection

### Critical Analysis
Configuring this headless Linux server demonstrated the trade-offs between **security** and **usability**. 
*   **Security**: Disabling password authentication makes the system very secure but requires careful key management.
*   **Usability**: The lack of a GUI forces efficient use of CLI tools (`grep`, `awk`, `systemctl`) which is faster for bulk tasks but has a steeper learning curve.

### Conclusion
The system successfully meets the requirements: it is secure (Score 81+), monitored (custom scripts), and optimised for its role.

---
[Return to Home](../README.md)
