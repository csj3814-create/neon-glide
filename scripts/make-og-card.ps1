# 소셜 링크 카드(1200x630)를 실제 플레이 스크린샷에서 합성한다.
#
# og:image가 정사각 앱 아이콘이면 summary_large_image 카드에서 잘려 링크 미리보기가
# 게임을 보여주지 못한다. 스크린샷을 그대로 쓰는 것도 안 되는데, 1.91:1이 아니면
# 각 플랫폼이 알아서 위아래를 잘라 HUD가 날아가기 때문이다. 여기서 미리 잘라 맞춘다.
#
#   .\scripts\make-og-card.ps1 promo\screenshot-max-gate49.png
param([string]$Source = 'promo\screenshot-max-gate49.png')

Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$src = Join-Path $root $Source
if (-not (Test-Path $src)) { throw "원본 스크린샷이 없습니다: $src" }

$W = 1200; $H = 630
$in = [System.Drawing.Image]::FromFile($src)
$work = New-Object System.Drawing.Bitmap($in)
$in.Dispose()

# 커서 지우기: 스크린샷에 찍힌 마우스 포인터는 주변 배경색으로 덮는다
$g0 = [System.Drawing.Graphics]::FromImage($work)
$sample = $work.GetPixel(520, 648)
$g0.FillRectangle((New-Object System.Drawing.SolidBrush($sample)), 425, 636, 40, 44)
$g0.Dispose()

# 1.905:1이 되도록 위쪽을 살려 자른다 — 액션(글라이더·꼬리·게이트)이 상단 2/3에 있다
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

# 게임 UI 크롬 지우기: 언어 선택기와 음소거/일시정지 아이콘은 홍보 이미지에서 군더더기다.
# 상단 배경은 거의 단색이라 근처 하늘색을 떠서 덮으면 티가 나지 않는다.
$sky = $bmp.GetPixel(250, 30)
$skyBrush = New-Object System.Drawing.SolidBrush($sky)
$g.FillRectangle($skyBrush, 0, 0, 125, 56)      # 좌상단 언어 선택기
$g.FillRectangle($skyBrush, 1112, 0, 88, 56)    # 우상단 일시정지·음소거

# 하단 스크림: 글자를 얹을 자리를 어둡게 깔아 대비를 확보한다
$scrimTop = 355
$scrim = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
  (New-Object System.Drawing.Point(0, $scrimTop)), (New-Object System.Drawing.Point(0, $H)),
  [System.Drawing.Color]::FromArgb(0, 5, 1, 15), [System.Drawing.Color]::FromArgb(238, 5, 1, 15))
$g.FillRectangle($scrim, 0, $scrimTop, $W, $H - $scrimTop)

# 워드마크 — 게임 타이틀과 같은 시안→마젠타→앰버 그라디언트
$ff = New-Object System.Drawing.FontFamily('Segoe UI')
$path = New-Object System.Drawing.Drawing2D.GraphicsPath
$path.AddString('NEON GLIDE', $ff, [int][System.Drawing.FontStyle]::Bold, 78,
  (New-Object System.Drawing.PointF(58, 432)), [System.Drawing.StringFormat]::GenericTypographic)
foreach ($p in @(@(16, 26), @(9, 48), @(4, 80))) {
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

# 훅 한 문장 — 썸네일 크기에서도 이게 클릭을 만든다
$f1 = New-Object System.Drawing.Font('Segoe UI', 22, [System.Drawing.FontStyle]::Bold)
$g.DrawString('Everyone in the world flies the same course today.',
  $f1, (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(240, 244, 255))), 62, 536)
$f2 = New-Object System.Drawing.Font('Segoe UI', 16, [System.Drawing.FontStyle]::Regular)
$g.DrawString('One button  ·  new course daily  ·  global leaderboard resets 00:00 UTC',
  $f2, (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(150, 162, 205))), 64, 578)

$out = Join-Path $root 'og-card.png'
$bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
"생성: $out  ({0} x {1}, {2:N0} KB)" -f $W, $H, ((Get-Item $out).Length / 1KB)
