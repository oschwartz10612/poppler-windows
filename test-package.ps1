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

# Only packaged DLLs and Windows system DLLs may satisfy runtime imports.
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

$attachedPdf = Join-Path ([System.IO.Path]::GetTempPath()) "poppler-attach-$([guid]::NewGuid()).pdf"

try {
    Invoke-Poppler -Executable 'pdfattach.exe' -Arguments @($SamplePdf, $SamplePdf, $attachedPdf)
    Invoke-Poppler -Executable 'pdfdetach.exe' -Arguments @('-list', $SamplePdf)

    foreach ($executable in @(
        'pdffonts.exe',
        'pdfimages.exe',
        'pdfinfo.exe',
        'pdftocairo.exe',
        'pdftohtml.exe',
        'pdftoppm.exe',
        'pdftops.exe',
        'pdftotext.exe',
        'pdfunite.exe'
    )) {
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
    Remove-Item -LiteralPath $attachedPdf -Force -ErrorAction SilentlyContinue
}
