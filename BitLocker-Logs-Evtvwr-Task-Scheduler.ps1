[string]$user_defined_drive = Read-Host "Enter drive in capital letter (C or D or E, etc.)"
$bitlocker_status = (Get-BitLockerVolume | Where-Object { $_.MountPoint -eq "$($user_defined_drive):" }).ProtectionStatus
$bitlocker_status

$logs_path = "$Env:windir\CCM\Logs"

if ((Test-Path $logs_path) -eq $true) {
    New-Item -Path "C:\Windows\CCM\Logs" -ItemType Directory -Force
}
else {
    Write-Warning "Failed to create the Logs folder. Try creating C:\Windows\CCM\Logs manually and re-run the script. Exiting..."
}
return

if ($bitlocker_status -eq 'Off') {
    Write-Host "Enabling the BitLocker Protection for $user_defined_drive drive"
    try {
        Enable-BitLocker -MountPoint $user_defined_drive -EncryptionMethod XtsAes256 -RecoveryKeyPath $logs_path
    }
    catch {
        Write-Warning "Could not encrypt BitLocker using PowerShell. Trying with CMD commands"
    }
}

Start-Sleep -Seconds 1

Write-Output "Collecting the logs from Event Viewer"
Get-WinEvent -LogName "Microsoft-Windows-BitLocker-API/Management" -MaxEvents 100 | Out-File -FilePath "$logs_path\BitLocker-API.log"
if ((Test-Path $logs_path\BitLocker-API.log) -eq $true) {
    Write-Output "Collected BitLocker-API logs"
}
elseif ($false) {
    Write-Warning "Failed to extract BitLocker API logs"
}

if ((Test-Path $logs_path\BitlockerManagementHandler.log) -eq $false) {
    Write-Warning "BitLocker Handler Logs missing"
}
elseif ($true) {
    $true
}

Start-Sleep -Seconds 1

Write-Host "Checking BitLocker status again"

function cmd_encryption {
    Write-Output "Failed to encrypt using PowerShell. Executing from Command Prompt"
    Start-Process cmd.exe -ArgumentList "/k manage-bde -on C: -RecoveryPassword && manage-bde -protectors -get C: > C:\Windows\CCM\Logs.txt" -Verb runas
}

if (((Get-BitLockerVolume | Where-Object { $_.MountPoint -eq "$($user_defined_drive):" }).ProtectionStatus) -eq "Off") {
    cmd_encryption
}