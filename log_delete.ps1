$LogFolders = @(
    "C:\Goldensoft\服务端\GS.Offline.Service\SnNetLockLeave",
    "C:\Goldensoft\服务端\GS.Offline.Service\WxCreateApplyKeyWxQrcode"
)

$DaysToKeep = 30
$CurrentDate = Get-Date
$OldDate = $CurrentDate.AddDays(-$DaysToKeep)

$LogFileName = "deletion_log.txt"
$LogFilePath = Join-Path $PSScriptRoot $LogFileName

Write-Output "$(Get-Date) 开始删除过期日志文件" | Out-File -FilePath $LogFilePath -Append

foreach ($LogFolder in $LogFolders) {
    $Files = Get-ChildItem -Path $LogFolder -Filter "*.txt" -File | Where-Object { $_.Name -match '^\d{4}-\d{2}-\d{2}\.txt$' -and $_.LastWriteTime -lt $OldDate }

    foreach ($File in $Files) {
        try {
            Remove-Item $File.FullName -ErrorAction Stop
            Write-Output "$($File.FullName) 删除成功" | Out-File -FilePath $LogFilePath -Append
        }
        catch {
            Write-Output "删除 $($File.FullName) 失败: $($_.Exception.Message)" | Out-File -FilePath $LogFilePath -Append
        }
    }
}

Write-Output "$(Get-Date) 删除过期日志文件完成" | Out-File -FilePath $LogFilePath -Append
