# Week 5: Advanced Security and Monitoring Infrastructure

## 1. Implement Access Control (AppArmor)

I have verified and documented the status of Mandatory Access Control (MAC) using AppArmor, which restricts programs' capabilities to a defined profile, preventing zero-day exploits from gaining root access.

**Verification Command:**
```bash
sudo aa-status
```
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
*   **Execution Method**: Ran via SSH from workstation.

**Execution Screenshot:**
**[INSERT SCREENSHOT HERE: Output of ./security-baseline.sh showing [MATCH] for all checks]**

## 5. Remote Monitoring Script

I developed a monitoring script that runs on the workstation and retrieves health metrics from the server via SSH without requiring a heavy agent installation.

*   **Script Path**: [`scripts/monitor-server.sh`](../scripts/monitor-server.sh)
*   **Metrics Collected**: Uptime, Free Memory, Disk Usage, Active Users.

**Execution Screenshot:**
**[INSERT SCREENSHOT HERE: Output of ./monitor-server.sh showing system stats]**

---
[Next: Week 6 - Performance Evaluation](week6.md)
