# Phase 1: Battery Telemetry
Write-Host "Reading Battery Hardware Data..." -ForegroundColor Cyan

$Battery = Get-CimInstance -ClassName Win32_Battery

if ($Battery) {
    # Calculate Wear Level
    $Design = $Battery.DesignCapacity
    $Full = $Battery.FullChargeCapacity
    $HealthPct = [Math]::Round(($Full / $Design) * 100, 2)

    $BatteryData = [PSCustomObject]@{
        Device          = $Battery.DeviceID
        DesignCapacity  = $Design
        CurrentFullCap  = $Full
        HealthPercentage = $HealthPct
        Status          = $Battery.Status
    }

    $BatteryData | Export-Csv -Path "$env:TEMP\battery_report.csv" -NoTypeInformation
    Write-Host "✅ Step 1 Complete: Battery data captured." -ForegroundColor Green
} else {
    Write-Host "❌ Error: No battery detected (Is this a Desktop?)." -ForegroundColor Red
}

# Phase 2: Hardware Triage
$Data = Import-Csv -Path "$env:TEMP\battery_report.csv"

Write-Host "--- BATTERY ANALYSIS ---" -ForegroundColor Cyan
Write-Host "Current Health: $($Data.HealthPercentage)%"

if ($Data.HealthPercentage -lt 50) {
    Write-Host "[!] CRITICAL: Battery is at end-of-life. Hardware replacement required." -ForegroundColor Red
} elseif ($Data.HealthPercentage -lt 80) {
    Write-Host "[!] WARNING: Battery wear detected. Optimization recommended to extend life." -ForegroundColor Yellow
} else {
    Write-Host "[✓] Battery health is Excellent." -ForegroundColor Green
}

# Phase 3: Battery Life Extension (Remediation)
try {
    Write-Host "Applying Battery-Saver Optimizations..." -ForegroundColor Magenta

    # 1. Enable Windows Power Saving Mode
    powercfg /attributes SUB_ENERGYSAVER 5c54496f-c96b-4e67-a63e-b6e512cf30a5 ATTRIB_HIDE -1
    
    # 2. Reduce Screen Timeout (Saves massive power)
    powercfg /timeout-dc-display 2
    
    # 3. Disable Background Apps (Reduces CPU 'Spikes' on battery)
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f

    Write-Host "✅ SUCCESS: System tuned for maximum battery longevity." -ForegroundColor Green
} catch {
    Write-Host "❌ ERROR: Admin rights required for power configuration." -ForegroundColor Red
}

Write-Host "`nPress any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
