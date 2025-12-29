# Week 2: Security Planning and Testing Methodology

Effective system administration requires a dual-focus approach: proactive **Security Planning** and rigorous **Testing Methodology**.

*   **Security Planning** involves identifying potential vulnerabilities and defining a set of baseline controls before the system is fully operational. By establishing a "hardened" configuration early, we reduce the attack surface and ensure that security is integrated into the system's architecture rather than added as an afterthought.
*   **Testing Methodology** is the process of verifying that our planned security controls are correctly implemented and effective. It provides empirical evidence that the system behaves as expected under both normal conditions and potential attacks/resource exhaustion.

---

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

To ensure the security controls are effective and the system remains stable under load, I have developed a structured four-phase testing methodology. This plan transitions from broad automated audits to specific manual verifications and performance stress tests.

### Phase 1: Automated Security Auditing (Lynis)
*   **Objective**: Establish a security baseline and identify system configuration weaknesses.
*   **Method**: Run `sudo lynis audit system` to scan the entire OS.
*   **Key Metrics**: Lynis Hardening Index and the number of "Warnings" vs. "Suggestions".
*   **Success Criteria**: A hardening index score above 60 and no "Critical" warnings post-mitigation.

### Phase 2: Network & Firewall Validation (Nmap)
*   **Objective**: Verify that the `UFW` firewall is correctly configured and no unauthorized services are exposed.
*   **Method**: Run Nmap scans from the host machine (workstation) against the VM's static IP:
    *   `nmap -sT [IP]` (TCP Connect scan)
    *   `nmap -sU [IP]` (UDP scan for common services)
*   **Success Criteria**: Only Port 22 (SSH) registers as `open`; all other ports must be `filtered` or `closed`.

### Phase 3: Control Specific Verification (Manual)
*   **Objective**: Validate the implementation of specific security policies.
*   **Test Cases**:
    1.  **SSH Auth Check**: Attempt to log in via SSH using a password (should be rejected).
    2.  **Root Login Check**: Attempt to log in directly as `root` (should be rejected).
    3.  **Sudoers Verification**: Ensure the administrative user can execute commands with `sudo` while regular actions are restricted.
*   **Success Criteria**: Failed login attempts for restricted methods and successful privilege escalation for the authorized user.

### Phase 4: Performance & Stability Testing (Stress-ng)
*   **Objective**: Evaluate how the system handles resource exhaustion and ensure the security monitoring tools (Fail2Ban/Lynis) don't crash under load.
*   **Method**: Use `stress-ng` to simulate various bottlenecks:
    *   `stress-ng --cpu 2 --timeout 60s` (CPU stress)
    *   `stress-ng --vm 1 --vm-bytes 512M --timeout 60s` (Memory stress)
*   **Monitoring**: Use `htop` in a separate terminal to observe process behavior and `vmstat 1` to track context switching and IO wait.
*   **Success Criteria**: The system recovers gracefully within 30 seconds after the stressor terminates without service failure.

---
[Next: Week 3 - Application Selection](week3.md)
