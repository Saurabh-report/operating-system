# Week 3: Application Selection for Performance Testing

To accurately assess the stability and efficiency of an operating system, it is necessary to subject it to a variety of workloads. This phase, **Application Selection**, is focused on choosing tools that can stress-test the system's core subsystems: the CPU, Memory, Disk I/O, and Network.

*   **Application Selection Strategy**: We choose a mix of **synthetic benchmarks** (like `stress-ng`) for isolated component testing and **real-world applications** (like `Nginx`) to observe how the OS manages concurrent processes and network traffic in a typical server environment.
*   **Performance Testing Goals**: The objective is to establish a performance baseline. Understanding how the system behaves under 100% utilization allows us to predict scalability and ensure that security controls do not significantly degrade the user experience or system responsiveness.

---

## 1. Application Selection Matrix

The following matrix categorizes our chosen tools by their primary resource impact. This categorization ensures that we do not just test the system "in general," but rather investigate how the Linux kernel handles specific pressure points—such as context switching in the CPU, page faults in memory, or interrupt handling during high I/O.

*   **Workload Type**: Defines the specific hardware or software subsystem being targeted.
*   **Application**: The specific package or binary selected to generate the load.
*   **Justification**: The technical rationale for why this tool is suitable for scientific performance measurement.

| Workload Type | Application | Justification |
| :--- | :--- | :--- |
| **CPU-Intensive** | **Stress-ng (CPU)** | Industry standard tool for generating reproducible, high-load synthetic CPU stress to test thermal throttling and scheduler behaviour. |
| **RAM-Intensive** | **Stress-ng (VM)** | Capable of allocating and thrashing specific amounts of memory to test OOM (Out of Memory) killer and swap interaction. |
| **I/O-Intensive** | **Dd** (Coreutils) | Standard command-line utility for copying files; excellent for testing sustained sequential disk write/read throughput. |
| **Network-Intensive** | **Nginx** | High-performance web server. When configured to serve static files under load, it creates significant network traffic and socket usage. |
| **Server Application** | **Nginx** | Represents a real-world "Server" workload (unlike synthetic tests), handling concurrent connections and daemon process management. |

![Application Selection Stress Evidence](w3%20Screenshot%20stress-ng%202025-12-29%20215518.png)

### Selection Rationale

The selection of these tools was driven by the need for **reproducibility** and **resource isolation**:

*   **Stress-ng** was chosen because it allows for granular control over stressors. By targeting the CPU and VM functions separately, we can observe how the Linux scheduler prioritizes threads versus how the Virtual Memory Manager handles memory pressure without confounding variables.
*   **Dd** is a fundamental tool that bypasses complex application layers, providing a "raw" look at disk performance. This is crucial for verifying that our OS configuration (filesystem, mount options) is optimized for data throughput.
*   **Nginx** serves a dual purpose. It validates the network stack's efficiency while simultaneously acting as a proxy for real-world server performance. Unlike the synthetic stress tests, Nginx involves complex system calls, socket management, and file descriptor handling, providing a holistic view of the server's health.

## 2. Installation Documentation

To prepare the environment for testing, I executed the following commands on the Ubuntu 24.04 Server. These ensure that the lateast security patches are installed and that our testing tools are available.

### Update and Upgrade System
Before installing new software, it is best practice to refresh the local package database and upgrade existing packages.
```bash
sudo apt update && sudo apt upgrade -y
```
*   **`update`**: Synchronizes the local package list with the remote repositories.
*   **`upgrade`**: Installs new versions of already installed packages.
*   **`-y`**: Automatically answers "yes" to prompts, allowing for non-interactive execution.

### Install Testing Utilities
I installed `stress-ng` for synthetic loads and `nginx` for a real-world server workload.
```bash
sudo apt install stress-ng nginx -y
```
*Wait for the process to complete to ensure all dependencies are met.*

> ![Installation Success](w3Screenshot%20install%20stress%20-g%202025-12-29%20211412.png)

### Verify Tool Presence
For `dd`, I verified its version to ensure the coreutils package is functioning correctly.
```bash
dd --version
```

---

## 3. Expected Resource Profiles

The following table documents the anticipated resource usage patterns for each application.

| Application | Resource Focus | Anticipated Profile |
| :--- | :--- | :--- |
| **Stress-ng (CPU)** | CPU | **100% User CPU Usage** on all assigned cores. minimal disk/network activity. High CPU temperature. |
| **Stress-ng (VM)** | RAM / Swap | **High Memory Usage** (up to 95%). Increased swap activity (si/so) if physical RAM is exceeded. |
| **Dd** | Disk I/O | **High System CPU (Kernel)** usage due to I/O interrupts. High **iowait** percentage. Sustained persistent storage writes. |
| **Nginx** | Network / CPU | **High Network Bandwidth** (RX/TX). Moderate CPU usage depending on request rate. Low per-process memory footprint. |

---

## 4. Monitoring & Execution Strategy

To measure performance, I will use a combination of real-time monitoring and logged data.

### Primary Monitoring Tools
*   **Htop**: Provides a real-time visual dashboard of resource utilization (CPU, RAM, Swap).
*   **Vmstat**: Used for high-resolution logging of system performance data.
*   **Iostat**: Used to track granular disk performance metrics.

---
[Next: Week 4 - Initial System Configuration](week4.md)
