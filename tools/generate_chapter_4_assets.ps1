Add-Type -AssemblyName System.Drawing
$assetDir = "C:\Users\Miguel lindo\Downloads\onde_tudo_comecou_etapa4\onde_tudo_comecou\assets"
$tilesDir = Join-Path $assetDir "tiles"
$charDir = Join-Path $assetDir "sprites\characters"
$uiDir = Join-Path $assetDir "sprites\ui"

# =========================================================================
# 1. asphalt_bike_lane.png (64x64 tileable asphalt with white dashed center line)
# =========================================================================
$bmpLane = New-Object System.Drawing.Bitmap(64, 64)
$gLane = [System.Drawing.Graphics]::FromImage($bmpLane)
$cAsphalt = [System.Drawing.Color]::FromArgb(255, 62, 66, 72)
$cAsphaltDark = [System.Drawing.Color]::FromArgb(255, 48, 52, 58)
$cWhiteLine = [System.Drawing.Color]::FromArgb(255, 238, 242, 245)

$gLane.Clear($cAsphalt)
$rnd = New-Object System.Random(42)
for ($i = 0; $i -lt 140; $i++) {
    $x = $rnd.Next(0, 64); $y = $rnd.Next(0, 64)
    $sc = if ($rnd.Next(0, 2) -eq 0) { $cAsphaltDark } else { [System.Drawing.Color]::FromArgb(255, 76, 80, 88) }
    $bmpLane.SetPixel($x, $y, $sc)
}
$bWhite = New-Object System.Drawing.SolidBrush($cWhiteLine)
# Dashed line down the center (lane divider)
$gLane.FillRectangle($bWhite, 30, 0, 4, 18)
$gLane.FillRectangle($bWhite, 30, 32, 4, 18)
$bmpLane.Save((Join-Path $tilesDir "asphalt_bike_lane.png"))
$gLane.Dispose(); $bmpLane.Dispose()

# =========================================================================
# 2. bus_stop.png (32x48 bus stop pole, shelter and blue sign)
# =========================================================================
$bmpStop = New-Object System.Drawing.Bitmap(32, 48)
$gStop = [System.Drawing.Graphics]::FromImage($bmpStop)
$gStop.Clear([System.Drawing.Color]::Transparent)
$bMetal = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 120, 130, 140))
$gStop.FillRectangle($bMetal, 14, 12, 3, 34)
$bSign = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 24, 90, 180))
$bSignBorder = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$gStop.FillRectangle($bSignBorder, 8, 4, 16, 12)
$gStop.FillRectangle($bSign, 9, 5, 14, 10)
$bBusIco = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 230, 80))
$gStop.FillRectangle($bBusIco, 12, 7, 8, 5)
$bRoof = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(220, 75, 115, 145))
$gStop.FillRectangle($bRoof, 2, 12, 28, 3)
$bGlass = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(110, 180, 220, 240))
$gStop.FillRectangle($bGlass, 20, 15, 10, 22)
$bWood = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 139, 90, 43))
$gStop.FillRectangle($bWood, 21, 28, 9, 3)
$bSh = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(80, 0, 0, 0))
$gStop.FillEllipse($bSh, 4, 43, 24, 4)
$bmpStop.Save((Join-Path $tilesDir "bus_stop.png"))
$gStop.Dispose(); $bmpStop.Dispose()

# =========================================================================
# 3. bus_urban.png (84x40 Brazilian urban bus)
# =========================================================================
$bmpBus = New-Object System.Drawing.Bitmap(84, 40)
$gBus = [System.Drawing.Graphics]::FromImage($bmpBus)
$gBus.Clear([System.Drawing.Color]::Transparent)
$bWhiteBus = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 245, 247, 250))
$bBlueBus = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 28, 95, 175))
$bDarkBlue = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 18, 65, 125))
$bWinDark = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 45, 65, 80))
$bWinLight = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 130, 180, 210))

$gBus.FillRectangle($bWhiteBus, 4, 6, 76, 16)
$gBus.FillRectangle($bBlueBus, 4, 22, 76, 10)
$gBus.FillRectangle($bDarkBlue, 4, 30, 76, 2)
$bDest = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 25, 25, 30))
$gBus.FillRectangle($bDest, 56, 7, 22, 4)
$bDestText = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 215, 0))
$gBus.FillRectangle($bDestText, 58, 8, 18, 2)

