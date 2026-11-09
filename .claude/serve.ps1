# Minimal static file server for local testing (no Python/Node needed).
# Usage: pwsh -File .claude/serve.ps1 [port]   serves the repository root on http://localhost:<port>/
param([int]$Port = 8765)
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$types = @{ '.html'='text/html; charset=utf-8'; '.js'='text/javascript; charset=utf-8'; '.css'='text/css';
  '.json'='application/json'; '.csv'='text/csv'; '.png'='image/png'; '.jpg'='image/jpeg'; '.svg'='image/svg+xml';
  '.md'='text/plain; charset=utf-8'; '.txt'='text/plain; charset=utf-8'; '.zip'='application/zip' }
$l = [System.Net.HttpListener]::new()
$l.Prefixes.Add("http://localhost:$Port/")
$l.Start()
Write-Host "Serving $root on http://localhost:$Port/"
while ($l.IsListening) {
  $ctx = $l.GetContext(); $res = $ctx.Response
  try {
    $rel = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath).TrimStart('/')
    $path = [IO.Path]::GetFullPath((Join-Path $root $rel))
    if (Test-Path $path -PathType Container) { $path = Join-Path $path 'index.html' }
    if (-not $path.StartsWith($root) -or -not (Test-Path $path -PathType Leaf)) {
      $res.StatusCode = 404
    } else {
      $ext = [IO.Path]::GetExtension($path).ToLower()
      $res.ContentType = if ($types[$ext]) { $types[$ext] } else { 'application/octet-stream' }
      $bytes = [IO.File]::ReadAllBytes($path)
      $res.ContentLength64 = $bytes.Length
      $res.OutputStream.Write($bytes, 0, $bytes.Length)
    }
    Write-Host "$($res.StatusCode) /$rel"
  } catch { $res.StatusCode = 500 } finally { $res.Close() }
}
