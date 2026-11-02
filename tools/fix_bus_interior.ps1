Add-Type -AssemblyName System.Drawing
$assetDir = "C:\Users\Miguel lindo\Downloads\onde_tudo_comecou_etapa4\onde_tudo_comecou\assets"
$tilesDir = Join-Path $assetDir "tiles"

$bmpBusInt = New-Object System.Drawing.Bitmap(320, 180)
$gBusInt = [System.Drawing.Graphics]::FromImage($bmpBusInt)

$bCeil = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 230, 234, 238))
$bWall = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 210, 216, 222))
$bFloor = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 75, 80, 86))
$bWindowSky = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 140, 195, 240))
$bWindowMtn = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 85, 150, 105))

$gBusInt.FillRectangle($bCeil, 0, 0, 320, 30)
$gBusInt.FillRectangle($bWall, 0, 30, 320, 100)
$gBusInt.FillRectangle($bFloor, 0, 130, 320, 50)

for ($w = 0; $w -lt 4; $w++) {
    $wx = 10 + $w * 78
    $gBusInt.FillRectangle($bWindowSky, $wx, 34, 68, 56)
    
    $pts = New-Object System.Drawing.Point[] 5
    $pts[0] = New-Object System.Drawing.Point($wx, 90)
    $pts[1] = New-Object System.Drawing.Point($wx, 70)
    $pts[2] = New-Object System.Drawing.Point(($wx + 34), 52)
    $pts[3] = New-Object System.Drawing.Point(($wx + 68), 65)
    $pts[4] = New-Object System.Drawing.Point(($wx + 68), 90)
    $gBusInt.FillPolygon($bWindowMtn, $pts)

    $pPillar = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 180, 188, 195), 4)
    $gBusInt.DrawRectangle($pPillar, $wx, 34, 68, 56)
}

$bRailYellow = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 245, 190, 20))
$gBusInt.FillRectangle($bRailYellow, 0, 26, 320, 4)
for ($r = 0; $r -lt 5; $r++) {
    $rx = 35 + $r * 65
    $gBusInt.FillRectangle($bRailYellow, $rx, 26, 4, 110)
}

$bSeatFabric = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 38, 92, 160))
$bSeatHeadrest = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 28, 70, 128))
$bSeatLeg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 60, 65, 70))

for ($s = 0; $s -lt 4; $s++) {
    $sx = 15 + $s * 78
    $gBusInt.FillRectangle($bSeatFabric, $sx, 85, 46, 40)
    $gBusInt.FillRectangle($bSeatHeadrest, $sx + 2, 82, 42, 8)
    $gBusInt.FillRectangle($bSeatFabric, $sx, 120, 46, 12)
    $gBusInt.FillRectangle($bSeatLeg, $sx + 6, 132, 4, 16)
    $gBusInt.FillRectangle($bSeatLeg, $sx + 36, 132, 4, 16)
}

$bmpBusInt.Save((Join-Path $tilesDir "bus_interior.png"))
$gBusInt.Dispose(); $bmpBusInt.Dispose()
Write-Host "bus_interior.png gerado perfeitamente sem erros!"
