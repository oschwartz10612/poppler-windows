[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string] $PackageRoot,

    [string] $SamplePdf = (Join-Path $PSScriptRoot 'sample.pdf')
)

$ErrorActionPreference = 'Stop'

$binDirectory = Join-Path $PackageRoot 'Library\bin'
if (-not (Test-Path -LiteralPath $binDirectory -PathType Container)) {
    throw "Poppler bin directory not found: $binDirectory"
}

if (-not (Test-Path -LiteralPath $SamplePdf -PathType Leaf)) {
    throw "Sample PDF not found: $SamplePdf"
}

# Remove Conda from DLL lookup so the package has to supply its own dependencies.
$env:PATH = "$binDirectory;$env:SystemRoot\System32;$env:SystemRoot"

function Invoke-Poppler {
    param(
        [Parameter(Mandatory)]
        [string] $Executable,

        [string[]] $Arguments = @()
    )

    $executablePath = Join-Path $binDirectory $Executable
    & $executablePath @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "$Executable failed with exit code $LASTEXITCODE"
    }
}

$versionOnlyExecutables = @(
    'pdffonts.exe',
    'pdfimages.exe',
    'pdfinfo.exe',
    'pdfseparate.exe',
    'pdfsig.exe',
    'pdftocairo.exe',
    'pdftohtml.exe',
    'pdftoppm.exe',
    'pdftops.exe',
    'pdftotext.exe',
    'pdfunite.exe'
)

$requiredExecutables = @(
    'pdfattach.exe',
    'pdfdetach.exe'
) + ($versionOnlyExecutables | Where-Object { $_ -ne 'pdfsig.exe' })

$packagedExecutables = @(
    Get-ChildItem -LiteralPath $binDirectory -Filter 'pdf*.exe' -File |
        Sort-Object Name |
        Select-Object -ExpandProperty Name
)
$knownExecutables = @('pdfattach.exe', 'pdfdetach.exe') + $versionOnlyExecutables
$untestedExecutables = @($packagedExecutables | Where-Object { $_ -notin $knownExecutables })
$missingExecutables = @($requiredExecutables | Where-Object { $_ -notin $packagedExecutables })

if ($untestedExecutables.Count -gt 0) {
    throw "Packaged executables have no test: $($untestedExecutables -join ', ')"
}

if ($missingExecutables.Count -gt 0) {
    throw "Required executables are missing: $($missingExecutables -join ', ')"
}

$workingDirectory = Join-Path ([System.IO.Path]::GetTempPath()) "poppler-test-$([guid]::NewGuid())"
$attachedPdf = Join-Path $workingDirectory 'attached.pdf'
New-Item -ItemType Directory -Path $workingDirectory | Out-Null
Push-Location $workingDirectory

try {
    Invoke-Poppler -Executable 'pdfattach.exe' -Arguments @($SamplePdf, $SamplePdf, $attachedPdf)
    if (-not (Test-Path -LiteralPath $attachedPdf -PathType Leaf) -or
        (Get-Item -LiteralPath $attachedPdf).Length -eq 0) {
        throw 'pdfattach.exe did not produce a non-empty PDF'
    }

    Invoke-Poppler -Executable 'pdfdetach.exe' -Arguments @('-list', $SamplePdf)

    foreach ($executable in $versionOnlyExecutables | Where-Object { $_ -in $packagedExecutables }) {
        Invoke-Poppler -Executable $executable -Arguments @('-v')
    }

    foreach ($library in @('poppler-cpp.dll', 'poppler-glib.dll')) {
        $handle = [System.Runtime.InteropServices.NativeLibrary]::Load(
            (Join-Path $binDirectory $library)
        )
        [System.Runtime.InteropServices.NativeLibrary]::Free($handle)
    }
}
finally {
    Pop-Location
    Remove-Item -LiteralPath $attachedPdf -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $workingDirectory -Force -ErrorAction SilentlyContinue
}
