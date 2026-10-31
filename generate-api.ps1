
$ErrorActionPreference = 'Stop'

$logPath = Join-Path $PSScriptRoot 'error-log.txt'

try {
    Write-Host "Buscando capitulos..." -ForegroundColor Cyan

    $baseUrl = 'https://raw.githubusercontent.com/MaximoXv/pinosaurus-api/refs/heads/master/chapters/'
    $chaptersPath = Join-Path $PSScriptRoot 'chapters'

    if (!(Test-Path -LiteralPath $chaptersPath)) {
        throw "No existe la carpeta chapters."
    }

    $chapters = @(
        Get-ChildItem -LiteralPath $chaptersPath -Directory |
        Sort-Object {
            if ($_.Name -match '^Episode\s+(\d+)') {
                [int]$matches[1]
            } else {
                [int]::MaxValue
            }
        }
    )

    $result = @()
    $chapterOrder = 0

    foreach ($chapter in $chapters) {
        $chapterOrder++

        Write-Host "Procesando: $($chapter.Name)" -ForegroundColor Cyan

        $pages = @(
            Get-ChildItem -LiteralPath $chapter.FullName -File -Filter '*.png' |
            Where-Object { $_.BaseName -match '^\d+$' } |
            Sort-Object { [int]$_.BaseName } |
            ForEach-Object {
                @{
                    order = [int]$_.BaseName
                    img = $baseUrl +
                        [uri]::EscapeDataString($chapter.Name) +
                        '/' +
                        [uri]::EscapeDataString($_.Name)
                }
            }
        )

        $result += @{
            order = $chapterOrder
            chapterName = $chapter.Name
            pages = $pages
        }
    }

    $json = ConvertTo-Json -InputObject @($result) -Depth 10

    $utf8 = New-Object System.Text.UTF8Encoding($false)

    $outputPath = Join-Path $PSScriptRoot 'api.json'

    [System.IO.File]::WriteAllText(
        $outputPath,
        $json,
        $utf8
    )

    Remove-Item $logPath -ErrorAction SilentlyContinue

    Write-Host ""
    Write-Host "========================================"
    Write-Host " API.JSON GENERADO CORRECTAMENTE"
    Write-Host "========================================" -ForegroundColor Green

    Write-Host "Capitulos: $chapterOrder"
    Write-Host "Archivo: $outputPath"
}
catch {
    $errorMessage = $_ | Out-String

    $errorMessage | Out-File -FilePath $logPath -Encoding utf8

    Write-Host ""
    Write-Host "ERROR AL GENERAR API.JSON" -ForegroundColor Red
    Write-Host $errorMessage -ForegroundColor Red

    Write-Host "Se guardo el error en error-log.txt" -ForegroundColor Yellow

    exit 1
}
