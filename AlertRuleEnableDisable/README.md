# 内容
- Azure Monitorのアラートルールの有効化・無効化を自動で行うスクリプト

# 実行方法
- alertrulelist.txtとして有効化・無効化したいアラートルールのリストを用意する
- その際、LogなのかMetricなのかシグナルの種類を指定する
    - シグナルによってコマンドが異なるため 
    - 例) TESTRG01,testalertrule01,Log

# 注意点
- Update-AzScheduledQueryruleの実行時、Log Analytics側のログクエリの中で`AggregatedValue`という名前のカラムを明示的に作成しておかないとBadRequestエラーになる。バグ？

```powerShell
# Log Alertの場合ログクエリの中でAggregatedValueカラムを明示的に作成しておかないとBadRequest Error
# Enable Log Alert
Update-AzScheduledQueryRule -Name $alertrulename -ResourceGroupName $rgname -Enabled $true
# Disable Log Alert
Update-AzScheduledQueryRule -Name $alertrulename -ResourceGroupName $rgname -Enabled $false
```
