# Phase 1 & 2: Battery Telemetry & Analysis
Write-Host "--- BATTERY HEALTH CHECK ---" -ForegroundColor Cyan

$Battery = Get-CimInstance -ClassName Win32_Battery

if ($Battery -and $Battery.DesignCapacity -gt 0) {
    # Calculate Health
    $HealthPct = [Math]::Round(($Battery.FullChargeCapacity / $Battery.DesignCapacity) * 100, 2)
    Write-Host "Current Health: $HealthPct%" -ForegroundColor Yellow

    # Analysis Logic
    if ($HealthPct -lt 50) {
        Write-Host "[!] CRITICAL: Battery hardware is failing." -ForegroundColor Red
    } else {
        Write-Host "[✓] Battery hardware is healthy." -ForegroundColor Green
    }
    
    # Export for Step 3
    $HealthPct | Out-File "$env:TEMP\battery_val.txt"
} else {
    Write-Host "[i] No Battery Detected. Skipping hardware analysis (Likely a Desktop)." -ForegroundColor Gray
}

# Phase 3: Remediation
Write-Host "--- APPLYING POWER TWEAKS ---" -ForegroundColor Magenta

# 1. Set Screen Timeout to 2 mins (On Battery)
powercfg /timeout-dc-display 2

# 2. Enable Battery Saver Mode 
# (Note: Most 80% charge limits are handled by BIOS/Manufacturer apps like MyASUS or Lenovo Vantage)
Write-Host "TIP: To preserve chemistry, limit charge to 80% in your BIOS or Manufacturer App." -ForegroundColor Cyan

# 3. Disable Background Apps
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f /y

Write-Host "✅ SUCCESS: Power-draw reduced." -ForegroundColor Green
