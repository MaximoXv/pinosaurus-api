¡De una\! 🦖 Vamos a crear un documento de contexto para Pinosaurus, pensado específicamente para que en una conversación futura puedas adjuntármelo y yo pueda recuperar toda la información técnica del proyecto sin que tengas que explicarme nada de nuevo.

Voy a incluir:

- Estructura completa del repositorio.
- Ubicación de las carpetas y archivos.
- URL del repositorio de GitHub.
- Funcionamiento del generador.
- Algoritmo de generación de slugs.
- Estructura y ejemplos de todos los JSON.
- Reglas de ordenamiento e IDs.
- Código completo actual del `.bat` y `.ps1`.
- Consideraciones importantes para futuras modificaciones.

Redacción

# PINOSAURUS API — DOCUMENTACIÓN Y CONTEXTO DEL PROYECTO

**Documento de contexto técnico para futuras conversaciones con ChatGPT.**

- Proyecto: Pinosaurus API
- Repositorio: `MaximoXv/pinosaurus-api`
- Rama principal: `master`
- Tecnología del generador: Windows Batch (.bat) + PowerShell (.ps1)
- Formato de datos: JSON
- Última estructura documentada: API modular con JSON independientes por manga y capítulo.

---

# 1\. OBJETIVO DEL PROYECTO

Pinosaurus es un repositorio de GitHub que almacena imágenes de mangas organizadas por manga, capítulo y página.

El proyecto cuenta con un generador automático que analiza las carpetas originales y construye una API estática compuesta por varios archivos JSON.

El objetivo principal es evitar generar un único JSON demasiado grande que contenga toda la información de todos los mangas, capítulos y páginas.

En su lugar, la API está dividida en tres niveles:

1. Índice general de mangas.
2. Índice de capítulos de cada manga.
3. Páginas individuales de cada capítulo.

Esto permite consultar solamente los datos necesarios.

# 2\. INFORMACIÓN DE GITHUB

**Repositorio:**

https://github.com/MaximoXv/pinosaurus-api

**Rama utilizada:**

`master`

**URL base para acceder a las imágenes originales:**

https://raw.githubusercontent.com/MaximoXv/pinosaurus-api/refs/heads/master/mangas/

Esta URL es fundamental porque el generador la utiliza para construir automáticamente las direcciones de las imágenes.

Ejemplo:

Carpeta original:

`mangas/POKÉMON RED & LEAF/portrait.png`

URL generada:

`https://raw.githubusercontent.com/MaximoXv/pinosaurus-api/refs/heads/master/mangas/POK%C3%89MON%20RED%20%26%20LEAF/portrait.png`

IMPORTANTE: Las imágenes se encuentran en las carpetas originales `mangas/`. Los JSON generados se guardan dentro de `api/`.

No confundir las rutas de almacenamiento de imágenes con las rutas de los archivos JSON.

# 3\. ESTRUCTURA ORIGINAL DEL REPOSITORIO

La estructura de entrada utilizada por el generador es:

text

```text
pinosaurus-api/
│
├── mangas/
│   │
│   ├── Harry Potter Alternative/
│   │   │
│   │   ├── portrait.png
│   │   │
│   │   └── chapters/
│   │       ├── Episode 1 - ...
│   │       │   ├── 1.png
│   │       │   ├── 2.png
│   │       │   └── 3.png
│   │       │
│   │       └── Episode 2 - ...
│   │           ├── 1.png
│   │           └── 2.png
│   │
│   └── POKÉMON RED & LEAF/
│       │
│       ├── portrait.png
│       │
│       └── chapters/
│           ├── Episode 1 - Pallet Town/
│           │   ├── 1.png
│           │   ├── 2.png
│           │   └── 3.png
│           │
│           ├── Episode 2 - Viridian City/
│           │   ├── 1.png
│           │   └── 2.png
│           │
│           └── Episode 3 - Viridian Forest/
│               ├── 1.png
│               └── 2.png
│
├── generate-api.bat
├── generate-api.ps1
│
└── api/
```

