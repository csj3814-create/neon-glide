# GameDistribution 카탈로그 에셋 생성.
#
# GD는 정확한 픽셀 크기의 JPG를 요구한다(PNG 불가). 실제 플레이 화면을 각 비율로
# 잘라 워드마크를 얹어 5장을 찍어낸다. 커서·UI 크롬은 원본에서 먼저 지운다.
#
#   .\scripts\make-gd-assets.ps1
param([string]$Source = 'promo\screenshot-max-gate49.png')

Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$src = Join-Path $root $Source
if (-not (Test-Path $src)) { throw "원본 스크린샷이 없습니다: $src" }

$in = [System.Drawing.Image]::FromFile($src)
$clean = New-Object System.Drawing.Bitmap($in)
$in.Dispose()

# 원본에서 커서와 상단 UI(언어 선택기·음소거)를 배경색으로 덮는다
$g0 = [System.Drawing.Graphics]::FromImage($clean)
$g0.FillRectangle((New-Object System.Drawing.SolidBrush($clean.GetPixel(520, 648))), 420, 632, 46, 50)  # 마우스 커서
$sky = New-Object System.Drawing.SolidBrush($clean.GetPixel(300, 30))
$g0.FillRectangle($sky, 0, 0, 150, 62)                          # 좌상단 언어 선택기
$g0.FillRectangle($sky, ($clean.Width - 150), 0, 150, 62)       # 우상단 음소거/일시정지
$g0.Dispose()

# JPEG 인코더 (품질 90)
$jpg = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
$qual = New-Object System.Drawing.Imaging.EncoderParameters(1)
$qual.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [int64]90)

function Make($w, $h, $file, $wordmark) {
  # 원본을 목표 비율로 중앙 크롭(위쪽 액션을 살림) 후 리사이즈
  $srcRatio = $clean.Width / $clean.Height
  $tgt = $w / $h
  if ($srcRatio -gt $tgt) { $ch = $clean.Height; $cw = [int]($ch * $tgt) } else { $cw = $clean.Width; $ch = [int]($cw / $tgt) }
  $cx = [int](($clean.Width - $cw) / 2)
  $cy = [int](($clean.Height - $ch) * 0.28)   # 위쪽으로 살짝 치우쳐 글라이더/게이트를 담는다

  $bmp = New-Object System.Drawing.Bitmap($w, $h)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.InterpolationMode = 'HighQualityBicubic'
  $g.SmoothingMode = 'AntiAlias'
  $g.TextRenderingHint = 'ClearTypeGridFit'
  $g.DrawImage($clean, (New-Object System.Drawing.Rectangle(0, 0, $w, $h)), $cx, $cy, $cw, $ch, [System.Drawing.GraphicsUnit]::Pixel)

  if ($wordmark) {
    $fs = [Math]::Round($w * 0.095)
    $scrimH = [int]($fs * 2.4)
    $scrim = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
      (New-Object System.Drawing.Point(0, ($h - $scrimH))), (New-Object System.Drawing.Point(0, $h)),
      [System.Drawing.Color]::FromArgb(0, 5, 1, 15), [System.Drawing.Color]::FromArgb(220, 5, 1, 15))
    $g.FillRectangle($scrim, 0, ($h - $scrimH), $w, $scrimH)

    $ff = New-Object System.Drawing.FontFamily('Segoe UI')
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pad = [int]($w * 0.04)
    $baseY = $h - $fs - [int]($fs * 0.35)
    $path.AddString('NEON GLIDE', $ff, [int][System.Drawing.FontStyle]::Bold, $fs,
      (New-Object System.Drawing.PointF($pad, $baseY)), [System.Drawing.StringFormat]::GenericTypographic)
    foreach ($p in @(@([Math]::Max(2, $fs*0.22), 26), @([Math]::Max(1, $fs*0.12), 55))) {
      $g.DrawPath((New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb($p[1], 150, 90, 255), $p[0])), $path)
    }
    $tb = $path.GetBounds()
    $grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
      (New-Object System.Drawing.PointF($tb.Left, 0)), (New-Object System.Drawing.PointF([Math]::Max($tb.Right, $tb.Left + 1), 0)),
      [System.Drawing.Color]::FromArgb(0, 234, 255), [System.Drawing.Color]::FromArgb(255, 200, 80))
    $blend = New-Object System.Drawing.Drawing2D.ColorBlend(3)
    $blend.Colors = @([System.Drawing.Color]::FromArgb(0, 234, 255), [System.Drawing.Color]::FromArgb(255, 60, 200), [System.Drawing.Color]::FromArgb(255, 200, 80))
    $blend.Positions = @(0.0, 0.55, 1.0)
    $grad.InterpolationColors = $blend
    $g.FillPath($grad, $path)
  }

  $out = Join-Path $root ('dist\gd-assets\' + $file)
  $bmp.Save($out, $jpg, $qual)
  $g.Dispose(); $bmp.Dispose()
  "  {0,-22} {1} x {2}  {3:N0} KB" -f $file, $w, $h, ((Get-Item $out).Length / 1KB)
}

$dir = Join-Path $root 'dist\gd-assets'
if (Test-Path $dir) { Remove-Item $dir -Recurse -Force }
New-Item -ItemType Directory -Path $dir -Force | Out-Null

Make 512 384 'thumb-512x384.jpg' $true
Make 512 512 'thumb-512x512.jpg' $true
Make 200 120 'thumb-200x120.jpg' $true
Make 1280 720 'marketing-1280x720.jpg' $true
Make 1280 550 'marketing-1280x550.jpg' $true
$clean.Dispose()
"완료 → dist\gd-assets\"
