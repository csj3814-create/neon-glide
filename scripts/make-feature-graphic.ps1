# Play 스토어 기능 그래픽(1024x500) 생성.
#
# 스토어 상단에 크게 걸리는 배너다. og 카드(1200x630)와 비율이 달라 그대로 못 쓰고,
# 이 자리는 아이콘/스크린샷과 달리 "무슨 게임인지" 한눈에 설명해야 하므로
# 실제 플레이 프레임 위에 워드마크와 한 줄 훅을 얹는다.
#
#   .\scripts\make-feature-graphic.ps1
param([string]$Source = 'promo\screenshot-max-gate49.png')

Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$src = Join-Path $root $Source
if (-not (Test-Path $src)) { throw "원본 스크린샷이 없습니다: $src" }

$W = 1024; $H = 500
$in = [System.Drawing.Image]::FromFile($src)
$work = New-Object System.Drawing.Bitmap($in)
$in.Dispose()

# 커서 자국 제거 (녹화 화면이라 포인터가 찍혀 있다)
$g0 = [System.Drawing.Graphics]::FromImage($work)
$g0.FillRectangle((New-Object System.Drawing.SolidBrush($work.GetPixel(520, 648))), 425, 636, 40, 44)
$g0.Dispose()

# 2.048:1로 자른다. 액션이 상단에 몰려 있어 위쪽을 살린다.
$cropH = [int]($work.Width / ($W / $H))
$crop = New-Object System.Drawing.Rectangle(0, 0, $work.Width, [Math]::Min($cropH, $work.Height))

$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.InterpolationMode = 'HighQualityBicubic'
$g.SmoothingMode = 'AntiAlias'
$g.TextRenderingHint = 'ClearTypeGridFit'
$g.DrawImage($work, (New-Object System.Drawing.Rectangle(0, 0, $W, $H)),
  $crop.X, $crop.Y, $crop.Width, $crop.Height, [System.Drawing.GraphicsUnit]::Pixel)
$work.Dispose()

# 게임 UI 크롬 제거 — 배너에 언어 선택기나 음소거 버튼이 보이면 스크린샷 티가 난다
$sky = $bmp.GetPixel(220, 26)
$skyBrush = New-Object System.Drawing.SolidBrush($sky)
$g.FillRectangle($skyBrush, 0, 0, 108, 48)
$g.FillRectangle($skyBrush, 948, 0, 76, 48)

# 좌측을 어둡게 깔아 글자를 얹는다. Play는 배너 위에 앱 이름을 겹쳐 그리는 경우가 있어
# 아래쪽 1/4은 비교적 비워 둔다.
$scrim = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
  (New-Object System.Drawing.Point(0, 0)), (New-Object System.Drawing.Point($W, 0)),
  [System.Drawing.Color]::FromArgb(242, 5, 1, 15), [System.Drawing.Color]::FromArgb(0, 5, 1, 15))
$g.FillRectangle($scrim, 0, 0, [int]($W * 0.72), $H)

# 워드마크 — 게임 타이틀과 같은 시안→마젠타→앰버
$ff = New-Object System.Drawing.FontFamily('Segoe UI')
$path = New-Object System.Drawing.Drawing2D.GraphicsPath
$path.AddString('NEON GLIDE', $ff, [int][System.Drawing.FontStyle]::Bold, 68,
  (New-Object System.Drawing.PointF(56, 150)), [System.Drawing.StringFormat]::GenericTypographic)
foreach ($p in @(@(15, 28), @(8, 52), @(4, 85))) {
  $g.DrawPath((New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb($p[1], 150, 90, 255), $p[0])), $path)
}
$tb = $path.GetBounds()
$grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
  (New-Object System.Drawing.PointF($tb.Left, 0)), (New-Object System.Drawing.PointF($tb.Right, 0)),
  [System.Drawing.Color]::FromArgb(0, 234, 255), [System.Drawing.Color]::FromArgb(255, 200, 80))
$blend = New-Object System.Drawing.Drawing2D.ColorBlend(3)
$blend.Colors = @([System.Drawing.Color]::FromArgb(0, 234, 255),
                  [System.Drawing.Color]::FromArgb(255, 60, 200),
                  [System.Drawing.Color]::FromArgb(255, 200, 80))
$blend.Positions = @(0.0, 0.55, 1.0)
$grad.InterpolationColors = $blend
$g.FillPath($grad, $path)

# 훅 두 줄
$f1 = New-Object System.Drawing.Font('Segoe UI', 19, [System.Drawing.FontStyle]::Bold)
$g.DrawString('Everyone in the world flies', $f1,
  (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(240, 244, 255))), 60, 246)
$g.DrawString('the same course today.', $f1,
  (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(240, 244, 255))), 60, 278)
$f2 = New-Object System.Drawing.Font('Segoe UI', 14, [System.Drawing.FontStyle]::Regular)
$g.DrawString('One button  ·  new course daily  ·  global leaderboard', $f2,
  (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(152, 164, 208))), 62, 322)

$out = Join-Path $root 'feature-graphic.png'
$bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
"생성: $out  ({0} x {1}, {2:N0} KB)" -f $W, $H, ((Get-Item $out).Length / 1KB)