## Reglas de las carpetas originales

Cada manga debe tener:

- Una carpeta cuyo nombre será el nombre del manga.
- Un archivo `portrait.png` en la raíz de esa carpeta.
- Una carpeta `chapters`.
- Dentro de `chapters`, una carpeta por capítulo.
- Dentro de cada capítulo, imágenes numeradas en formato PNG.

Ejemplo:

`mangas/POKÉMON RED & LEAF/portrait.png`

`mangas/POKÉMON RED & LEAF/chapters/Episode 1 - Pallet Town/1.png`

`mangas/POKÉMON RED & LEAF/chapters/Episode 1 - Pallet Town/2.png`

Los nombres de los capítulos pueden contener espacios, tildes y caracteres especiales.

# 4\. ESTRUCTURA DE SALIDA DE LA API

El generador construye automáticamente esta estructura:

text

```text
api/
│
├── api.json
│
└── mangas/
    │
    ├── harry-potter-alternative/
    │   ├── chapters.json
    │   ├── 1.json
    │   └── 2.json
    │
    └── pokemon-red-leaf/
        ├── chapters.json
        ├── 1.json
        ├── 2.json
        └── 3.json
```

La carpeta `api/mangas/` contiene una subcarpeta por cada manga.

El nombre de cada subcarpeta es el slug del manga.

Los archivos numéricos representan los capítulos mediante su ID.

# 5\. ESTRUCTURA DE LOS JSON

## 5.1. api/api.json

Es el índice principal de la API.

Contiene exclusivamente la información básica de cada manga.

Ejemplo:

json

```json
[
  {
    "id": 1,
    "order": 1,
    "mangaName": "Harry Potter Alternative",
    "slug": "harry-potter-alternative",
    "imgPortrait": "URL_DEL_PORTRAIT"
  },
  {
    "id": 2,
    "order": 2,
    "mangaName": "POKÉMON RED & LEAF",
    "slug": "pokemon-red-leaf",
    "imgPortrait": "URL_DEL_PORTRAIT"
  }
]
```

### Propiedades

| Propiedad   | Tipo   | Descripción                            |
| ----------- | ------ | -------------------------------------- |
| id          | number | Identificador incremental del manga.   |
| order       | number | Posición del manga.                    |
| mangaName   | string | Nombre original del manga.             |
| slug        | string | Identificador amigable para las rutas. |
| imgPortrait | string | URL de la portada del manga.           |

IMPORTANTE: Este JSON no contiene capítulos ni páginas.

## 5.2. api/mangas/{slug}/chapters.json

Contiene el índice de capítulos de un manga específico.

Ejemplo:

Ruta:

`api/mangas/pokemon-red-leaf/chapters.json`

Contenido:

json

```json
[
  {
    "id": 1,
    "order": 1,
    "chapterName": "Episode 1 - Pallet Town"
  },
  {
    "id": 2,
    "order": 2,
    "chapterName": "Episode 2 - Viridian City"
  },
  {
    "id": 3,
    "order": 3,
    "chapterName": "Episode 3 - Viridian Forest"
  }
]
```

### Propiedades

| Propiedad   | Tipo   | Descripción                                              |
| ----------- | ------ | -------------------------------------------------------- |
| id          | number | Identificador incremental del capítulo dentro del manga. |
| order       | number | Posición del capítulo.                                   |
| chapterName | string | Nombre original del capítulo.                            |

IMPORTANTE: El ID del capítulo coincide con el nombre del archivo JSON que contiene sus páginas.

## 5.3. api/mangas/{slug}/{id}.json

Cada capítulo tiene su propio JSON de páginas.

Ejemplo:

Ruta:

`api/mangas/pokemon-red-leaf/1.json`

Contenido:

json

```json
[
  {
    "order": 1,
    "img": "URL_DE_LA_PAGINA_1"
  },
  {
    "order": 2,
    "img": "URL_DE_LA_PAGINA_2"
  },
  {
    "order": 3,
    "img": "URL_DE_LA_PAGINA_3"
  }
]
```

