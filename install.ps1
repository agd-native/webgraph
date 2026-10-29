[CmdletBinding()]
param(
    [string]$Version,
    [string]$InstallDir = (Join-Path $env:LOCALAPPDATA "Programs\AGD-WebGraph")
)

$ErrorActionPreference = "Stop"
$repository = "agd-native/webgraph"

if (-not [Environment]::Is64BitOperatingSystem) {
    throw "AGD WebGraph beta currently supports 64-bit Windows only."
}

if ([string]::IsNullOrWhiteSpace($Version)) {
    $headers = @{ "User-Agent" = "agd-webgraph-installer" }
    $release = Invoke-RestMethod -Uri "https://api.github.com/repos/$repository/releases/latest" -Headers $headers
    $Version = $release.tag_name
}
if (-not $Version.StartsWith("v")) {
    $Version = "v$Version"
}

$target = "x86_64-pc-windows-msvc"
$archive = "agd-webgraph-$Version-$target.zip"
$baseUrl = "https://github.com/$repository/releases/download/$Version"
$tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("agd-webgraph-" + [guid]::NewGuid())
$archivePath = Join-Path $tempDir $archive
$checksumPath = "$archivePath.sha256"

New-Item -ItemType Directory -Path $tempDir | Out-Null
try {
    Write-Host "Downloading AGD WebGraph $Version for $target..."
    Invoke-WebRequest -Uri "$baseUrl/$archive" -OutFile $archivePath
    Invoke-WebRequest -Uri "$baseUrl/$archive.sha256" -OutFile $checksumPath

    $expectedHash = ((Get-Content -LiteralPath $checksumPath -Raw).Trim() -split "\s+")[0]
    $actualHash = (Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).Hash
    if ($actualHash -ine $expectedHash) {
        throw "SHA-256 mismatch for $archive"
    }

    $expanded = Join-Path $tempDir "expanded"
    Expand-Archive -LiteralPath $archivePath -DestinationPath $expanded
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $expanded "agd-webgraph.exe") -Destination $InstallDir -Force
    Copy-Item -LiteralPath (Join-Path $expanded "agd-web-worker.exe") -Destination $InstallDir -Force
} finally {
    Remove-Item -LiteralPath $tempDir -Recurse -Force -ErrorAction SilentlyContinue
}

$serverPath = Join-Path $InstallDir "agd-webgraph.exe"
Write-Host "Installed AGD WebGraph $Version to $InstallDir"
Write-Host "MCP command: $serverPath"
if (($env:Path -split ";") -notcontains $InstallDir) {
    Write-Host "The installer did not modify PATH. Use the absolute MCP command above or add the directory manually."
}
