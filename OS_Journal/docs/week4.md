# Week 4: Initial System Configuration & Security Implementation

This journal entry documents the server deployment and foundational security implementation. All configurations were performed remotely via SSH from the administrative workstation (`192.168.56.1`), adhering to the administrative constraint.

## 1. Configure SSH with Key-Based Authentication

To replace insecure password-based login, I generated an Ed25519 key pair on the workstation and deployed it to the server.

**Commands Executed on Workstation:**
```powershell
# Generate Key Pair
ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519"

# Copy Public Key to Server (initially using password)
type $HOME/.ssh/id_ed25519.pub | ssh user@192.168.56.10 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

## 2. Configure Firewall (UFW)

I configured the Uncomplicated Firewall (UFW) to enforce a "default deny" policy, permitting SSH connections **only** from my specific workstation IP (`192.168.56.1`).

**Commands Executed on Server:**
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow from 192.168.56.1 to any port 22 proto tcp
sudo ufw enable
```

## 3. Manage Users and Privilege Management

I created a dedicated administrative user (`admin_user`) to separate administrative tasks from the default account, adhering to the principle of least privilege.

**Commands Executed on Server:**
```bash
# Create new user
sudo adduser admin_user

# Add to sudo group
sudo usermod -aG sudo admin_user
```

## 4. SSH Access Evidence

The following screenshot demonstrates a successful SSH connection to the server using the new key-based authentication (no password prompt).

**[INSERT SCREENSHOT HERE: Capture your terminal showing a successful 'ssh admin_user@192.168.56.10' login command]**

## 5. Configuration Files (Before and After)

I modified `/etc/ssh/sshd_config` to disable Password Authentication and Root Login.

**Diff of Changes:**
```diff
--- /etc/ssh/sshd_config.bak
+++ /etc/ssh/sshd_config
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
```

## 7. Remote Administration Evidence

To satisfy the administrative constraint, the following evidence shows administrative commands (`apt update`) being executed remotely via the SSH session.

**[INSERT SCREENSHOT HERE: Capture your terminal showing you running 'sudo apt update' inside the SSH session]**

---
[Next: Week 5 - Advanced Security](week5.md)
