
$ErrorActionPreference = 'Stop'

$logPath = Join-Path $PSScriptRoot 'error-log.txt'

try {
    Write-Host "Buscando mangas..." -ForegroundColor Cyan

    $baseUrl = 'https://raw.githubusercontent.com/MaximoXv/pinosaurus-api/refs/heads/master/mangas/'

    $mangasPath = Join-Path $PSScriptRoot 'mangas'

    if (!(Test-Path -LiteralPath $mangasPath)) {
        throw "No se encontro la carpeta mangas."
    }

    # Obtener todos los mangas
    $mangas = @(
        Get-ChildItem -LiteralPath $mangasPath -Directory |
        Sort-Object Name
    )

    $result = @()
    $mangaOrder = 0

    foreach ($manga in $mangas) {

        $mangaOrder++

        Write-Host ""
        Write-Host "Manga: $($manga.Name)" -ForegroundColor Yellow

        # URL base del manga
        $mangaUrl = $baseUrl + [uri]::EscapeDataString($manga.Name) + '/'

        # Obtener portrait
        $portraitPath = Join-Path $manga.FullName 'portrait.png'

        if (!(Test-Path -LiteralPath $portraitPath)) {
            throw "No se encontro portrait.png en $($manga.Name)"
        }

        $imgPortrait = $mangaUrl + 'portrait.png'

        # Obtener capitulos
        $chaptersPath = Join-Path $manga.FullName 'chapters'

        if (!(Test-Path -LiteralPath $chaptersPath)) {
            throw "No se encontro la carpeta chapters en $($manga.Name)"
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

        $chapterResult = @()
        $chapterOrder = 0

        foreach ($chapter in $chapters) {

            $chapterOrder++

            Write-Host "  Capitulo: $($chapter.Name)" -ForegroundColor Cyan

            $chapterUrl = $mangaUrl +
                'chapters/' +
                [uri]::EscapeDataString($chapter.Name) +
                '/'

            # Obtener paginas PNG
            $pages = @(
                Get-ChildItem -LiteralPath $chapter.FullName -File -Filter '*.png' |
                Where-Object { $_.BaseName -match '^\d+$' } |
                Sort-Object { [int]$_.BaseName } |
                ForEach-Object {
                    @{
                        order = [int]$_.BaseName
                        img = $chapterUrl + [uri]::EscapeDataString($_.Name)
                    }
                }
            )

            $chapterResult += @{
                order = $chapterOrder
                chapterName = $chapter.Name
                pages = $pages
            }
        }

        # Agregar manga al resultado
        $result += @{
            order = $mangaOrder
            mangaName = $manga.Name
            imgPortrait = $imgPortrait
            chapters = $chapterResult
        }
    }

    # Generar JSON
    $json = ConvertTo-Json -InputObject @($result) -Depth 15

    # Guardar UTF-8 sin BOM
    $utf8 = New-Object System.Text.UTF8Encoding($false)

    $outputPath = Join-Path $PSScriptRoot 'api.json'

    [System.IO.File]::WriteAllText(
        $outputPath,
        $json,
        $utf8
    )

    # Eliminar log anterior si todo salio bien
    Remove-Item $logPath -ErrorAction SilentlyContinue

    Write-Host ""
    Write-Host "========================================"
    Write-Host " API.JSON GENERADO CORRECTAMENTE"
    Write-Host "========================================" -ForegroundColor Green

    Write-Host "Mangas: $mangaOrder"
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
