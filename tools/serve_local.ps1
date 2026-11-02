param([int]$Port = 8080)

$localIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" -and $_.IPAddress -notlike "169.254*" }).IPAddress | Select-Object -First 1

$webRoot = Resolve-Path (Join-Path $PSScriptRoot "..\build\web")
if (-not (Test-Path $webRoot)) {
    Write-Error "Pasta build/web não encontrada."
    exit 1
}

$listener = New-Object System.Net.HttpListener
$prefix = "http://localhost:$Port/"
$listener.Prefixes.Add($prefix)
if ($localIP) {
    try {
        $listener.Prefixes.Add("http://${localIP}:$Port/")
    } catch {}
}

$listener.Start()

Write-Host "==========================================================" -ForegroundColor Green
Write-Host "🎮 SERVIDOR WEB LOCAL INICIADO COM SUCESSO!" -ForegroundColor Green
Write-Host "No seu PC acesse:       http://localhost:$Port/" -ForegroundColor Cyan
if ($localIP) {
    Write-Host "No celular (mesmo Wi-Fi): http://${localIP}:$Port/" -ForegroundColor Yellow
}
Write-Host "Pressione Ctrl+C para encerrar o servidor." -ForegroundColor Gray
Write-Host "==========================================================" -ForegroundColor Green

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $req = $context.Request
        $res = $context.Response

        $res.Headers.Add("Cross-Origin-Opener-Policy", "same-origin")
        $res.Headers.Add("Cross-Origin-Embedder-Policy", "require-corp")
        $res.Headers.Add("Access-Control-Allow-Origin", "*")

        $urlPath = $req.Url.LocalPath.TrimStart('/')
        if ([string]::IsNullOrEmpty($urlPath)) { $urlPath = "index.html" }
        $filePath = Join-Path $webRoot $urlPath

        if (Test-Path $filePath -PathType Leaf) {
            $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
            $mime = switch ($ext) {
                ".html" { "text/html; charset=utf-8" }
                ".js"   { "application/javascript" }
                ".wasm" { "application/wasm" }
                ".pck"  { "application/octet-stream" }
                ".png"  { "image/png" }
                ".jpg"  { "image/jpeg" }
                default { "application/octet-stream" }
            }
            $res.ContentType = $mime
            $bytes = [System.IO.File]::ReadAllBytes($filePath)
            $res.ContentLength64 = $bytes.Length
            $res.OutputStream.Write($bytes, 0, $bytes.Length)
        } else {
            $res.StatusCode = 404
        }
        $res.OutputStream.Close()
    }
} finally {
    $listener.Stop()
}