### Propiedades

| Propiedad | Tipo   | Descripción                         |
| --------- | ------ | ----------------------------------- |
| order     | number | Número de orden de la página.       |
| img       | string | URL absoluta de la imagen original. |

IMPORTANTE: Las páginas no tienen ID propio. Su propiedad `order` representa el número de página.

# 6\. SISTEMA DE SLUGS

El generador tiene una función llamada `Get-Slug`.

Esta función convierte el nombre original de un manga en un identificador compatible con las rutas.

Reglas:

1. Convierte el texto a minúsculas.
2. Elimina los acentos y diacríticos.
3. Reemplaza espacios por guiones.
4. Reemplaza caracteres especiales por guiones.
5. Elimina guiones sobrantes al principio y al final.

Ejemplos:

| Nombre original          | Slug                     |
| ------------------------ | ------------------------ |
| Harry Potter Alternative | harry-potter-alternative |
| POKÉMON RED & LEAF       | pokemon-red-leaf         |
| One Piece                | one-piece                |
| Dragon Ball Z            | dragon-ball-z            |

El slug se utiliza para:

- La propiedad `slug` de `api.json`.
- El nombre de la carpeta correspondiente dentro de `api/mangas/`.
- Construir las rutas para consultar los JSON de cada manga.

El generador también detecta si dos nombres distintos producen el mismo slug y cancela la ejecución para evitar conflictos.

# 7\. SISTEMA DE ORDENAMIENTO E IDS

## Mangas

Los mangas se ordenan alfabéticamente por nombre de carpeta mediante:

`Sort-Object Name`

Los IDs se generan incrementalmente a partir de 1.

Ejemplo:

text

```text
Manga A -> id 1
Manga B -> id 2
Manga C -> id 3
```

Las propiedades `id` y `order` tienen actualmente el mismo valor.

## Capítulos

Los capítulos se ordenan utilizando el número que aparece después de `Episode`.

Ejemplo:

text

```text
Episode 1 - Pallet Town
Episode 2 - Viridian City
Episode 10 - ...
```

El ordenamiento es numérico, no alfabético.

Los IDs de capítulos comienzan en 1 para cada manga.

Ejemplo:

text

```text
Manga A:
  Capítulo 1 -> id 1
  Capítulo 2 -> id 2

Manga B:
  Capítulo 1 -> id 1
  Capítulo 2 -> id 2
```

Los capítulos cuyo nombre no coincide con el patrón `Episode N` se colocan al final.

## Páginas

Las páginas se ordenan numéricamente según el nombre del archivo.

Ejemplo:

text

```text
1.png
2.png
3.png
10.png
```

No se ordenan alfabéticamente.

Actualmente el generador reconoce archivos PNG cuyo nombre base es exclusivamente numérico.

# 8\. FUNCIONAMIENTO DEL GENERADOR

El sistema utiliza dos archivos:

- `generate-api.bat`
- `generate-api.ps1`

## generate-api.bat

Es el archivo que ejecuta el usuario mediante doble clic.

Su función es:

1. Ubicarse en la raíz del repositorio.
2. Ejecutar PowerShell.
3. Ejecutar `generate-api.ps1`.
4. Mostrar si la operación terminó correctamente.
5. Mantener abierta la terminal hasta que el usuario presione una tecla.

## generate-api.ps1

Es el encargado de realizar todo el trabajo.

Sus responsabilidades son:

1. Buscar la carpeta `mangas`.
2. Detectar todos los mangas.
3. Generar los slugs.
4. Detectar los archivos `portrait.png`.
5. Detectar los capítulos.
6. Ordenar los capítulos.
7. Generar `chapters.json`.
8. Detectar las páginas de cada capítulo.
9. Generar un JSON independiente para cada capítulo.
10. Construir el índice general `api.json`.
11. Guardar todos los archivos en UTF-8 sin BOM.
12. Gestionar errores y guardar información en `error-log.txt`.

