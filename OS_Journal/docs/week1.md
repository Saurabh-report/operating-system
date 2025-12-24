# Week 1: System Planning and Distribution Selection

## 1. System Architecture Diagram

The following diagram illustrates the dual-system architecture used for this coursework. It consists of a **Host Workstation** (Windows) running a **VirtualBox** hypervisor, which hosts the **Headless Linux Server**.

```mermaid
graph TD
    subgraph Host["Host Machine (Windows/MacOS)"]
        Workstation["Admin Workstation<br>(SSH Client: Powershell/Terminal)"]
        VBox["VirtualBox Hypervisor"]
        
        subgraph VirtualNetwork["Host-Only Network (192.168.56.x)"]
            Server["Linux Server (Headless)<br>Ubuntu Server 24.04"]
        end
    end

    Workstation -->|SSH (Port 22)| Server
    Server -->|NAT Adapter| Internet["Internet (Updates/Packages)"]
    
    style Server fill:#f9f,stroke:#333,stroke-width:2px
    style Workstation fill:#bbf,stroke:#333,stroke-width:2px
```

## 2. Distribution Selection Justification

### Selected Distribution: **Ubuntu Server 24.04 LTS**

| Feature | Ubuntu Server 24.04 LTS | Alpine Linux | CentOS Stream | Justification for Choice |
| :--- | :--- | :--- | :--- | :--- |
| **Package Management** | APT (Rich repository) | APK (Lightweight) | DNF (RPM based) | APT is widely supported, making troubleshooting easier for learning. |
| **Stability** | High (LTS - 5 years support) | High | Variable (Rolling-ish) | Long Term Support ensures a stable environment for the 7-week course. |
| **Resource Usage** | Moderate (~512MB RAM min) | Very Low (<100MB) | Moderate | While Alpine is lighter, Ubuntu is the industry standard for general purposes and good for learning `systemd`. |
| **Documentation** | Extensive community | Good, but minimal | Enterprise focused | Excellent documentation availability for beginners/students. |

**Conclusion:** I chose Ubuntu Server 24.04 because it balances performance with ease of use and has vast documentation, which is critical for solving issues during the coursework.

## 3. Workstation Configuration

**Chosen Approach: Option B (Host Machine with SSH Client)**

I have opted to use my native **Windows** host machine with **PowerShell/OpenSSH** as the workstation. 

*   **Rationale**: This reduces resource overhead compared to running a second "Desktop Linux VM". My laptop has efficient SSH tools built-in, and I can straightforwardly transfer files using `scp`.
*   **Tools**: PowerShell, VS Code (Remote SSH extension), Git.

## 4. Network Configuration

To allow connectivity between the Host and the Guest VM while maintaining internet access for the VM, I have configured two network adapters in VirtualBox:

1.  **Adapter 1: NAT**
    *   **Purpose**: Allows the VM to access the internet to download packages (`apt update`, `apt install`).
    *   **Configuration**: Default VirtualBox NAT.
2.  **Adapter 2: Host-Only Adapter**
    *   **Purpose**: Creates a private network (`vboxnet0`) between the Host (my laptop) and the VM.
    *   **Configuration**:
        *   Host IP: `192.168.56.1`
        *   Server IP (Static): `192.168.56.10` (configured via Netplan).

## 5. System Specifications (Evidence)

The following commands verify the system state after initial installation.

*(Run these commands on your server and paste the output below)*

### `uname -a` (Kernel Info)
```bash
[INSERT OUTPUT HERE, e.g., Linux server 5.15.0-91-generic #101-Ubuntu SMP ...]
```

### `lsb_release -a` (OS Version)
```bash
[INSERT OUTPUT HERE]
```

### `free -h` (Memory Usage)
```bash
[INSERT OUTPUT HERE]
```

### `df -h` (Disk Usage)
```bash
[INSERT OUTPUT HERE]
```

### `ip addr` (Network Interfaces)
```bash
[INSERT OUTPUT HERE]
```

---
[Next: Week 2 - Security Planning](week2.md)
