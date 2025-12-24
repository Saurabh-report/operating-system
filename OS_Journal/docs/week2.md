# Week 2: Security Planning and Testing Methodology

## 1. Security Configuration Checklist

To ensure a secure server environment, I have established the following baseline configuration checklist:

| Category | Control | Rationale | Status |
| :--- | :--- | :--- | :--- |
| **Access Control** | **SSH Hardening** | Disable password auth to prevent brute force; use keys only. | Pending |
| **Network** | **UFW Firewall** | Deny all incoming by default; allow only SSH (Port 22) from specific IP. | Pending |
| **System** | **Unattended Upgrades** | Ensure security patches are applied automatically to reduce vulnerability window. | Pending |
| **Privilege** | **Sudo User** | Create a non-root user for administration to practice least privilege. | Pending |
| **Intrusion** | **Fail2Ban** | Ban IPs that show malicious signs (repeated failed logins). | Pending |

## 2. Threat Model

I have identified three key security threats relevant to this specific deployment:

### Threat 1: SSH Brute Force Attacks
*   **Description**: Attackers attempting to guess the root or user password to gain control.
*   **Likelihood**: High (Bots scan public IPs constantly).
*   **Mitigation Strategy**:
    1.  Disable `PasswordAuthentication` in `sshd_config`.
    2.  Disable `PermitRootLogin`.
    3.  Implement `Fail2Ban` to block repeated offenders.

### Threat 2: Unpatched Service Vulnerabilities
*   **Description**: Exploiting known CVEs in outdated software (e.g., old kernel or sudo version).
*   **Likelihood**: Medium (Depends on disclosure rate).
*   **Mitigation Strategy**:
    1.  Enable `unattended-upgrades`.
    2.  Regular manual auditing with `Lynis`.

### Threat 3: Unauthorized Network Access
*   **Description**: Accessing services meant to be internal or blocked.
*   **Likelihood**: Low (On private network), but High if bridged.
*   **Mitigation Strategy**:
    1.  Configure `UFW` to `default deny incoming`.
    2.  Restrict SSH access to strictly the Host Only Network IP range.

## 3. Testing Methodology Plan

To verify these controls and system performance:
*   **Security**: I will use **Lynis** for automated auditing and **Nmap** (from the workstation) to verify firewall rules.
*   **Performance**: I will use **Stress-ng** to generate synthetic loads and **Htop/Vmstat** to monitor real-time resource usage.

---
[Next: Week 3 - Application Selection](week3.md)
