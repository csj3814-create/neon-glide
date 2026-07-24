# GameDistribution 전용 빌드 생성.
#
# GD는 광고가 필수이고 경쟁 플랫폼 SDK가 들어 있으면 안 된다. 그래서 웹/Play용
# index.html을 손대지 않고, 여기서 CrazyGames SDK 로더를 GD SDK로 바꾼 별도
# 빌드를 찍어낸다. 광고가 재생되는 동안에는 게임 루프와 소리를 멈춰야 하는데,
# 그 제어를 게임 원본의 state/ac/soundOn 변수에 직접 연결한다.
#
#   .\scripts\make-gd-build.ps1
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$GD_GAME_ID = '08e0ff9eee9c4d908b855be29b1846e4'

$html = [System.IO.File]::ReadAllText("$root\index.html", [System.Text.Encoding]::UTF8)

# --- 1. CrazyGames SDK 로더 IIFE → GameDistribution SDK 로더 ---
# GD SDK는 로드 시 window.GD_OPTIONS를 읽는다. onEvent는 광고 시작/종료를
# 게임 스코프에 심어둔 훅(window.__ngAdPause/__ngAdResume)으로 넘긴다.
$gdBlock = @'
// GameDistribution SDK (GD 빌드 전용) — 광고 노출 + 광고 중 게임/소리 일시정지.
window["GD_OPTIONS"] = {
  gameId: "__GD_GAME_ID__",
  onEvent: function (event) {
    if (event.name === "SDK_GAME_PAUSE") { if (window.__ngAdPause) window.__ngAdPause(); }
    else if (event.name === "SDK_GAME_START") { if (window.__ngAdResume) window.__ngAdResume(); }
  }
};
(function () {
  var s = document.createElement('script');
  s.src = 'https://html5.api.gamedistribution.com/main.min.js';
  s.async = true;
  s.onerror = function () {};
  document.head.appendChild(s);
})();
// 재시작 같은 자연스러운 지점에서 전면 광고를 요청한다. 빈도 제한은 GD가 처리한다.
window.__gdShowAd = function () { try { if (window.gdsdk && window.gdsdk.showAd) window.gdsdk.showAd(); } catch (e) {} };
'@ -replace '__GD_GAME_ID__', $GD_GAME_ID

$cgPattern = '(?s)// CrazyGames SDK.*?\r?\n\}\)\(\);'
if ($html -notmatch $cgPattern) { throw 'CrazyGames SDK 블록을 찾지 못했습니다 — index.html 구조가 바뀌었는지 확인' }
$html = [regex]::Replace($html, $cgPattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $gdBlock }, 1)

# --- 2. 시작/재시작 버튼: 게임 스코프에 광고 일시정지 훅을 심고, 재시작 때 광고 노출 ---
# 이 코드는 state/ac/soundOn과 같은 스코프에 있어야 하므로 리스너 등록 지점에 끼워 넣는다.
$startLine  = "  document.getElementById('btn-start').addEventListener('click', e => { e.stopPropagation(); startGame(); });"
$retryLine  = "  document.getElementById('btn-retry').addEventListener('click', e => { e.stopPropagation(); startGame(); });"
if (($html -split [regex]::Escape($startLine)).Count -ne 2) { throw 'btn-start 리스너 라인을 찾지 못했습니다' }
if (($html -split [regex]::Escape($retryLine)).Count -ne 2) { throw 'btn-retry 리스너 라인을 찾지 못했습니다' }

# 줄바꿈(LF/CRLF)에 의존하지 않도록 두 라인을 각각 독립적으로 치환한다.
# (a) 시작 리스너 앞에 광고 훅 정의를 끼워 넣는다 — state/ac/soundOn과 같은 스코프.
$hookLines = @"
  // GameDistribution 광고 훅 — 이 스코프의 state/ac/soundOn에 접근한다
  window.__ngAdPause = function () { try { if (ac && ac.suspend) ac.suspend(); } catch (e) {} if (state === 'play') { window.__ngAdWasPlaying = true; state = 'paused'; } };
  window.__ngAdResume = function () { try { if (ac && soundOn && ac.resume) ac.resume(); } catch (e) {} if (window.__ngAdWasPlaying) { window.__ngAdWasPlaying = false; if (state === 'paused') state = 'play'; } };
$startLine
"@ -replace "`r`n", "`n"
$html = $html.Replace($startLine, $hookLines)
# (b) 재시작 리스너에 광고 노출 호출을 덧붙인다.
$retryNew = "  document.getElementById('btn-retry').addEventListener('click', e => { e.stopPropagation(); startGame(); if (window.__gdShowAd) window.__gdShowAd(); });"
$html = $html.Replace($retryLine, $retryNew)
if ($html -notmatch '__ngAdPause = function' -or $html -notmatch 'startGame\(\); if \(window\.__gdShowAd\)') {
  throw '광고 훅/재시작 주입 검증 실패'
}
if ($html -notmatch 'html5\.api\.gamedistribution\.com' -or $html -match 'sdk\.crazygames\.com') {
  throw 'SDK 교체 검증 실패 (GD 없음 또는 CrazyGames 잔존)'
}

# --- 출력: 빌드 폴더 + zip ---
$out = "$root\dist\gd"
if (Test-Path $out) { Remove-Item $out -Recurse -Force }
New-Item -ItemType Directory -Path $out -Force | Out-Null
[System.IO.File]::WriteAllText("$out\index.html", $html, (New-Object System.Text.UTF8Encoding $false))
'manifest.webmanifest','sw.js','icon-192.png','icon-512.png','icon-maskable-512.png' | ForEach-Object { Copy-Item "$root\$_" $out }

# 인라인 스크립트 문법 검사 — 깨진 빌드를 zip으로 만들지 않는다
$i = 0
foreach ($m in [regex]::Matches($html, '(?s)<script>(.*?)</script>')) {
  $i++
  $tmp = [System.IO.Path]::GetTempFileName() + '.js'
  [System.IO.File]::WriteAllText($tmp, $m.Groups[1].Value, [System.Text.Encoding]::UTF8)
  node --check $tmp
  if ($LASTEXITCODE -ne 0) { throw "GD 빌드 인라인 스크립트 $i 문법 오류" }
  Remove-Item $tmp -Force
}

$zip = "$root\dist\neon-glide-gd.zip"
if (Test-Path $zip) { Remove-Item $zip -Force }
Compress-Archive -Path "$out\*" -DestinationPath $zip
"GD 빌드 생성 완료 (인라인 스크립트 $($i)개 검사 통과)"
"  zip: $zip  ({0:N0} KB)" -f ((Get-Item $zip).Length / 1KB)
"  Game ID: $GD_GAME_ID"
