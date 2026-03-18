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
