# Obsidian daily / diary フォルダを月別サブフォルダに整理するスクリプト
# 使い方: PowerShell で実行するだけ

$vaultPath = "C:\Users\aaha5\iCloudDrive\iCloud~md~obsidian\Claude code"

$targets = @(
    @{ folder = "daily"; pattern = "2026-06-*.md"; dest = "2026-6" },
    @{ folder = "diary"; pattern = "2026-06-*.md"; dest = "2026-6" }
)

foreach ($t in $targets) {
    $srcDir  = Join-Path $vaultPath $t.folder
    $destDir = Join-Path $srcDir $t.dest

    if (-not (Test-Path $srcDir)) {
        Write-Host "スキップ: フォルダが存在しません -> $srcDir"
        continue
    }

    $files = Get-ChildItem -Path $srcDir -Filter $t.pattern -File

    if ($files.Count -eq 0) {
        Write-Host "移動対象なし: $srcDir ($($t.pattern))"
        continue
    }

    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir | Out-Null
        Write-Host "作成: $destDir"
    }

    foreach ($f in $files) {
        $dst = Join-Path $destDir $f.Name
        Move-Item -Path $f.FullName -Destination $dst
        Write-Host "移動: $($f.Name) -> $($t.folder)\$($t.dest)\"
    }
}

Write-Host "`n完了しました。"