## Actualización de archivos

En cada ejecución:

- Se conserva la carpeta original `mangas/`.
- Se elimina y reconstruye completamente `api/mangas/`.
- Se sobrescribe `api/api.json`.
- Se eliminan JSON antiguos que ya no correspondan a mangas o capítulos existentes.

IMPORTANTE: No guardar archivos manuales dentro de `api/mangas/`, porque serán eliminados en cada ejecución.

La carpeta `api/` es una carpeta generada automáticamente.

# 9\. CÓDIGO ACTUAL DEL GENERADOR

Los siguientes son los códigos de referencia vigentes del proyecto.

## 9.1. generate-api.bat

bat

```bat
@echo off
title Pinosaurus API Generator
cd /d "%~dp0"

echo ========================================
echo       PINOSAURUS API GENERATOR
echo ========================================
echo.

powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0generate-api.ps1"

set "exitCode=%ERRORLEVEL%"

echo.
echo ========================================
if "%exitCode%"=="0" (
    echo API GENERADA CORRECTAMENTE
) else (
    echo HUBO UN ERROR AL GENERAR LA API
)
echo ========================================
echo.
echo Presiona una tecla para cerrar...
pause > nul
```

## 9.2. generate-api.ps1

powershell

```powershell
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
```

# 10\. EJEMPLOS DE CONSULTA DE LA API

El frontend puede consumir los datos de forma independiente.

## Obtener todos los mangas

javascript

```javascript
const response = await fetch(
  "https://raw.githubusercontent.com/MaximoXv/pinosaurus-api/refs/heads/master/api/api.json",
);

const mangas = await response.json();
```

## Obtener capítulos de un manga

Primero se obtiene el slug del manga seleccionado.

Ejemplo:

`pokemon-red-leaf`

Después:

javascript

```javascript
const response = await fetch(
  "https://raw.githubusercontent.com/MaximoXv/pinosaurus-api/refs/heads/master/api/mangas/pokemon-red-leaf/chapters.json",
);

const chapters = await response.json();
```

## Obtener páginas de un capítulo

Si el capítulo seleccionado tiene ID 1:

javascript

```javascript
const response = await fetch(
  "https://raw.githubusercontent.com/MaximoXv/pinosaurus-api/refs/heads/master/api/mangas/pokemon-red-leaf/1.json",
);

const pages = await response.json();
```

## Consulta dinámica utilizando el slug

javascript

```javascript
const mangaSlug = "pokemon-red-leaf";
const chapterId = 1;

const chaptersUrl = `https://raw.githubusercontent.com/MaximoXv/pinosaurus-api/refs/heads/master/api/mangas/${mangaSlug}/chapters.json`;

