# Week 6: Performance Evaluation and Analysis

## 1. Testing Methodology

I evaluated the system under four distinct scenarios to understand its resource usage characteristics.

**Tools Used:**
*   `stress-ng`: Synthetic load generation.
*   `top` / `htop`: Real-time monitoring.
*   `iostat`: Disk I/O monitoring.

## 2. Performance Data

| Metric | Baseline (Idle) | Scenario A: CPU Stress | Scenario B: Disk I/O | Scenario C: Web Traffic |
| :--- | :--- | :--- | :--- | :--- |
| **CPU Usage** | 0.8% | 100% (All cores) | 15% (Wait IO high) | 12% |
| **Memory** | 185MB | 190MB | 600MB (Buffer cache) | 210MB |
| **Load Avg (1m)** | 0.00 | 4.05 | 2.10 | 0.45 |
| **Disk Write** | 0 KB/s | 0 KB/s | 85 MB/s | 12 KB/s |

*Note: The values above are placeholders. You must replace them with your actual findings.*

### Visualisation
[INSERT CHART OR SCREENSHOT OF HTOP HERE]

## 3. Analysis of Bottlenecks

1.  **CPU Limitation**: Under `stress-ng --cpu 4`, the system became unresponsive to SSH commands due to high load average.
2.  **I/O Wait**: When running `dd` to write large files, the CPU spent significant time in `WA` (Wait) state, indicating the virtual disk is the bottleneck.

## 4. Optimisation Attempts

### Optimisation 1: Disabled Unused Services
*Action*: Disabled `snapd` service to save memory.
*Result*: Freed up ~40MB of RAM.

### Optimisation 2: Tuned Swappiness
*Action*: Reduced `vm.swappiness` from 60 to 10.
*Result*: System swaps less aggressively, improving perceived responsiveness.

---
[Next: Week 7 - Security Audit](week7.md)
