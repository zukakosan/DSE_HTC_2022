# ログの名前 これがLogAnalyticsで収集設定したログの名前
$LogName = "demo-script"
# イベントソース生成(スクリプトファイル名など)
$EventSource = "TestScript01"
# イベントソースが存在するか確認(管理者としてでPowershell実行必要)
if(-not [System.Diagnostics.EventLog]::SourceExists($EventSource)) {
    #　イベントソースが存在しないので登録
    New-EventLog -LogName $LogName -Source $EventSource
}

# ログの内容
# EventSource内で作成したログファイルからデータをパースして$msgに代入する処理を記載
$msg = "<ログファイルの中身を記載>"
$EventID = 1001
$Category = 2

# イベントログへログの書き込み
Write-EventLog `
    -Message $msg `
    -LogName $LogName `
    -Source $EventSource `
    -EventID $EventID `
    -EntryType Error `
    -Category $Category