for ($w = 0; $w -lt 5; $w++) {
    $wx = 8 + $w * 14
    $gBus.FillRectangle($bWinDark, $wx, 11, 11, 10)
    $gBus.FillRectangle($bWinLight, $wx + 1, 12, 9, 3)
}
$gBus.FillRectangle($bWinDark, 74, 10, 5, 12)
$bDoorFrame = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 80, 85, 90))
$gBus.FillRectangle($bDoorFrame, 32, 11, 8, 20)
$gBus.FillRectangle($bWinLight, 33, 13, 3, 7)
$gBus.FillRectangle($bWinLight, 36, 13, 3, 7)

$bHeadlight = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 240, 150))
$bTaillight = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 220, 40, 30))
$gBus.FillRectangle($bHeadlight, 79, 25, 2, 4)
$gBus.FillRectangle($bTaillight, 4, 25, 2, 4)

$bWheelTire = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 30, 32, 35))
$bWheelRim = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 170, 175, 180))
$gBus.FillEllipse($bWheelTire, 14, 27, 12, 12)
$gBus.FillEllipse($bWheelRim, 17, 30, 6, 6)
$gBus.FillEllipse($bWheelTire, 58, 27, 12, 12)
$gBus.FillEllipse($bWheelRim, 61, 30, 6, 6)
$gBus.FillRectangle($bSh, 6, 38, 72, 2)
$bmpBus.Save((Join-Path $tilesDir "bus_urban.png"))
$gBus.Dispose(); $bmpBus.Dispose()

# =========================================================================
# 4. tree_parque.png (48x56 Lush park tree from Itaipava reference)
# =========================================================================
$bmpTree = New-Object System.Drawing.Bitmap(48, 56)
$gTree = [System.Drawing.Graphics]::FromImage($bmpTree)
$gTree.Clear([System.Drawing.Color]::Transparent)
$bTrunk = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 115, 75, 45))
$bTrunkDark = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 80, 50, 30))
$gTree.FillRectangle($bTrunk, 22, 28, 5, 24)
$gTree.FillRectangle($bTrunkDark, 25, 28, 2, 24)

$bLeafDark = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 35, 90, 40))
$bLeafMid = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 50, 130, 55))
$bLeafLight = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 85, 175, 70))
$bLeafHi = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 120, 205, 85))

$gTree.FillEllipse($bLeafDark, 4, 6, 40, 32)
$gTree.FillEllipse($bLeafMid, 8, 4, 32, 28)
$gTree.FillEllipse($bLeafLight, 12, 6, 22, 20)
$gTree.FillEllipse($bLeafHi, 16, 8, 12, 10)
$gTree.FillEllipse($bLeafMid, 2, 14, 18, 18)
$gTree.FillEllipse($bLeafLight, 5, 16, 12, 12)
$gTree.FillEllipse($bLeafMid, 28, 12, 18, 18)
$gTree.FillEllipse($bLeafHi, 30, 14, 12, 12)
$gTree.FillEllipse($bSh, 12, 50, 24, 5)
$bmpTree.Save((Join-Path $tilesDir "tree_parque.png"))
$gTree.Dispose(); $bmpTree.Dispose()

# =========================================================================
# 5. kiosk_wood.png (44x36 wooden park gazebo / kiosk from photo)
# =========================================================================
$bmpKiosk = New-Object System.Drawing.Bitmap(44, 36)
$gK = [System.Drawing.Graphics]::FromImage($bmpKiosk)
$gK.Clear([System.Drawing.Color]::Transparent)
$bRoofWood = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 160, 82, 45))
$bRoofDark = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 115, 55, 30))
$bPostWood = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 139, 90, 43))

$pointsRoof = @(
    (New-Object System.Drawing.Point(22, 2)),
    (New-Object System.Drawing.Point(42, 14)),
    (New-Object System.Drawing.Point(2, 14))
)
$gK.FillPolygon($bRoofWood, $pointsRoof)
$gK.FillRectangle($bRoofDark, 2, 13, 40, 3)
$gK.FillRectangle($bPostWood, 6, 15, 3, 17)
$gK.FillRectangle($bPostWood, 16, 15, 2, 17)
$gK.FillRectangle($bPostWood, 26, 15, 2, 17)
$gK.FillRectangle($bPostWood, 35, 15, 3, 17)
$gK.FillRectangle($bRoofDark, 6, 25, 32, 2)
$gK.FillEllipse($bSh, 4, 31, 36, 4)
$bmpKiosk.Save((Join-Path $tilesDir "kiosk_wood.png"))
$gK.Dispose(); $bmpKiosk.Dispose()

