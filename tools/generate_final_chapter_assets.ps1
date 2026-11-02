Add-Type -AssemblyName System.Drawing
$assetDir = "C:\Users\Miguel lindo\Downloads\onde_tudo_comecou_etapa4\onde_tudo_comecou\assets"
$charDir = Join-Path $assetDir "sprites\characters"
$uiDir = Join-Path $assetDir "sprites\ui"
$audioDir = Join-Path $assetDir "audio"

# =========================================================================
# 1. miguel_kneel.png (16x24 px: Miguel kneeling on one knee, facing right)
# =========================================================================
$bmpKneel = New-Object System.Drawing.Bitmap(16, 24)
$gKneel = [System.Drawing.Graphics]::FromImage($bmpKneel)
$gKneel.Clear([System.Drawing.Color]::Transparent)

$bHair = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 30, 25, 22))
$bSkin = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 240, 200, 170))
$bShirt = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 45, 110, 195))
$bPants = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 40, 50, 75))
$bShoes = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 35, 35, 40))
$bEye = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 30, 30, 30))
$bSh = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(80, 0, 0, 0))

# Ground shadow
$gKneel.FillEllipse($bSh, 1, 21, 14, 3)

# Head (lower down because kneeling, y=5..10)
$gKneel.FillRectangle($bHair, 3, 5, 7, 5)
$gKneel.FillRectangle($bSkin, 6, 7, 4, 3)
$gKneel.FillRectangle($bEye, 8, 8, 1, 1)

# Torso (blue shirt, y=10..15)
$gKneel.FillRectangle($bShirt, 3, 10, 6, 6)

# Arms reaching forward (holding Maria's hand)
$gKneel.FillRectangle($bShirt, 7, 11, 4, 2)
$gKneel.FillRectangle($bSkin, 11, 11, 2, 2)

# Kneeling legs (one knee bent forward, other knee on ground)
# Bent front leg (left)
$gKneel.FillRectangle($bPants, 7, 14, 4, 5)
$gKneel.FillRectangle($bShoes, 8, 19, 4, 2)
# Kneeling back leg (right knee on ground)
$gKneel.FillRectangle($bPants, 2, 15, 6, 4)
$gKneel.FillRectangle($bPants, 1, 18, 5, 3)
$gKneel.FillRectangle($bShoes, 0, 20, 4, 2)

$bmpKneel.Save((Join-Path $charDir "miguel_kneel.png"))
$gKneel.Dispose(); $bmpKneel.Dispose()

# =========================================================================
# 2. pixel_star.png (7x7 px sparkling star)
# =========================================================================
$bmpStar = New-Object System.Drawing.Bitmap(7, 7)
$gStar = [System.Drawing.Graphics]::FromImage($bmpStar)
$gStar.Clear([System.Drawing.Color]::Transparent)
$cCore = [System.Drawing.Color]::FromArgb(255, 255, 255, 255)
$cArms = [System.Drawing.Color]::FromArgb(255, 253, 224, 71) # #FDE047
$cDiag = [System.Drawing.Color]::FromArgb(200, 254, 240, 138)

$bmpStar.SetPixel(3, 3, $cCore)
# 4 Cardinal points
$bmpStar.SetPixel(3, 1, $cArms); $bmpStar.SetPixel(3, 2, $cArms)
$bmpStar.SetPixel(3, 4, $cArms); $bmpStar.SetPixel(3, 5, $cArms)
$bmpStar.SetPixel(1, 3, $cArms); $bmpStar.SetPixel(2, 3, $cArms)
$bmpStar.SetPixel(4, 3, $cArms); $bmpStar.SetPixel(5, 3, $cArms)
# 4 Diagonals
$bmpStar.SetPixel(2, 2, $cDiag); $bmpStar.SetPixel(4, 2, $cDiag)
$bmpStar.SetPixel(2, 4, $cDiag); $bmpStar.SetPixel(4, 4, $cDiag)

$bmpStar.Save((Join-Path $uiDir "pixel_star.png"))
$gStar.Dispose(); $bmpStar.Dispose()

# =========================================================================
# 3. confetti.png (8x8 pixel sheet with 4 colorful confetti flakes)
# =========================================================================
$bmpConf = New-Object System.Drawing.Bitmap(8, 8)
$gConf = [System.Drawing.Graphics]::FromImage($bmpConf)
$gConf.Clear([System.Drawing.Color]::Transparent)

# 4 flakes: Gold, Pink/Rose, Sky Blue, Lime/Emerald
$bGold = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 215, 0))
$bRose = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 244, 114, 182))
$bCyan = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 56, 189, 248))
$bGreen = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 74, 222, 128))

