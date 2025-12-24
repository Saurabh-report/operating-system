# Week 4: Initial System Configuration & Security Implementation

## 1. SSH Configuration & Hardening

I have secured the SSH daemon by editing `/etc/ssh/sshd_config`.

### Changes Made:
1.  **generated keys** on workstation: `ssh-keygen -t ed25519`
2.  **copied id** to server: `ssh-copy-id user@192.168.56.10`
3.  **Modified Config**:
    ```bash
    PasswordAuthentication no
    PermitRootLogin no
    PubkeyAuthentication yes
    ```
4.  **Restarted SSH**: `sudo systemctl restart ssh`

**Evidence: Successful Login without Password**
```text
[INSERT SCREENSHOT OF TERMINAL LOGGING IN HERE]
```

## 2. Firewall Configuration (UFW)

I configured the Uncomplicated Firewall (UFW) to lock down network access.

### Commands Executed:
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow from 192.168.56.0/24 to any port 22 proto tcp
sudo ufw enable
```

### Firewall Status Evidence
Command: `sudo ufw status verbose`
```text
[INSERT OUTPUT HERE, EXAMPLE:]
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    192.168.56.0/24
```

## 3. User Management

Created a dedicated administrative user `admin_user` and added them to `sudo` group.

```bash
sudo adduser admin_user
sudo usermod -aG sudo admin_user
```

**Evidence of User List:**
Command: `getent passwd {1000..60000}`
```text
[INSERT OUTPUT HERE]
```

---
[Next: Week 5 - Advanced Security](week5.md)
