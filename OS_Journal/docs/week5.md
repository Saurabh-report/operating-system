# Week 5: Advanced Security and Monitoring Infrastructure

## 1. Access Control (AppArmor/SELinux)

I have verified that **AppArmor** is active on Ubuntu Server.

### Command:
```bash
sudo aa-status
```
**Evidence:**
```text
[INSERT OUTPUT HERE]
```
*Justification*: AppArmor provides Mandatory Access Control (MAC) to restrict programs to a limited set of resources.

## 2. Automatic Security Updates

Configured `unattended-upgrades` to automatically install security patches.

### Configuration (`/etc/apt/apt.conf.d/50unattended-upgrades`):
```text
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}";
    "${distro_id}:${distro_codename}-security";
};
```

## 3. Fail2Ban Configuration

Installed and configured `fail2ban` to protect SSH.

### Jail Config (`/etc/fail2ban/jail.local`):
```ini
[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
```
**Evidence:**
Command: `sudo fail2ban-client status sshd`
```text
[INSERT OUTPUT HERE]
```

## 4. Scripting Deliverables

I have developed two scripts to automate verify security and monitor performance.

### A. Security Baseline Script (`security-baseline.sh`)
This script checks if the system meets my security requirements (Root disabled, UFW on).

[Link to script](../scripts/security-baseline.sh)

### B. Remote Monitoring Script (`monitor-server.sh`)
This script runs on the workstation and retrieves key metrics from the server via SSH.

[Link to script](../scripts/monitor-server.sh)

---
[Next: Week 6 - Performance Evaluation](week6.md)