$gConf.FillRectangle($bGold, 0, 0, 3, 3)
$gConf.FillRectangle($bRose, 4, 0, 3, 3)
$gConf.FillRectangle($bCyan, 0, 4, 3, 3)
$gConf.FillRectangle($bGreen, 4, 4, 3, 3)
$bmpConf.Save((Join-Path $uiDir "confetti.png"))
$gConf.Dispose(); $bmpConf.Dispose()

# =========================================================================
# 4. Audio: music_love_theme.wav & sparkle.wav
# =========================================================================
$sampleRate = 22050

function Write-WavFile($path, [System.Int16[]]$samples) {
    $fs = [System.IO.File]::Create($path)
    $bw = New-Object System.IO.BinaryWriter($fs)
    
    $byteRate = $sampleRate * 2
    $dataChunkSize = $samples.Length * 2
    $fileSize = 36 + $dataChunkSize
    
    $bw.Write([System.Text.Encoding]::ASCII.GetBytes("RIFF"))
    $bw.Write([int]$fileSize)
    $bw.Write([System.Text.Encoding]::ASCII.GetBytes("WAVE"))
    
    $bw.Write([System.Text.Encoding]::ASCII.GetBytes("fmt "))
    $bw.Write([int]16)
    $bw.Write([int16]1)
    $bw.Write([int16]1)
    $bw.Write([int]$sampleRate)
    $bw.Write([int]$byteRate)
    $bw.Write([int16]2)
    $bw.Write([int16]16)
    
    $bw.Write([System.Text.Encoding]::ASCII.GetBytes("data"))
    $bw.Write([int]$dataChunkSize)
    for ($i = 0; $i -lt $samples.Length; $i++) {
        $bw.Write([int16]$samples[$i])
    }
    $bw.Close(); $fs.Close()
}

# sparkle.wav (0.6s delicate shimmering chime)
$sparkleSamples = New-Object System.Int16[] ([int](0.6 * $sampleRate))
$rnd = New-Object System.Random(77)
for ($i = 0; $i -lt $sparkleSamples.Length; $i++) {
    $t = $i / $sampleRate
    $val = 0.0
    for ($k = 0; $k -lt 5; $k++) {
        $tOff = $k * 0.08
        if ($t -ge $tOff) {
            $dt = $t - $tOff
            $env = [Math]::Exp(-$dt * 12.0)
            $f = 1760.0 + $k * 330.0
            $val += [Math]::Sin(2.0 * [Math]::PI * $f * $dt) * $env * 0.2
        }
    }
    $sparkleSamples[$i] = [int16]($val * 32767)
}
Write-WavFile (Join-Path $audioDir "sparkle.wav") $sparkleSamples

# music_love_theme.wav (16s deeply emotional, loving piano/acoustic progression: Cmaj7 - G/B - Am7 - Fmaj7 - G7sus4)
$loveSec = 16.0
$loveSamples = New-Object System.Int16[] ([int]($loveSec * $sampleRate))
$chordDur = 3.2
$chordsLove = @(
    @(130.8, 164.8, 196.0, 246.9), # Cmaj7 (C, E, G, B)
    @(123.5, 146.8, 196.0, 246.9), # G/B (B, D, G, B)
    @(110.0, 130.8, 164.8, 220.0), # Am7 (A, C, E, G)
    @(87.3, 130.8, 174.6, 220.0),  # Fmaj7 (F, C, F, A)
    @(98.0, 146.8, 196.0, 261.6)   # G7sus (G, D, G, C)
)

for ($i = 0; $i -lt $loveSamples.Length; $i++) {
    $t = $i / $sampleRate
    $cIdx = [Math]::Min([int]($t / $chordDur), 4)
    $chord = $chordsLove[$cIdx]
    $tInChord = $t % $chordDur
    
    # Warm piano bass
    $bassFreq = $chord[0]
    $bass = [Math]::Sin(2.0 * [Math]::PI * $bassFreq * $t) * 0.30 * [Math]::Exp(-$tInChord * 0.8)
    
    # Arpeggio note (every 0.4s)
    $noteIdx = [int]($tInChord / 0.4) % 4
    $freq = $chord[$noteIdx] * 2.0
    $tNote = $tInChord % 0.4
    $envNote = [Math]::Exp(-$tNote * 4.0)
    $piano = ([Math]::Sin(2.0 * [Math]::PI * $freq * $t) + 0.3 * [Math]::Sin(2.0 * [Math]::PI * $freq * 2.0 * $t)) * $envNote * 0.32
    
    # Soft high string pad
    $padFreq = $chord[3] * 2.0
    $pad = [Math]::Sin(2.0 * [Math]::PI * $padFreq * $t) * 0.12
    
    $val = [Math]::Max(-0.95, [Math]::Min(0.95, ($bass + $piano + $pad) * 0.72))
    $loveSamples[$i] = [int16]($val * 32767)
}
Write-WavFile (Join-Path $audioDir "music_love_theme.wav") $loveSamples

Write-Host "Assets do Capitulo Final gerados com sucesso!"
