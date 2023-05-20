$LogFolders = @(
    "C:\Goldensoft\�����\GS.Offline.Service\SnNetLockLeave",
    "C:\Goldensoft\�����\GS.Offline.Service\WxCreateApplyKeyWxQrcode"
)

$DaysToKeep = 30
$CurrentDate = Get-Date
$OldDate = $CurrentDate.AddDays(-$DaysToKeep)

$LogFileName = "deletion_log.txt"
$LogFilePath = Join-Path $PSScriptRoot $LogFileName

Write-Output "$(Get-Date) ��ʼɾ��������־�ļ�" | Out-File -FilePath $LogFilePath -Append

foreach ($LogFolder in $LogFolders) {
    $Files = Get-ChildItem -Path $LogFolder -Filter "*.txt" -File | Where-Object { $_.Name -match '^\d{4}-\d{2}-\d{2}\.txt$' -and $_.LastWriteTime -lt $OldDate }

    foreach ($File in $Files) {
        try {
            Remove-Item $File.FullName -ErrorAction Stop
            Write-Output "$($File.FullName) ɾ���ɹ�" | Out-File -FilePath $LogFilePath -Append
        }
        catch {
            Write-Output "ɾ�� $($File.FullName) ʧ��: $($_.Exception.Message)" | Out-File -FilePath $LogFilePath -Append
        }
    }
}

Write-Output "$(Get-Date) ɾ��������־�ļ����" | Out-File -FilePath $LogFilePath -Append
