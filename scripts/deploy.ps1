# NEON GLIDE 배포 — GitHub Pages와 itch.io를 한 번에 맞춘다.
# 둘이 어긋나면 홍보 링크마다 다른 버전이 돌아가므로 항상 같이 내보낸다.
#
#   .\scripts\deploy.ps1 "커밋 메시지"     커밋 + 푸시 + itch.io 동기화
#   .\scripts\deploy.ps1 -ItchOnly         커밋 없이 itch.io만 다시 밀어넣기
param(
  [string]$Message,
  [switch]$ItchOnly
)
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
Set-Location $root

# itch.io 빌드에 들어가는 파일 목록 (게임 + PWA 자산)
$assets = @('index.html', 'manifest.webmanifest', 'sw.js',
            'icon-192.png', 'icon-512.png', 'icon-maskable-512.png',
            'screenshot-1.png', 'screenshot-2.png', 'screenshot-3.png')

# --- 1. 문법 검사: 깨진 스크립트를 배포하면 게임이 검은 화면이 된다 ---
$html = [System.IO.File]::ReadAllText("$root\index.html", [System.Text.Encoding]::UTF8)
$i = 0
foreach ($m in [regex]::Matches($html, '(?s)<script>(.*?)</script>')) {
  $i++
  $tmp = [System.IO.Path]::GetTempFileName() + '.js'
  [System.IO.File]::WriteAllText($tmp, $m.Groups[1].Value, [System.Text.Encoding]::UTF8)
  node --check $tmp
  if ($LASTEXITCODE -ne 0) { throw "index.html 인라인 스크립트 $i 문법 오류 — 배포 중단" }
  Remove-Item $tmp -Force
}
Write-Host "[1/3] 문법 검사 통과 (인라인 스크립트 $($i)개)" -ForegroundColor Green

# --- 2. GitHub Pages ---
if (-not $ItchOnly) {
  if (-not $Message) { throw '커밋 메시지가 필요합니다. -ItchOnly 를 쓰면 커밋을 건너뜁니다.' }
  # git은 경고와 진행 상황을 stderr로 내보내는데, ErrorActionPreference=Stop이 이걸
  # 실패로 오인해 배포가 중간에 끊긴다. git 구간에서는 종료 코드로만 판단한다.
  $ErrorActionPreference = 'Continue'
  git add -A 2>&1 | Out-String | Write-Host
  git commit -m $Message 2>&1 | Out-String | Write-Host
  $committed = $LASTEXITCODE
  git push 2>&1 | Out-String | Write-Host
  $pushed = $LASTEXITCODE
  $ErrorActionPreference = 'Stop'
  if ($committed -ne 0) { throw "git commit 실패 (exit $committed) — 변경사항이 없을 수도 있습니다" }
  if ($pushed -ne 0) { throw "git push 실패 (exit $pushed)" }
  Write-Host '[2/3] GitHub Pages 푸시 완료 (빌드까지 ~1분)' -ForegroundColor Green
} else {
  Write-Host '[2/3] GitHub Pages 건너뜀 (-ItchOnly)' -ForegroundColor DarkGray
}

# --- 3. itch.io ---
# 키는 저장소 밖에 둔다. 여기 하드코딩하면 공개 저장소에 그대로 올라간다.
$keyFile = "$env:USERPROFILE\.butler\api-key.txt"
if (-not (Test-Path $keyFile)) { throw "butler API 키가 없습니다: $keyFile" }
$env:BUTLER_API_KEY = (Get-Content $keyFile -Raw).Trim()

$stage = "$root\dist\itch-stage"
if (Test-Path $stage) { Remove-Item $stage -Recurse -Force }
New-Item -ItemType Directory -Path $stage -Force | Out-Null
$assets | ForEach-Object { Copy-Item "$root\$_" $stage }

& "$env:USERPROFILE\.butler\butler.exe" push $stage sukjae/neon-glide:html
if ($LASTEXITCODE -ne 0) { throw 'butler push 실패' }
Write-Host '[3/3] itch.io 푸시 완료' -ForegroundColor Green
Write-Host ''
Write-Host '  https://csj3814-create.github.io/neon-glide/'
Write-Host '  https://sukjae.itch.io/neon-glide'