# =========================================================================
# 6. mountain_bg.png (320x90 Petropolis serrana mountain backdrop)
# =========================================================================
$bmpMtn = New-Object System.Drawing.Bitmap(320, 90)
$gM = [System.Drawing.Graphics]::FromImage($bmpMtn)
$gM.Clear([System.Drawing.Color]::Transparent)

$bFarMtn = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(180, 110, 155, 140))
$pointsFar = @(
    (New-Object System.Drawing.Point(0, 90)),
    (New-Object System.Drawing.Point(0, 45)),
    (New-Object System.Drawing.Point(45, 25)),
    (New-Object System.Drawing.Point(100, 40)),
    (New-Object System.Drawing.Point(160, 18)),
    (New-Object System.Drawing.Point(220, 35)),
    (New-Object System.Drawing.Point(280, 15)),
    (New-Object System.Drawing.Point(320, 30)),
    (New-Object System.Drawing.Point(320, 90))
)
$gM.FillPolygon($bFarMtn, $pointsFar)

$bNearMtn = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(220, 70, 120, 80))
$pointsNear = @(
    (New-Object System.Drawing.Point(0, 90)),
    (New-Object System.Drawing.Point(0, 58)),
    (New-Object System.Drawing.Point(70, 42)),
    (New-Object System.Drawing.Point(140, 56)),
    (New-Object System.Drawing.Point(195, 38)),
    (New-Object System.Drawing.Point(260, 50)),
    (New-Object System.Drawing.Point(320, 40)),
    (New-Object System.Drawing.Point(320, 90))
)
$gM.FillPolygon($bNearMtn, $pointsNear)
$bmpMtn.Save((Join-Path $tilesDir "mountain_bg.png"))
$gM.Dispose(); $bmpMtn.Dispose()

# =========================================================================
# 7. bus_interior.png (320x180 Brazilian urban bus passenger view)
# =========================================================================
$bmpBusInt = New-Object System.Drawing.Bitmap(320, 180)
$gBusInt = [System.Drawing.Graphics]::FromImage($bmpBusInt)
# Bus interior ceiling and walls
$bCeil = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 225, 230, 235))
$bWall = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 205, 212, 218))
$bFloor = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 75, 80, 85))
$bWindowSky = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 145, 195, 235))
$bWindowMtn = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 95, 155, 115))

$gBusInt.FillRectangle($bCeil, 0, 0, 320, 30)
$gBusInt.FillRectangle($bWall, 0, 30, 320, 100)
$gBusInt.FillRectangle($bFloor, 0, 130, 320, 50)

# Large panoramic side windows (y=32..90)
for ($w = 0; $w -lt 4; $w++) {
    $wx = 10 + $w * 78
    $gBusInt.FillRectangle($bWindowSky, $wx, 34, 68, 56)
    # Hill in window
    $pointsWinMtn = @(
        (New-Object System.Drawing.Point($wx, 90)),
        (New-Object System.Drawing.Point($wx, 68)),
        (New-Object System.Drawing.Point($wx + 34, 52)),
        (New-Object System.Drawing.Point($wx + 68, 64)),
        (New-Object System.Drawing.Point($wx + 68, 90))
    )
    $gBusInt.FillPolygon($bWindowMtn, $pointsWinMtn)
    # Window pillar
    $pPillar = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 180, 188, 195), 4)
    $gBusInt.DrawRectangle($pPillar, $wx, 34, 68, 56)
}

# Yellow handrails (Barras de apoio amarelas típicas do Brasil)
$bRailYellow = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 245, 190, 20))
$gBusInt.FillRectangle($bRailYellow, 0, 26, 320, 4)
for ($r = 0; $r -lt 5; $r++) {
    $rx = 35 + $r * 65
    $gBusInt.FillRectangle($bRailYellow, $rx, 26, 4, 110)
}

# Bus passenger seats (Bancos duplos de tecido azul)
$bSeatFabric = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 42, 98, 168))
$bSeatHeadrest = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 30, 75, 135))
$bSeatLeg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 60, 65, 70))

for ($s = 0; $s -lt 4; $s++) {
    $sx = 15 + $s * 78
    # Seat back
    $gBusInt.FillRectangle($bSeatFabric, $sx, 85, 46, 40)
    $gBusInt.FillRectangle($bSeatHeadrest, $sx + 2, 82, 42, 8)
    # Seat cushion
    $gBusInt.FillRectangle($bSeatFabric, $sx, 120, 46, 12)
    # Metal legs
    $gBusInt.FillRectangle($bSeatLeg, $sx + 6, 132, 4, 16)
    $gBusInt.FillRectangle($bSeatLeg, $sx + 36, 132, 4, 16)
}
$bmpBusInt.Save((Join-Path $tilesDir "bus_interior.png"))
$gBusInt.Dispose(); $bmpBusInt.Dispose()

