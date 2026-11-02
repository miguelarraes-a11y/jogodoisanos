Add-Type -AssemblyName System.Drawing
$assetDir = "C:\Users\Miguel lindo\Downloads\onde_tudo_comecou_etapa4\onde_tudo_comecou\assets"
$tilesDir = Join-Path $assetDir "tiles"
$charDir = Join-Path $assetDir "sprites\characters"
$uiDir = Join-Path $assetDir "sprites\ui"

# =========================================================================
# 1. bus_interior.png (320x180 Brazilian urban bus passenger view)
# =========================================================================
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
    [System.Drawing.Point[]]$pts = @(
        (New-Object System.Drawing.Point($wx, 90)),
        (New-Object System.Drawing.Point($wx, 70)),
        (New-Object System.Drawing.Point($wx + 34, 52)),
        (New-Object System.Drawing.Point($wx + 68, 65)),
        (New-Object System.Drawing.Point($wx + 68, 90))
    )
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

# =========================================================================
# 2. Bicycle sprites: miguel_bike.png & maria_bike.png
# 96x96: 4 cols x 4 rows (24x24 px frames).
# Rows: 0=down, 1=left, 2=right, 3=up. Cols: 0..3 pedaling animation
# =========================================================================
function Make-Bike-Sheet($filename, $hairColor, $skinColor, $shirtColor, $pantsColor, $bikeColor, $hasGlasses) {
    $bmp = New-Object System.Drawing.Bitmap(96, 96)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::Transparent)

    $bHair = New-Object System.Drawing.SolidBrush($hairColor)
    $bSkin = New-Object System.Drawing.SolidBrush($skinColor)
    $bShirt = New-Object System.Drawing.SolidBrush($shirtColor)
    $bPants = New-Object System.Drawing.SolidBrush($pantsColor)
    $bBike = New-Object System.Drawing.SolidBrush($bikeColor)
    $bTire = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 30, 32, 35))
    $bMetal = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 185, 190, 195))
    $bGold = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 234, 179, 8)) # #EAB308
    $bEye = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 30, 30, 30))
    $bSh = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(70, 0, 0, 0))

    for ($row = 0; $row -lt 4; $row++) {
        for ($col = 0; $col -lt 4; $col++) {
            $x0 = $col * 24
            $y0 = $row * 24
            # Pedaling leg cycle offset
            $pedalPhase = $col % 4
            $leftPedal = if ($pedalPhase -eq 0) { 1 } elseif ($pedalPhase -eq 2) { -1 } else { 0 }
            $rightPedal = -$leftPedal

            # Ground shadow
            $g.FillEllipse($bSh, $x0 + 3, $y0 + 20, 18, 3)

            if ($row -eq 0) {
                # --- FACING DOWN (FRONT) ---
                # Front Wheel (vertical)
                $g.FillRectangle($bTire, $x0 + 11, $y0 + 15, 2, 8)
                # Fork & Handlebars
                $g.FillRectangle($bMetal, $x0 + 11, $y0 + 11, 2, 5)
                $g.FillRectangle($bBike, $x0 + 7, $y0 + 11, 10, 2)
                # Pedals
                $g.FillRectangle($bMetal, $x0 + 9, $y0 + 17, 6, 1)

                # Rider Torso
                $g.FillRectangle($bShirt, $x0 + 8, $y0 + 7, 8, 5)
                # Rider Head
                $g.FillRectangle($bHair, $x0 + 9, $y0 + 1, 6, 4)
                $g.FillRectangle($bSkin, $x0 + 9, $y0 + 3, 6, 4)
                if ($hasGlasses) {
                    $g.FillRectangle($bGold, $x0 + 9, $y0 + 4, 6, 2)
                }
                $g.FillRectangle($bEye, $x0 + 10, $y0 + 4, 1, 1)
                $g.FillRectangle($bEye, $x0 + 13, $y0 + 4, 1, 1)

                # Rider Legs pedaling
                $g.FillRectangle($bPants, $x0 + 8, $y0 + 12, 3, 4 + $leftPedal)
                $g.FillRectangle($bPants, $x0 + 13, $y0 + 12, 3, 4 + $rightPedal)
            }
            elseif ($row -eq 1) {
                # --- FACING LEFT (SIDEWAYS) ---
                # Left (front) wheel & Right (rear) wheel
                $g.FillEllipse($bTire, $x0 + 3, $y0 + 15, 6, 6)
                $g.FillEllipse($bTire, $x0 + 15, $y0 + 15, 6, 6)
                # Bike frame (triangular lines)
                $pBike = New-Object System.Drawing.Pen($bikeColor, 1)
                $g.DrawLine($pBike, $x0 + 6, $y0 + 17, $x0 + 11, $y0 + 17) # chainstay
                $g.DrawLine($pBike, $x0 + 6, $y0 + 17, $x0 + 10, $y0 + 11) # seatstay
                $g.DrawLine($pBike, $x0 + 11, $y0 + 17, $x0 + 10, $y0 + 11) # seattube
                $g.DrawLine($pBike, $x0 + 11, $y0 + 17, $x0 + 16, $y0 + 12) # downtube
                $g.DrawLine($pBike, $x0 + 10, $y0 + 11, $x0 + 16, $y0 + 12) # toptube
                $g.DrawLine($pBike, $x0 + 16, $y0 + 12, $x0 + 17, $y0 + 17) # fork
                # Handlebar
                $g.FillRectangle($bMetal, $x0 + 14, $y0 + 10, 3, 2)

                # Rider Legs pedaling
                $g.FillRectangle($bPants, $x0 + 9, $y0 + 13, 3, 5 + $leftPedal)

                # Rider Torso (leaning forward)
                $g.FillRectangle($bShirt, $x0 + 10, $y0 + 7, 6, 6)
                # Arms to handlebar
                $g.FillRectangle($bShirt, $x0 + 13, $y0 + 9, 3, 2)
                $g.FillRectangle($bSkin, $x0 + 15, $y0 + 10, 2, 2)

                # Rider Head
                $g.FillRectangle($bHair, $x0 + 9, $y0 + 2, 6, 5)
                $g.FillRectangle($bSkin, $x0 + 8, $y0 + 4, 3, 3)
                if ($hasGlasses) {
                    $g.FillRectangle($bGold, $x0 + 8, $y0 + 4, 3, 2)
                }
                $g.FillRectangle($bEye, $x0 + 8, $y0 + 4, 1, 1)
            }
            elseif ($row -eq 2) {
                # --- FACING RIGHT (SIDEWAYS) ---
                # Left (rear) wheel & Right (front) wheel
                $g.FillEllipse($bTire, $x0 + 3, $y0 + 15, 6, 6)
                $g.FillEllipse($bTire, $x0 + 15, $y0 + 15, 6, 6)
                # Bike frame
                $pBike = New-Object System.Drawing.Pen($bikeColor, 1)
                $g.DrawLine($pBike, $x0 + 6, $y0 + 17, $x0 + 11, $y0 + 17)
                $g.DrawLine($pBike, $x0 + 6, $y0 + 17, $x0 + 10, $y0 + 11)
                $g.DrawLine($pBike, $x0 + 11, $y0 + 17, $x0 + 10, $y0 + 11)
                $g.DrawLine($pBike, $x0 + 11, $y0 + 17, $x0 + 16, $y0 + 12)
                $g.DrawLine($pBike, $x0 + 10, $y0 + 11, $x0 + 16, $y0 + 12)
                $g.DrawLine($pBike, $x0 + 16, $y0 + 12, $x0 + 17, $y0 + 17)
                $g.FillRectangle($bMetal, $x0 + 15, $y0 + 10, 3, 2)

                # Rider Legs pedaling
                $g.FillRectangle($bPants, $x0 + 11, $y0 + 13, 3, 5 + $rightPedal)

                # Rider Torso
                $g.FillRectangle($bShirt, $x0 + 8, $y0 + 7, 6, 6)
                $g.FillRectangle($bShirt, $x0 + 12, $y0 + 9, 3, 2)
                $g.FillRectangle($bSkin, $x0 + 14, $y0 + 10, 2, 2)

                # Rider Head
                $g.FillRectangle($bHair, $x0 + 8, $y0 + 2, 6, 5)
                $g.FillRectangle($bSkin, $x0 + 12, $y0 + 4, 3, 3)
                if ($hasGlasses) {
                    $g.FillRectangle($bGold, $x0 + 12, $y0 + 4, 3, 2)
                }
                $g.FillRectangle($bEye, $x0 + 14, $y0 + 4, 1, 1)
            }
            elseif ($row -eq 3) {
                # --- FACING UP (BACK) ---
                # Rear Wheel
                $g.FillRectangle($bTire, $x0 + 11, $y0 + 15, 2, 8)
                # Frame & Seat
                $g.FillRectangle($bBike, $x0 + 10, $y0 + 12, 4, 4)
                $g.FillRectangle($bMetal, $x0 + 10, $y0 + 11, 4, 2)

                # Rider Legs pedaling
                $g.FillRectangle($bPants, $x0 + 8, $y0 + 12, 3, 4 + $rightPedal)
                $g.FillRectangle($bPants, $x0 + 13, $y0 + 12, 3, 4 + $leftPedal)

                # Rider Torso
                $g.FillRectangle($bShirt, $x0 + 8, $y0 + 7, 8, 5)
                # Rider Head (back of hair)
                $g.FillRectangle($bHair, $x0 + 8, $y0 + 1, 8, 6)
            }
        }
    }
    $bmp.Save((Join-Path $charDir $filename))
    $g.Dispose(); $bmp.Dispose()
}

