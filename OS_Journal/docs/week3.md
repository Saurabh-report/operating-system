# Week 3: Application Selection for Performance Testing

## 1. Application Selection Matrix

I have selected the following applications to represent different workload types for Phase 6 analysis.

| Workload Type | Application | Justification | Resource Focus |
| :--- | :--- | :--- | :--- |
| **CPU / General** | **Stress-ng** | Industry standard tool for generating reproducible synthetic loads on specific subsystems. | CPU / Context Switches |
| **Network / Web** | **Nginx** | Lightweight, high-performance web server. Good for testing request latency and concurrency. | Network / RAM |
| **I/O / Disk** | **Dd** (System Tool) | Standard utility to test raw disk write/read speeds. | Disk I/O |
| **Language Runtime** | **Python Script** | Represents a typical interpreted language workload (calculating primes). | Single-core CPU |

## 2. Installation Documentation

The following commands were used to install the selected software via SSH.

### Update Package List
```bash
sudo apt update && sudo apt upgrade -y
```

### Install Stress-ng and Nginx
```bash
sudo apt install stress-ng nginx python3 -y
```
*Evidence: Packages installed successfully.*

## 3. Expected Resource Profiles

| Application | Expected Behaviour | Monitoring Strategy |
| :--- | :--- | :--- |
| **Stress-ng (CPU)** | 100% usage on assigned cores. High heat generation. | `htop` (GREEN bars), `mpstat` |
| **Nginx** | Low idle usage. Spikes in RAM/CPU during concurrent requests. | `access.log`, `systemctl status nginx` |
| **Python Primes** | 100% usage on ONE core (Global Interpreter Lock limitation). | `top` (filtering by process) |

---
[Next: Week 4 - Initial System Configuration](week4.md)