const pagesUrl = `https://raw.githubusercontent.com/MaximoXv/pinosaurus-api/refs/heads/master/api/mangas/${mangaSlug}/${chapterId}.json`;
```

IMPORTANTE: Los ejemplos utilizan URLs públicas de GitHub. Los JSON generados deben estar subidos a la rama `master` para poder consultarlos.

# 11\. MANEJO DE ERRORES

El generador utiliza un bloque `try/catch`.

Si ocurre un error:

- Se muestra el error en la terminal.
- Se crea o actualiza `error-log.txt`.
- La ejecución termina con código de error 1.
- El archivo BAT mantiene abierta la terminal para poder visualizar el resultado.

Algunos errores que detecta:

- No existe la carpeta `mangas`.
- Falta `portrait.png`.
- Falta la carpeta `chapters`.
- Dos mangas generan el mismo slug.
- Error al escribir los JSON.
- Problemas de acceso a archivos.

Si la ejecución termina correctamente, elimina el archivo de log anterior.

# 12\. REGLAS PARA FUTURAS MODIFICACIONES

Cuando se soliciten cambios en el generador, respetar las siguientes reglas:

1. Mantener la estructura modular de la API, salvo que se solicite expresamente cambiarla.
2. No volver a incluir capítulos y páginas dentro de `api.json`.
3. Mantener la propiedad `slug` dentro de cada manga.
4. Mantener las URLs de imágenes apuntando a la carpeta original `mangas/`.
5. Mantener el ordenamiento numérico de capítulos y páginas.
6. Mantener los nombres originales de mangas y capítulos.
7. Mantener la codificación UTF-8 sin BOM.
8. Mantener el sistema de errores con `error-log.txt`.
9. Evitar dependencias externas: el generador debe funcionar con Windows PowerShell.
10. Cuando se actualice el generador, proporcionar siempre los archivos `.bat` y `.ps1` completos, listos para copiar y reemplazar.
11. No modificar la estructura original de las carpetas de entrada sin autorización.
12. No eliminar ni modificar archivos originales de imágenes.
13. Recordar que la carpeta `api/mangas/` se reconstruye en cada ejecución.

## Posibles mejoras futuras

Estas son funcionalidades que podrían agregarse posteriormente:

- Soporte para imágenes JPG, JPEG y WEBP.
- Configuración de extensiones permitidas.
- Validación de imágenes faltantes.
- Validación de capítulos sin páginas.
- Generación de un índice de cantidad de capítulos por manga.
- Generación de un índice de cantidad de páginas por capítulo.
- Configuración de orden manual de mangas.
- Configuración de orden manual de capítulos.
- Generación de un archivo de estadísticas.
- Optimización del tiempo de generación.
- Validación automática de las URLs.
- Generación de un README automático.
- Versionado de la API.

Estas mejoras no forman parte de la implementación actual.

# 13\. INSTRUCCIONES PARA CHATGPT EN FUTURAS CONVERSACIONES

Cuando el usuario adjunte este documento en una conversación futura, utilizarlo como contexto técnico del proyecto Pinosaurus API.

No pedir nuevamente información sobre:

- Nombre del repositorio.
- URL base de GitHub.
- Rama utilizada.
- Estructura original de carpetas.
- Estructura de salida de la API.
- Propiedades de los JSON.
- Sistema de slugs.
- Sistema de IDs.
- Funcionamiento actual del BAT y PS1.

Asumir que el estado documentado en este archivo es la última implementación conocida.

Si el usuario solicita una modificación:

1. Comprender primero la estructura existente.
2. Identificar qué archivos deben modificarse.
3. Preservar las funcionalidades que ya funcionan.
4. No introducir cambios innecesarios.
5. Proporcionar los archivos completos y actualizados cuando se solicite código.
6. Explicar brevemente cómo implementar los cambios.
7. Mantener compatibilidad con Windows y PowerShell.

Si el usuario proporciona una versión más reciente de los archivos, priorizar el código real proporcionado por el usuario sobre el código histórico incluido en este documento.

**IMPORTANTE:** Este documento describe el estado conocido del proyecto, no verifica el contenido actual de GitHub. Si se modifica el repositorio fuera de esta conversación, los cambios deben tenerse en cuenta antes de modificar el generador.

---

# FIN DEL DOCUMENTO DE CONTEXTO

Proyecto: PINOSAURUS API\
Repositorio: https://github.com/MaximoXv/pinosaurus-api\
Generador: generate-api.bat + generate-api.ps1\
Salida: api/\
Estado documentado: API modular con índices de mangas, capítulos y páginas independientes.

## Cómo utilizar este documento

1. Copiá el documento y guardalo en la raíz de tu proyecto con el nombre `PINOSAURUS_API_CONTEXT.md`.
2. Conservá ese archivo como documentación permanente.
3. La próxima vez que quieras hacer una modificación, adjuntalo en nuestra conversación.

Con eso voy a tener toda la arquitectura, las rutas, los formatos JSON y el código de referencia para continuar trabajando sin empezar de cero.

Mi recomendación: mantené este documento actualizado cada vez que hagamos un cambio importante en la arquitectura de Pinosaurus. 🦖
