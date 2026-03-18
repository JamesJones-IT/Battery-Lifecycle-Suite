# 🔋 Battery Lifecycle & Optimization Suite

### 🛠️ The Business Problem
In a 2nd Line Support environment, battery degradation is a leading cause of hardware failure and user downtime. Relying on users to report "short battery life" is reactive and inefficient.

### 🚀 The Solution (ITIL-Aligned)
I developed a modular PowerShell suite that moves from **Measurement** to **Remediation**:

1. **Check & Analyze:** Captures hardware telemetry (Design vs. Full Charge Capacity) to calculate real-world wear levels. 
2. **Fix & Optimize:** Applies system-level changes (Screen timeouts, Background app restrictions, and Power plans) to extend the lifespan of aging hardware.

### 📈 Evolution & Debugging
* **v1.0:** Identified a 'Divide by Zero' runtime error when executed on Desktop PCs (which lack battery hardware).
* **v2.0:** Implemented environment-aware logic to skip hardware checks on desktops while still allowing software optimizations.
* **Result:** Reduced manual triage time and provided data-driven insights for hardware replacement cycles.