# Miguel riding bike (Dark hair, casual blue shirt, dark jeans, sporty red bicycle frame)
Make-Bike-Sheet "miguel_bike.png" ([System.Drawing.Color]::FromArgb(255, 30, 25, 22)) ([System.Drawing.Color]::FromArgb(255, 240, 200, 170)) ([System.Drawing.Color]::FromArgb(255, 45, 110, 195)) ([System.Drawing.Color]::FromArgb(255, 40, 50, 75)) ([System.Drawing.Color]::FromArgb(255, 220, 50, 45)) $false

# Maria Fernanda riding bike (Wavy brown hair, green shirt #16A34A, white pants, mint bicycle, shiny golden glasses #EAB308!)
Make-Bike-Sheet "maria_bike.png" ([System.Drawing.Color]::FromArgb(255, 75, 48, 30)) ([System.Drawing.Color]::FromArgb(255, 245, 205, 175)) ([System.Drawing.Color]::FromArgb(255, 22, 163, 74)) ([System.Drawing.Color]::FromArgb(255, 245, 245, 245)) ([System.Drawing.Color]::FromArgb(255, 40, 180, 155)) $true

# =========================================================================
# 3. race_flag.png (16x16 Checkered race flag)
# =========================================================================
$bmpFlag = New-Object System.Drawing.Bitmap(16, 16)
$gFlag = [System.Drawing.Graphics]::FromImage($bmpFlag)
$gFlag.Clear([System.Drawing.Color]::Transparent)
$bBlack = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 30, 30, 30))
$bWhite = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 245, 245, 245))
$bPole = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 180, 180, 180))

$gFlag.FillRectangle($bPole, 2, 2, 2, 13)
for ($y = 0; $y -lt 3; $y++) {
    for ($x = 0; $x -lt 3; $x++) {
        $c = if (($x + $y) % 2 -eq 0) { $bBlack } else { $bWhite }
        $gFlag.FillRectangle($c, 4 + $x * 3, 2 + $y * 3, 3, 3)
    }
}
$bmpFlag.Save((Join-Path $uiDir "race_flag.png"))
$gFlag.Dispose(); $bmpFlag.Dispose()

Write-Host "Sprites de bicicleta e bandeira criados com sucesso!"
