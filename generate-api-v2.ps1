
$ErrorActionPreference = 'Stop'

$logPath = Join-Path $PSScriptRoot 'error-log.txt'

# ==========================================
# CONFIGURACION
# ==========================================

$baseUrl = 'https://raw.githubusercontent.com/MaximoXv/pinosaurus-api/refs/heads/master/mangas/'

$mangasPath = Join-Path $PSScriptRoot 'mangas'
$outputPath = Join-Path $PSScriptRoot 'api'
$outputMangasPath = Join-Path $outputPath 'mangas'

$utf8 = New-Object System.Text.UTF8Encoding($false)

# ==========================================
# FUNCIONES
# ==========================================

function Write-JsonFile {
    param(
        [string]$Path,
        [object[]]$Data
    )

    $json = ConvertTo-Json -InputObject @($Data) -Depth 15

    [System.IO.File]::WriteAllText(
        $Path,
        $json,
        $utf8
    )
}

function Get-Slug {
    param([string]$Name)

    $normalized = $Name.Normalize(
        [System.Text.NormalizationForm]::FormD
    )

    $normalized = [regex]::Replace(
        $normalized,
        '\p{Mn}',
        ''
    )

    $slug = $normalized.ToLowerInvariant()

    $slug = $slug -replace '[^a-z0-9]+', '-'
    $slug = $slug.Trim('-')

    if ([string]::IsNullOrWhiteSpace($slug)) {
        throw "No se pudo generar un identificador para: $Name"
    }

    return $slug
}

# ==========================================
# GENERADOR
# ==========================================

try {

    Write-Host "Iniciando generacion de API..." -ForegroundColor Cyan

    if (!(Test-Path -LiteralPath $mangasPath)) {
        throw "No se encontro la carpeta mangas."
    }

    # Crear directorios de salida
    if (!(Test-Path -LiteralPath $outputPath)) {
        New-Item -ItemType Directory -Path $outputPath | Out-Null
    }

    # Limpiar archivos anteriores generados
    if (Test-Path -LiteralPath $outputMangasPath) {
        Remove-Item -LiteralPath $outputMangasPath -Recurse -Force
    }

    New-Item -ItemType Directory -Path $outputMangasPath | Out-Null

    # ======================================
    # OBTENER MANGAS
    # ======================================

    $mangas = @(
        Get-ChildItem -LiteralPath $mangasPath -Directory |
        Sort-Object Name
    )

    $apiMangas = @()
    $mangaId = 0
    $usedSlugs = @{}

    foreach ($manga in $mangas) {

        $mangaId++

        Write-Host ""
        Write-Host "MANGA: $($manga.Name)" -ForegroundColor Yellow

        # Generar slug
        $slug = Get-Slug $manga.Name

        if ($usedSlugs.ContainsKey($slug)) {
            throw "Dos mangas generan el mismo slug: $slug"
        }

        $usedSlugs[$slug] = $true

        # URLs
        $mangaUrl = $baseUrl +
            [uri]::EscapeDataString($manga.Name) + '/'

        $portraitPath = Join-Path $manga.FullName 'portrait.png'

        if (!(Test-Path -LiteralPath $portraitPath)) {
            throw "Falta portrait.png en $($manga.Name)"
        }

        $imgPortrait = $mangaUrl + 'portrait.png'

        # Crear carpeta de salida del manga
        $mangaOutputPath = Join-Path $outputMangasPath $slug

        New-Item -ItemType Directory -Path $mangaOutputPath | Out-Null

        # ==================================
        # OBTENER CAPITULOS
        # ==================================

        $chaptersPath = Join-Path $manga.FullName 'chapters'

        if (!(Test-Path -LiteralPath $chaptersPath)) {
            throw "Falta la carpeta chapters en $($manga.Name)"
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

        $chapterList = @()
        $chapterId = 0

        foreach ($chapter in $chapters) {

            $chapterId++

            Write-Host "  CAPITULO: $($chapter.Name)" -ForegroundColor Cyan

            # Agregar capitulo al listado
            $chapterList += @{
                id = $chapterId
                order = $chapterId
                chapterName = $chapter.Name
            }

            # ==================================
            # GENERAR PAGINAS DEL CAPITULO
            # ==================================

            $chapterUrl = $mangaUrl +
                'chapters/' +
                [uri]::EscapeDataString($chapter.Name) + '/'

            $pages = @(
                Get-ChildItem -LiteralPath $chapter.FullName -File -Filter '*.png' |
                Where-Object {
                    $_.BaseName -match '^\d+$'
                } |
                Sort-Object {
                    [int]$_.BaseName
                } |
                ForEach-Object {

                    @{
                        order = [int]$_.BaseName
                        img = $chapterUrl +
                            [uri]::EscapeDataString($_.Name)
                    }
                }
            )

            # Guardar ID.json
            $pagesFile = Join-Path $mangaOutputPath "$chapterId.json"

            Write-JsonFile -Path $pagesFile -Data $pages

            Write-Host "    Paginas: $($pages.Count) -> $chapterId.json" -ForegroundColor Gray
        }

        # ==================================
        # GENERAR CHAPTERS.JSON
        # ==================================

        $chaptersFile = Join-Path $mangaOutputPath 'chapters.json'

        Write-JsonFile -Path $chaptersFile -Data $chapterList

        # ==================================
        # AGREGAR MANGA A API.JSON
        # ==================================

        $apiMangas += @{
            id = $mangaId
            order = $mangaId
            mangaName = $manga.Name
            slug = $slug
            imgPortrait = $imgPortrait
        }

        Write-Host "  Manga completado!" -ForegroundColor Green
    }

    # ======================================
    # GENERAR API.JSON
    # ======================================

    $apiFile = Join-Path $outputPath 'api.json'

    Write-JsonFile -Path $apiFile -Data $apiMangas

    # ======================================
    # FINALIZAR
    # ======================================

    Remove-Item $logPath -ErrorAction SilentlyContinue

    Write-Host ""
    Write-Host "========================================"
    Write-Host " API GENERADA CORRECTAMENTE"
    Write-Host "========================================" -ForegroundColor Green

    Write-Host "Mangas: $($apiMangas.Count)"
    Write-Host "Ubicacion: $outputPath"

}
catch {

    $errorMessage = $_ | Out-String

    $errorMessage | Out-File -FilePath $logPath -Encoding utf8

    Write-Host ""
    Write-Host "========================================"
    Write-Host " ERROR AL GENERAR API"
    Write-Host "========================================" -ForegroundColor Red

    Write-Host $errorMessage -ForegroundColor Red

    Write-Host "Revisa error-log.txt" -ForegroundColor Yellow

    exit 1
}
