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

> [!NOTE]
> **Screenshot Required**: Capture the output of `sudo ufw status verbose` to document the active firewall rules and baseline security state.
> ![Firewall Status](w2%20ufw%20status.png)

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
*   **Command**: `sudo lynis audit system`
*   **Key Metrics**: Lynis Hardening Index and the number of "Warnings" vs. "Suggestions".
*   **Success Criteria**: A hardening index score above 60 and no "Critical" warnings post-mitigation.

> [!NOTE]
> **Screenshot Required**: Capture the bottom section of the Lynis audit output showing the **Hardening Index** and the summary of warnings/suggestions.
> ![Lynis Audit Results 1](w2%20lynis%20audit%20resuts.png)
> ![Lynis Audit Results 2](w2%20lynis%20audit%20resuts%202%20screenshot.png)

### Phase 2: Network & Firewall Validation (Nmap)
*   **Objective**: Verify that the `UFW` firewall is correctly configured and no unauthorized services are exposed.
*   **Method**: Run Nmap scans from the host machine against the VM's static IP.
*   **Command**: `nmap -sT 192.168.56.10`
    *   **`-sT`**: Performs a TCP Connect scan (reliable and doesn't require root on the host).
*   **Success Criteria**: Only Port 22 (SSH) registers as `open`; all other ports must be `filtered` or `closed`.

> [!NOTE]
> **Screenshot Required**: Capture the Nmap scan results from the host machine showing that only the SSH port is open on the VM's IP.
> ![Nmap Scan Verification](w2%20nmap%20.png)

### Phase 3: Control Specific Verification (Manual)
*   **Objective**: Validate the implementation of specific security policies through direct interaction.
*   **Test Commands**:
    1.  **SSH Auth**: `ssh -o PubkeyAuthentication=no admin_user@192.168.56.10` (Testing rejection of passwords).
    2.  **Root Access**: `ssh root@192.168.56.10` (Testing block on direct root login).
*   **Success Criteria**: "Permission denied" messages for both unauthorized attempts.

> [!NOTE]
> **Screenshot Required**: Capture the terminal showing a failed SSH login attempt using a password (Permission denied) to verify that password authentication is successfully disabled.
> ![Manual SSH Test](w2%20ssh-vv.png)

### Phase 4: Performance & Stability Testing (Stress-ng)
*   **Objective**: Evaluate how the system handles resource exhaustion.
*   **Baseline Monitoring**: Use `vmstat 1` to log baseline activity before stressors are applied.

| Test Case | Execution Command | Technical Explanation |
| :--- | :--- | :--- |
| **CPU Stress** | `stress-ng --cpu 2 --timeout 60s` | **`--cpu 2`**: Spawns 2 CPU worker threads to maximize load. |
| **Memory Stress** | `stress-ng --vm 1 --vm-bytes 512M` | **`--vm-bytes 512M`**: Allocates 512MB of RAM to test memory pressure. |
| **I/O Stress** | `dd if=/dev/zero of=test bs=1G count=1` | **`bs=1G`**: Writes a 1GB block to test sequential disk write speed. |

*   **Success Criteria**: The system recovers gracefully within 30 seconds after the stressor terminates without service failure.

---
[Next: Week 3 - Application Selection](week3.md)
