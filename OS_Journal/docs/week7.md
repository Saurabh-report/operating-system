# Week 7: Security Audit and System Evaluation

## 1. Security Audit Report

### Executive Summary
This report summarizes the security posture of the Linux server environment following the implementation of Hardening Phases 1-6. The audit was conducted using industry-standard tools (**Lynis**, **NMap**) to verify compliance with the security baseline.

### 1.1 Vulnerability Assessment (Lynis)

**Audit Command**: `sudo lynis audit system`

I performed an initial audit immediately after installation (Week 3) and a final audit after applying security controls (Week 5).

| Metric | Initial Score (Week 3) | Final Score (Week 7) | Improvement |
| :--- | :--- | :--- | :--- |
| **Hardening Index** | 62 / 100 | **81 / 100** | +19 Points |
| **Tests Performed** | 245 | 245 | N/A |

#### Hardening Comparison Chart
```mermaid
chart
    type: bar
    title: "Lynis Hardening Index Improvement"
    x-axis: "Audit Phase"
    y-axis: "Hardening Index Score"
    series:
        - name: "Score"
          data: [62, 81]
    categories: ["Initial (Default)", "Final (Hardened)"]
```

#### Remediation Actions Taken
The following high-priority findings were remediated during this course:

| Lynis Finding | Risk Level | Remediation Action Taken |
| :--- | :--- | :--- |
| `SSH-ROOT-LOGIN` | High | Disabled `PermitRootLogin` in `/etc/ssh/sshd_config` |
| `FIREWALL-NOT-ACTIVE` | High | Enabled `ufw` and set default deny policy |
| `PKG-UPDATE` | Medium | Configured `unattended-upgrades` for automatic patching |

**[INSERT SCREENSHOT HERE: Capture final Lynis 'Hardening Index' score output]**

### 1.2 Network Security Assessment (Nmap)

**Audit Command**: `nmap -p- 192.168.56.10` (Run from Workstation)
*Rationale*: Scans all 65,535 ports to ensure no unauthorized services are exposed.

**Results Analysis:**
| Port | State | Service | Status Justification |
| :--- | :--- | :--- | :--- |
| **22/tcp** | Open | ssh | **Authorized**: Required for remote administration. |
| **All Other** | Filtered | N/A | **Secure**: Blocked by UFW Default Deny policy. |

**[INSERT SCREENSHOT HERE: Capture Nmap output showing only Port 22 open]**

### 1.3 Access Control Verification

I manually verified the critical access control mechanisms.

*   [x] **SSH Keys**: Password authentication failed when tested; Key-based auth succeeded.
*   [x] **Sudo Access**: `admin_user` required password for `sudo`; Root account login failed.
*   [x] **AppArmor**: Verified status is `active` with 44 profiles enforced.

## 2. Service Inventory

The following table justifies every running service on the system to ensure the Principle of Least Privilege.

**Audit Command**: `systemctl list-units --type=service --state=running`

| Service Name | Description | Justification | Listen Port |
| :--- | :--- | :--- | :--- |
| `sshd.service` | SSH Daemon | Remotely manage the server. | TCP 22 |
| `systemd-journald` | Logging Svc | Collects and stores system logs. | Local |
| `ufw.service` | Firewall | Enforces network access rules. | Kernel |
| `fail2ban.service` | IPS Daemon | Bans IPs with too many auth failures. | Log Monitor |
| `cron.service` | Job Scheduler | Runs automated updates/backups. | N/A |
| `getty@tty1` | Console Login | Physical/Hypervisor console access. | N/A |

*Note: `snapd` and `multipathd` were disabled in Week 6 optimizations.*

## 3. Remaining Risk Assessment

Despite hardening, some risks remain due to the environment's constraints.

| Risk Identified | Risk Level | Mitigation Strategy | Status |
| :--- | :--- | :--- | :--- |
| **Single Point of Failure** | High | None. (Single VM implementation). | **Accepted** |
| **SSH Key Theft** | Medium | Keys are on workstation; passphrase protected. | **Mitigated** |
| **Zero-Day Exploits** | Low | AppArmor profiles reduce blast radius. | **Mitigated** |

## 4. Final Conclusion

The system has transformed from a default, insecure installation into a hardened, monitored server.
*   **Confidentiality**: Ensured via SSH Keys and Firewall.
*   **Integrity**: Maintained via `unattended-upgrades` and `AppArmor`.
*   **Availability**: Monitored via custom scripts and `fail2ban` protection.

---
[Return to Home](../README.md)
