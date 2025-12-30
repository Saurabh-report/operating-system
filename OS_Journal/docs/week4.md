# Week 4: Initial System Configuration & Security Implementation

This journal entry documents the server deployment and foundational security implementation. All configurations were performed remotely via SSH from the administrative workstation (`192.168.56.1`), adhering to the administrative constraint.

## 1. Configure SSH with Key-Based Authentication

To resolve the security vulnerability of password adherence, I implemented Ed25519 key-based authentication. This cryptographic pair allows for robust Identity Access Management (IAM) without transmitting secrets over the network.

**Detailed Step-by-Step Configuration:**

1.  **Key Generation**:
    *   Command: `ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519"`
    *   *Rationale*: Ed25519 is chosen over RSA for its superior performance and smaller key size (256-bit) while providing higher security margins.
2.  **Key Deployment**:
    *   Command: `type $HOME/.ssh/id_ed25519.pub | ssh user@192.168.56.10 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"`
    *   *Mechanism*: This appends the public key to the server's authorized list, allowing the private key on the workstation to decrypt the challenge token during login.

## 2. Configure Firewall (UFW)

I configured the Uncomplicated Firewall (UFW) to implement a **"Default Deny"** security posture. This minimizes the attack surface by ensuring that no ports are open unless explicitly authorized.

**Applied Rule-set Logic:**
*   **Incoming Data**: `DENY` (Blocks all unsolicited traffic from the internet/network).
*   **Outgoing Data**: `ALLOW` (Permits server to fetch updates/packages).
*   **SSH Exception**: `ALLOW` only from `192.168.56.1/32` (Ensures only my specific admin workstation can manage the server).

**Commands Executed on Server:**
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow from 192.168.56.1 to any port 22 proto tcp
sudo ufw enable
```

## 3. Manage Users and Privilege Management

To comply with the Principle of Least Privilege (PoLP), I moved away from the default user to a named administrative account.

**Implementation Steps:**
1.  **Create User**: `sudo adduser admin_user`
    *   Creates a new user execution context with its own home directory.
2.  **Grant Sudo Access**: `sudo usermod -aG sudo admin_user`
    *   Adds the user to the `sudo` group, permitting root-level command execution only when explicitly requested (and logged) via `sudo`.

## 4. SSH Access Evidence

The screenshot below validates the successful implementation of the security controls. It demonstrates:
1.  **No Password Prompt**: Determining that Key-based authentication is active.
2.  **Successful Shell Access**: Confirming the firewall permitted the connection.

**[INSERT SCREENSHOT HERE: Capture your terminal showing a simple clean login 'ssh admin_user@192.168.56.10' where it logs in immediately without asking for a password]**
![SSH Key Login Verification](w4%20Screenshot%20passwords%202025-12-29%20222519.png)

## 5. Configuration Files (Before and After)

I hardened the SSH Daemon configuration (`/etc/ssh/sshd_config`) to permanently enforce these security policies.

**Change Log Analysis:**
*   `PasswordAuthentication no`: Hardens system against brute-force dictionary attacks.
*   `PermitRootLogin no`: Prevents direct root access, ensuring all administrative actions are attributable to a specific verified user (`admin_user`).

**Diff of Changes:**
```diff
--- /etc/ssh/sshd_config.bak (Original Default)
+++ /etc/ssh/sshd_config (Hardened)
@@ -56,8 +56,8 @@
-#PasswordAuthentication yes
+PasswordAuthentication no
 
-#PermitRootLogin prohibit-password
+PermitRootLogin no
 
-#PubkeyAuthentication yes
+PubkeyAuthentication yes
```

## 6. Firewall Documentation

The final firewall ruleset confirms that only the specific workstation IP is allowed access.

**Command:** `sudo ufw status verbose`
**Output:**
```text
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    192.168.56.1

> ![UFW Status Verbose](w4%20ufw%20status%20%20verbousScreenshot%202025-12-29%20223022.png)
```

## 7. Remote Administration Evidence

To adhere to the administrative constraint ("All server configurations must be performed via SSH"), I have verified complete remote control capability.

**Constraint Verification:**
1.  **Remote Connection**: Connected via `ssh admin_user@192.168.56.10`.
2.  **Privilege Escalation**: Successfully executed `sudo` commands without root login.
3.  **Task Execution**: Performed package updates and system checks remotely.

**Evidence of Administrative Actions:**

The screenshot below demonstrates the execution of the following commands in a single remote session:
1.  `whoami` (Verifying user identity)
2.  `sudo -v` (Verifying sudo access)
3.  `sudo apt update` (Verifying administrative package management capability)

**[INSERT SCREENSHOT HERE: Capture your terminal showing the output of 'whoami', 'sudo -v', and 'sudo apt update' executed successfully via SSH]**
![Administrative Evidence](w4%20Screenshot%20sudo%20-v%20%20%20%202025-12-29%20223454.png)

---
[Next: Week 5 - Advanced Security](week5.md)
