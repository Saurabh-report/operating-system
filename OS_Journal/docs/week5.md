# Week 5: Advanced Security and Monitoring Infrastructure

## 1. Implement Access Control (AppArmor)

I have verified and documented the status of Mandatory Access Control (MAC) using AppArmor, which restricts programs' capabilities to a defined profile, preventing zero-day exploits from gaining root access.

**Installation & Verification Commands:**
```bash
# Ensure AppArmor utilities are installed
sudo apt install apparmor-utils -y

# Check Status
sudo aa-status
```

> ![AppArmor Status](w5%20Screenshot%20sudo%20aa-%20status2025-12-30%20112645.png)

**Evidence of Implementation:**
```text
apparmor module is loaded.
44 profiles are loaded.
44 profiles are in enforce mode.
   /usr/sbin/tcpdump
   /usr/lib/NetworkManager/nm-dhcp-client.action
   /usr/lib/NetworkManager/nm-dhcp-helper
   ...
0 profiles are in complain mode.
0 processes are in complain mode.
0 processes are unconfined but have a profile.
```
*Rationale*: By enforcing profiles in "Enforce Mode", any action not explicitly allowed by the profile is blocked and logged.

## 2. Configure Automatic Security Updates

To ensure the system remains patched against known vulnerabilities (CVEs) without manual intervention, I configured `unattended-upgrades`.

**Implementation Commands:**
```bash
# Install the package
sudo apt install unattended-upgrades -y

# Enable the configuration wizard (Select 'Yes')
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

> ![Unattended Upgrades Config](w5%20Screenshot%20unattended-upgrades%202025-12-29%20223825.png)

**Configuration Evidence:**
File: `/etc/apt/apt.conf.d/50unattended-upgrades`
```text
// Automatically upgrade packages from these (origin:archive) pairs
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}";
    "${distro_id}:${distro_codename}-security";
    // "${distro_id}:${distro_codename}-updates";
};
```
*Verification*: Examining `/var/log/unattended-upgrades/` confirms that security patches are applied daily.

## 3. Configure Fail2Ban for Intrusion Detection

I implemented `fail2ban` to protect the SSH service from brute-force attacks. It scans log files for repeated failed login attempts and bans the offending IP address using the firewall.

**Implementation Commands:**
```bash
# Install Fail2Ban
sudo apt install fail2ban -y

# Create a local configuration copy
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Restart service to apply changes
sudo systemctl restart fail2ban
```

**Jail Configuration (`/etc/fail2ban/jail.local`):**
```ini
[sshd]
enabled = true
port    = 22
logpath = %(sshd_log)s
backend = %(sshd_backend)s
maxretry = 3
bantime = 1h
```

**Status Verification:**
Command: `sudo fail2ban-client status sshd`

> ![Fail2Ban Status](w5%20Screenshot%20sudo%20fail2ban%20sshd%20status%202025-12-30%20113422.png)
```text
Status for the jail: sshd
|- Filter
|  |- Currently failed:	0
|  |- Total failed:	5
|- Actions
   |- Currently banned:	0
   |- Total banned:	1
```

## 4. Security Baseline Verification Script

I created a custom script to audit the server against my defined security baseline (UFW active, Root Login disabled, AppArmor active).

*   **Script Path**: [`scripts/security-baseline.sh`](../scripts/security-baseline.sh)

**Execution Instructions (Run on Server):**
```bash
# 1. Copy script to server (Run from Workstation)
scp scripts/security-baseline.sh admin_user@192.168.56.10:~

# 2. SSH into server
ssh admin_user@192.168.56.10

# 3. Make executable and run (Run on Server)
chmod +x security-baseline.sh
./security-baseline.sh
```

**Execution Evidence:**

> ![Security Baseline Execution 1](w5%20Screenshot%20%20chmod%20+x%20security-baseline.sh2025-12-30%20123549.png)
> ![Security Baseline Results](w5%20Screenshot%20security%20baseline%202025-12-30%20125354.png)

## 5. Remote Monitoring Script

I developed a monitoring script that runs on the workstation and retrieves health metrics from the server via SSH without requiring a heavy agent installation.

*   **Script Path**: [`scripts/monitor-server.sh`](../scripts/monitor-server.sh)

**Execution Instructions (Run on Workstation):**
```powershell
# 1. Make executable (if using Git Bash/WSL)
chmod +x scripts/monitor-server.sh

# 2. Run the script
./scripts/monitor-server.sh
```

**Execution Evidence:**

> ![Remote Monitoring Script 1](w5%20Screenshot%20monitor%202025-12-30%20130045.png)
> ![Remote Monitoring Script 2](w5%20Screenshot%20monitoring%20server%202025-12-30%20132130.png)

---
[Next: Week 6 - Performance Evaluation](week6.md)
