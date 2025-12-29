# Week 3: Application Selection for Performance Testing

To accurately assess the stability and efficiency of an operating system, it is necessary to subject it to a variety of workloads. This phase, **Application Selection**, is focused on choosing tools that can stress-test the system's core subsystems: the CPU, Memory, Disk I/O, and Network.

*   **Application Selection Strategy**: We choose a mix of **synthetic benchmarks** (like `stress-ng`) for isolated component testing and **real-world applications** (like `Nginx`) to observe how the OS manages concurrent processes and network traffic in a typical server environment.
*   **Performance Testing Goals**: The objective is to establish a performance baseline. Understanding how the system behaves under 100% utilization allows us to predict scalability and ensure that security controls do not significantly degrade the user experience or system responsiveness.

---

## 1. Application Selection Matrix

To evaluate the system's performance under various conditions, I have selected the following applications representing different workload types.

| Workload Type | Application | Justification |
| :--- | :--- | :--- |
| **CPU-Intensive** | **Stress-ng (CPU)** | Industry standard tool for generating reproducible, high-load synthetic CPU stress to test thermal throttling and scheduler behaviour. |
| **RAM-Intensive** | **Stress-ng (VM)** | Capable of allocating and thrashing specific amounts of memory to test OOM (Out of Memory) killer and swap interaction. |
| **I/O-Intensive** | **Dd** (Coreutils) | Standard command-line utility for copying files; excellent for testing sustained sequential disk write/read throughput. |
| **Network-Intensive** | **Nginx** | High-performance web server. When configured to serve static files under load, it creates significant network traffic and socket usage. |
| **Server Application** | **Nginx** | Represents a real-world "Server" workload (unlike synthetic tests), handling concurrent connections and daemon process management. |

## 2. Installation Documentation

The following commands were executed via SSH to install the selected software on the Ubuntu 24.04 Server.

### Update Package Repository
```bash
sudo apt update && sudo apt upgrade -y
```

### Install Stress-ng and Nginx
```bash
sudo apt install stress-ng nginx -y
```

### Verify Dd Installation
`dd` is part of the `coreutils` package, which is pre-installed on Ubuntu. Validated presence with:
```bash
dd --version
```

## 3. Expected Resource Profiles

The following table documents the anticipated resource usage patterns for each application.

| Application | Resource Focus | Anticipated Profile |
| :--- | :--- | :--- |
| **Stress-ng (CPU)** | CPU | **100% User CPU Usage** on all assigned cores. minimal disk/network activity. High CPU temperature. |
| **Stress-ng (VM)** | RAM / Swap | **High Memory Usage** (up to 95%). Increased swap activity (si/so) if physical RAM is exceeded. |
| **Dd** | Disk I/O | **High System CPU (Kernel)** usage due to I/O interrupts. High **iowait** percentage. Sustained persistent storage writes. |
| **Nginx** | Network / CPU | **High Network Bandwidth** (RX/TX). Moderate CPU usage depending on request rate. Low per-process memory footprint. |

## 4. Monitoring Strategy

To measure the performance of these applications, I will use the following monitoring approach:

### Primary Monitoring Tools
*   **Htop**: For real-time visual confirmation of per-process resource usage (CPU bars, Memory bars).
*   **Vmstat**: To log system-wide performance data (CPU, Memory, Swap, IO) at 1-second intervals (e.g., `vmstat 1`).
*   **Iostat**: Specifically for monitoring disk throughput and utilization during the `dd` tests.

### Measurement Approach
1.  **Baseline**: Record system stats for 60 seconds at idle.
2.  **Execution**: Run the specific workload for a fixed duration (e.g., 5 minutes).
3.  **Observation**: During execution, capture metrics using `vmstat 1 > log.txt` and take screenshots of `htop`.
4.  **Analysis**: Compare active metrics against the baseline to quantify the impact of the workload.

---
[Next: Week 4 - Initial System Configuration](week4.md)
