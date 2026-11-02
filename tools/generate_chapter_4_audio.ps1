$audioDir = "C:\Users\Miguel lindo\Downloads\onde_tudo_comecou_etapa4\onde_tudo_comecou\assets\audio"
$sampleRate = 22050

function Write-WavFile($path, [System.Int16[]]$samples) {
    $fs = [System.IO.File]::Create($path)
    $bw = New-Object System.IO.BinaryWriter($fs)
    
    $byteRate = $sampleRate * 2 # 1 channel, 16-bit
    $dataChunkSize = $samples.Length * 2
    $fileSize = 36 + $dataChunkSize
    
    # RIFF header
    $bw.Write([System.Text.Encoding]::ASCII.GetBytes("RIFF"))
    $bw.Write([int]$fileSize)
    $bw.Write([System.Text.Encoding]::ASCII.GetBytes("WAVE"))
    
    # fmt chunk
    $bw.Write([System.Text.Encoding]::ASCII.GetBytes("fmt "))
    $bw.Write([int]16) # Subchunk1Size
    $bw.Write([int16]1) # AudioFormat (PCM)
    $bw.Write([int16]1) # NumChannels (Mono)
    $bw.Write([int]$sampleRate)
    $bw.Write([int]$byteRate)
    $bw.Write([int16]2) # BlockAlign
    $bw.Write([int16]16) # BitsPerSample
    
    # data chunk
    $bw.Write([System.Text.Encoding]::ASCII.GetBytes("data"))
    $bw.Write([int]$dataChunkSize)
    
    for ($i = 0; $i -lt $samples.Length; $i++) {
        $bw.Write([int16]$samples[$i])
    }
    
    $bw.Close()
    $fs.Close()
}

# 1. race_beep.wav (0.2s 750Hz beep)
$beepSamples = New-Object System.Int16[] ([int](0.2 * $sampleRate))
for ($i = 0; $i -lt $beepSamples.Length; $i++) {
    $t = $i / $sampleRate
    $env = [Math]::Exp(-$t * 6.0)
    $val = [Math]::Sin(2.0 * [Math]::PI * 750.0 * $t) * 0.7 * $env
    $beepSamples[$i] = [int16]($val * 32767)
}
Write-WavFile (Join-Path $audioDir "race_beep.wav") $beepSamples

# 2. race_go.wav (0.45s 1500Hz high celebratory beep)
$goSamples = New-Object System.Int16[] ([int](0.45 * $sampleRate))
for ($i = 0; $i -lt $goSamples.Length; $i++) {
    $t = $i / $sampleRate
    $env = [Math]::Exp(-$t * 4.0)
    $val = ([Math]::Sin(2.0 * [Math]::PI * 1500.0 * $t) * 0.7 + [Math]::Sin(2.0 * [Math]::PI * 3000.0 * $t) * 0.2) * $env
    $goSamples[$i] = [int16]($val * 32767)
}
Write-WavFile (Join-Path $audioDir "race_go.wav") $goSamples

# 3. bike_bell.wav (0.65s double bell chime ding-ding!)
$bellSamples = New-Object System.Int16[] ([int](0.65 * $sampleRate))
for ($i = 0; $i -lt $bellSamples.Length; $i++) {
    $t = $i / $sampleRate
    $val = 0.0
    if ($t -ge 0 -and $t -lt 0.3) {
        $t1 = $t
        $env1 = [Math]::Exp(-$t1 * 18.0)
        $val += ([Math]::Sin(2.0 * [Math]::PI * 2093.0 * $t1) + [Math]::Sin(2.0 * [Math]::PI * 4186.0 * $t1) * 0.4) * $env1 * 0.5
    }
    if ($t -ge 0.15) {
        $t2 = $t - 0.15
        $env2 = [Math]::Exp(-$t2 * 14.0)
        $val += ([Math]::Sin(2.0 * [Math]::PI * 2637.0 * $t2) + [Math]::Sin(2.0 * [Math]::PI * 5274.0 * $t2) * 0.35) * $env2 * 0.5
    }
    $bellSamples[$i] = [int16]($val * 32767)
}
Write-WavFile (Join-Path $audioDir "bike_bell.wav") $bellSamples

# 4. bus_engine.wav (2.5s loop of gentle bus motor vibration and air hiss)
$busSamples = New-Object System.Int16[] ([int](2.5 * $sampleRate))
$rnd = New-Object System.Random(123)
for ($i = 0; $i -lt $busSamples.Length; $i++) {
    $t = $i / $sampleRate
    $rumble = [Math]::Sin(2.0 * [Math]::PI * 45.0 * $t) * 0.35 + [Math]::Sin(2.0 * [Math]::PI * 90.0 * $t) * 0.25
    $noise = ($rnd.NextDouble() * 2.0 - 1.0) * 0.08
    $val = ($rumble + $noise) * 0.6
    $busSamples[$i] = [int16]($val * 32767)
}
Write-WavFile (Join-Path $audioDir "bus_engine.wav") $busSamples

