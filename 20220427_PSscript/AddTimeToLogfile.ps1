# パターン1
# Transcriptによる簡易的なロギング：シェルに表示される内容をそのままログに記録
Start-Transcript
(Get-Date).ToString("yyyy/MM/dd HH:mm:ss") 
Write-Output "処理Aを開始します"
# 処理A
(Get-Date).ToString("yyyy/MM/dd HH:mm:ss") 
Write-Output "処理Aが終了しました"
Stop-Transcript

# パターン2
# OutFileによるロギング：記録したい内容を制御可能
$log = ".\log.txt"
Write-Output "$((Get-Date).ToString("yyyy/MM/dd HH:mm:ss")) 処理Aを開始します" | Out-File -FilePath $log -Encoding utf8 -Append
# 処理A・・・・