# =========================================================================
# 8. Character sheets for family members: family_member_a, b, c (64x96, 16x24 frames)
# =========================================================================
function Make-Family-Sheet($filename, $hairColor, $skinColor, $shirtColor, $pantsColor, $shoesColor) {
    $bmp = New-Object System.Drawing.Bitmap(64, 96)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::Transparent)
    
    $bHair = New-Object System.Drawing.SolidBrush($hairColor)
    $bSkin = New-Object System.Drawing.SolidBrush($skinColor)
    $bShirt = New-Object System.Drawing.SolidBrush($shirtColor)
    $bPants = New-Object System.Drawing.SolidBrush($pantsColor)
    $bShoes = New-Object System.Drawing.SolidBrush($shoesColor)
    $bEye = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 30, 30, 35))

    for ($row = 0; $row -lt 4; $row++) { # 0=down, 1=left, 2=right, 3=up
        for ($col = 0; $col -lt 4; $col++) {
            $x0 = $col * 16
            $y0 = $row * 24
            $legShift = if ($col -eq 1) { 1 } elseif ($col -eq 3) { -1 } else { 0 }

            # Head / Hair
            $g.FillRectangle($bHair, $x0 + 5, $y0 + 2, 6, 6)
            if ($row -ne 3) { # not back
                $g.FillRectangle($bSkin, $x0 + 5, $y0 + 4, 6, 4)
                if ($row -eq 0) { # down
                    $g.FillRectangle($bEye, $x0 + 6, $y0 + 5, 1, 1)
                    $g.FillRectangle($bEye, $x0 + 9, $y0 + 5, 1, 1)
                } elseif ($row -eq 1) { # left
                    $g.FillRectangle($bEye, $x0 + 5, $y0 + 5, 1, 1)
                } elseif ($row -eq 2) { # right
                    $g.FillRectangle($bEye, $x0 + 10, $y0 + 5, 1, 1)
                }
            } else { # up
                $g.FillRectangle($bHair, $x0 + 4, $y0 + 3, 8, 5)
            }

            # Shirt / Torso
            $g.FillRectangle($bShirt, $x0 + 4, $y0 + 8, 8, 7)

            # Pants / Legs
            $g.FillRectangle($bPants, $x0 + 5, $y0 + 15, 3, 5 + $legShift)
            $g.FillRectangle($bPants, $x0 + 8, $y0 + 15, 3, 5 - $legShift)

            # Shoes
            $g.FillRectangle($bShoes, $x0 + 4, $y0 + 20 + $legShift, 4, 2)
            $g.FillRectangle($bShoes, $x0 + 8, $y0 + 20 - $legShift, 4, 2)
        }
    }
    $bmp.Save((Join-Path $charDir $filename))
    $g.Dispose(); $bmp.Dispose()
}

# Family A: Warm paternal/relative figure (Dark hair, olive polo shirt, dark jeans)
Make-Family-Sheet "family_member_a.png" ([System.Drawing.Color]::FromArgb(255, 60, 45, 35)) ([System.Drawing.Color]::FromArgb(255, 240, 200, 170)) ([System.Drawing.Color]::FromArgb(255, 68, 128, 88)) ([System.Drawing.Color]::FromArgb(255, 45, 55, 80)) ([System.Drawing.Color]::FromArgb(255, 40, 40, 40))

# Family B: Warm maternal/relative figure (Brown wavy hair, coral blouse, light slacks)
Make-Family-Sheet "family_member_b.png" ([System.Drawing.Color]::FromArgb(255, 85, 50, 30)) ([System.Drawing.Color]::FromArgb(255, 245, 205, 175)) ([System.Drawing.Color]::FromArgb(255, 215, 95, 85)) ([System.Drawing.Color]::FromArgb(255, 210, 205, 195)) ([System.Drawing.Color]::FromArgb(255, 70, 50, 40))

# Family C: Young sibling/cousin figure (Light brown hair, yellow t-shirt, blue shorts)
Make-Family-Sheet "family_member_c.png" ([System.Drawing.Color]::FromArgb(255, 100, 70, 45)) ([System.Drawing.Color]::FromArgb(255, 245, 205, 175)) ([System.Drawing.Color]::FromArgb(255, 235, 185, 50)) ([System.Drawing.Color]::FromArgb(255, 55, 85, 140)) ([System.Drawing.Color]::FromArgb(255, 230, 230, 230))

Write-Host "Cenarios, veiculos e NPCs gerados com sucesso!"