# 5. music_park_ride.wav (12s sunny acoustic bicycle ride melody in G major)
$parkSec = 12.0
$parkSamples = New-Object System.Int16[] ([int]($parkSec * $sampleRate))
$chordDur = 3.0
$chordsG = @(
    @(196.0, 246.9, 293.7, 370.0), # Gmaj7
    @(164.8, 196.0, 246.9, 293.7), # Em7
    @(130.8, 164.8, 196.0, 246.9), # Cmaj7
    @(146.8, 196.0, 220.0, 261.6)  # D7sus
)
for ($i = 0; $i -lt $parkSamples.Length; $i++) {
    $t = $i / $sampleRate
    $cIdx = [Math]::Min([int]($t / $chordDur), 3)
    $chord = $chordsG[$cIdx]
    $tInChord = $t % $chordDur
    
    $noteIdx = [int]($tInChord / 0.375) % 4
    $freq = $chord[$noteIdx]
    $tNote = $tInChord % 0.375
    $envNote = [Math]::Exp(-$tNote * 7.0)
    
    $bassFreq = $chord[0] / 2.0
    $bass = [Math]::Sin(2.0 * [Math]::PI * $bassFreq * $t) * 0.25 * [Math]::Exp(-$tInChord * 1.2)
    $lead = ([Math]::Sin(2.0 * [Math]::PI * $freq * $t) + 0.35 * [Math]::Sin(2.0 * [Math]::PI * $freq * 2.0 * $t)) * $envNote * 0.35
    $fluteFreq = $chord[3] * 1.5
    $flute = [Math]::Sin(2.0 * [Math]::PI * $fluteFreq * $t) * 0.08
    
    $val = [Math]::Max(-0.95, [Math]::Min(0.95, ($bass + $lead + $flute) * 0.7))
    $parkSamples[$i] = [int16]($val * 32767)
}
Write-WavFile (Join-Path $audioDir "music_park_ride.wav") $parkSamples

# 6. music_bike_race.wav (10s energetic, upbeat friendly competition)
$raceSec = 10.0
$raceSamples = New-Object System.Int16[] ([int]($raceSec * $sampleRate))
$raceChords = @(
    @(220.0, 261.6, 329.6), # Am
    @(174.6, 220.0, 261.6), # F
    @(130.8, 164.8, 196.0), # C
    @(196.0, 246.9, 293.7)  # G
)
for ($i = 0; $i -lt $raceSamples.Length; $i++) {
    $t = $i / $sampleRate
    $cIdx = [Math]::Min([int]($t / 2.5), 3)
    $chord = $raceChords[$cIdx]
    $tInChord = $t % 2.5
    
    $bassT = $t % 0.15625
    $bassEnv = [Math]::Exp(-$bassT * 12.0)
    $bassFreq = $chord[0] / 2.0
    $bass = [Math]::Sin(2.0 * [Math]::PI * $bassFreq * $t) * $bassEnv * 0.4
    
    $leadIdx = [int]($tInChord / 0.3125) % 3
    $leadFreq = $chord[$leadIdx] * 2.0
    $leadT = $tInChord % 0.3125
    $leadEnv = [Math]::Exp(-$leadT * 8.0)
    $lead = ([Math]::Sin(2.0 * [Math]::PI * $leadFreq * $t) + 0.4 * [Math]::Sin(2.0 * [Math]::PI * $leadFreq * 2.0 * $t)) * $leadEnv * 0.3
    
    $hiFreq = $chord[2] * 4.0
    $hi = [Math]::Sin(2.0 * [Math]::PI * $hiFreq * $t) * 0.08
    
    $val = [Math]::Max(-0.95, [Math]::Min(0.95, ($bass + $lead + $hi) * 0.75))
    $raceSamples[$i] = [int16]($val * 32767)
}
Write-WavFile (Join-Path $audioDir "music_bike_race.wav") $raceSamples

# 7. music_family.wav (12s warm, heartfelt piano/guitar chords in F major)
$famSec = 12.0
$famSamples = New-Object System.Int16[] ([int]($famSec * $sampleRate))
$famChords = @(
    @(174.6, 220.0, 261.6, 329.6), # Fmaj7
    @(146.8, 174.6, 220.0, 261.6), # Dm7
    @(116.5, 146.8, 174.6, 220.0), # Bbmaj7
    @(130.8, 164.8, 196.0, 261.6)  # C7
)
for ($i = 0; $i -lt $famSamples.Length; $i++) {
    $t = $i / $sampleRate
    $cIdx = [Math]::Min([int]($t / 3.0), 3)
    $chord = $famChords[$cIdx]
    $tInChord = $t % 3.0
    
    $noteIdx = [int]($tInChord / 0.5) % 4
    $freq = $chord[$noteIdx]
    $tNote = $tInChord % 0.5
    $envNote = [Math]::Exp(-$tNote * 4.5)
    
    $bassFreq = $chord[0] / 2.0
    $bass = [Math]::Sin(2.0 * [Math]::PI * $bassFreq * $t) * 0.28 * [Math]::Exp(-$tInChord * 0.9)
    $piano = ([Math]::Sin(2.0 * [Math]::PI * $freq * $t) + 0.3 * [Math]::Sin(2.0 * [Math]::PI * $freq * 2.0 * $t)) * $envNote * 0.38
    
    $val = [Math]::Max(-0.95, [Math]::Min(0.95, ($bass + $piano) * 0.7))
    $famSamples[$i] = [int16]($val * 32767)
}
Write-WavFile (Join-Path $audioDir "music_family.wav") $famSamples

Write-Host "Todos os 7 efeitos sonoros e musicas do Capitulo 4 gerados com sucesso!"
