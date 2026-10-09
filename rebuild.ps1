# 《古代漢語》刷題庫 · 標準重建腳本
# ------------------------------------------------------------
# 用法：在本目錄執行 powershell -ExecutionPolicy Bypass -File .\rebuild.ps1
#      或直接雙擊 rebuild.bat（會呼叫本腳本）
#
# 兩個必須守住的點：
#   --prefix quiz_gudaihanyu_    此值是 localStorage 的 key 前綴，改動即等於
#                                清空使用者既有的刷題進度／錯題池／收藏
#   主題層必須追加在樣式表末尾   否則被模板規則覆蓋，石青配色＋裝飾層全丟
#
# 【為何不用 --custom-css】
#   build.py 把 --custom-css 拼在 __STYLE_CSS__ 佔位符處，而該佔位符位於
#   <style> 區塊前部（模板第 345 行，緊接 reset 規則），其後還有全部組件規則。
#   結果是：同選擇器的覆蓋一律被後面的模板規則打敗（只有 :root 變數能生效）。
#   故本腳本改為「建置完成後，把主題 CSS 追加到 </style> 之前」，
#   語意等同真正的「後寫勝先寫」。
#
# 主題層的來源與注意事項見 _theme\石青.css 開頭註解。

$ErrorActionPreference = 'Stop'

$root  = $PSScriptRoot
$skill = Join-Path $env:USERPROFILE '.codex\skills\quiz-complete\build.py'
$theme = Join-Path $root '_theme\石青.css'
$out   = Join-Path $root 'index.html'

if (-not (Test-Path -LiteralPath $skill)) { throw "找不到 build.py：$skill" }
if (-not (Test-Path -LiteralPath $theme)) { throw "找不到主題檔：$theme" }

$css = Get-Content -LiteralPath $theme -Raw -Encoding UTF8

# style 屬 raw-text 元素：主題內若出現樣式結束標籤字面量，會提前閉合
if ($css -match '</\s*style') { throw "主題檔含樣式結束標籤字面量，會提前閉合 <style>：$theme" }

python $skill `
  --input  $root `
  --title  '《古代漢語》刷題庫' `
  --output $root `
  --prefix 'quiz_gudaihanyu_'

if ($LASTEXITCODE -ne 0) { throw "build.py 退出碼 $LASTEXITCODE" }

# ---- 追加主題層到樣式表末尾 ----
$html = [System.IO.File]::ReadAllText($out, [System.Text.UTF8Encoding]::new($false))
$marker = '/* ===== 石青主題層（rebuild.ps1 追加）===== */'
if ($html.Contains($marker)) { throw "index.html 已含主題層，請先確認是否重複建置" }

$idx = $html.IndexOf('</style>')
if ($idx -lt 0) { throw "index.html 找不到 </style>，無法追加主題" }

$html = $html.Substring(0, $idx) + $marker + "`n" + $css + "`n" + $html.Substring($idx)
[System.IO.File]::WriteAllText($out, $html, [System.Text.UTF8Encoding]::new($false))

# ---- 自檢：主題層必須落在模板規則之後 ----
$tail = $html.Substring($html.IndexOf($marker))
$errors = @()
if ($tail -notmatch '--accent:\s*#3a5f7d') { $errors += '主題變數 --accent 未見' }
if ($tail -notmatch '\.q-type\.single\s*\{[^}]*var\(--accent\)') { $errors += '題型標籤未覆蓋' }
if ($tail -notmatch '#modalExamResult \.modal') { $errors += '結算彈窗加寬未見' }
if ($html.Substring(0, $idx).Contains($marker)) { $errors += '主題層出現在樣式表前部' }
if ($errors.Count) { throw ('主題自檢未通過：' + ($errors -join '；')) }

Write-Host ''
Write-Host '✅ 重建完成：index.html 已更新，重新整理瀏覽器即可。'
