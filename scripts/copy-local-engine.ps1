# Make sure you structure your flutter engine source along side this project as follows:
# rootdir\engine (from https://github.com/clarkezone/engine)
# rootdir\fluttergalleryuwp

$binarydebugunoptsourcepath = '..\..\engine\src\out\winuwp_debug_unopt\' #debug unopt is very slow but easiest to debug with
#$binarydebugunoptsourcepath = '..\..\engine\src\out\winuwp_debug\' # engine compiled in release mode for faster start, flutter still jit and hence debuggable
$binaryreleasesourcepath = '..\..\engine\src\out\winuwp_release\'

$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$srcdir = Join-Path -Path $PSScriptRoot -ChildPath '..\src' -Resolve 
$targetdir = Join-Path -Path $srcdir -ChildPath 'shared\flutter\ephemeral'
$targetdirbindebug = Join-Path -Path $targetdir -ChildPath 'bin_debug'
$sourcepathdebugunopt = Join-Path -Path $srcdir -ChildPath $binarydebugunoptsourcepath -Resolve -ErrorAction SilentlyContinue

if ((!$sourcepathdebugunopt) -or (!(Test-Path($sourcepathdebugunopt)))) {
    Write-Output "No flutter engine build found.  Please see https://github.com/clarkezone/engine for instructions for building flutter_windows_winrt.dll"
    return
}

if (!(Test-Path($targetdir))) {
    New-Item $targetdir -ItemType Directory
}

$sourcepathrelease = Join-Path -Path $srcdir -ChildPath $binaryreleasesourcepath -Resolve -ErrorAction SilentlyContinue
if (($sourcepathrelease) -and (Test-Path($sourcepathrelease))) {
    Write-Output "Found release build"
    $targetdirbinrelease = Join-Path -Path $targetdir -ChildPath 'bin_release'
    
    
    if (!(Test-Path($targetdirbinrelease))) {
        New-Item $targetdirbinrelease -ItemType Directory
    }

    $fdll = Join-Path -Path $sourcepathrelease -ChildPath 'flutter_windows_winrt.dll'
    $fpdb = Join-Path -Path $sourcepathrelease -ChildPath 'flutter_windows_winrt.dll.pdb'
    $fexp = Join-Path -Path $sourcepathrelease -ChildPath 'flutter_windows_winrt.dll.exp'
    $flib = Join-Path -Path $sourcepathrelease -ChildPath 'flutter_windows_winrt.dll.lib'

    if ((Test-Path($sourcepathrelease))) {
        Write-Host "Copying Engine release binaries from: " $sourcepathrelease
        copy-item $flib $targetdirbinrelease
        copy-item $fdll $targetdirbinrelease
        copy-item $fpdb $targetdirbinrelease
        copy-item $fexp $targetdirbinrelease
    } else {
        Write-Output "No release build found; skipping release binaries"
    }
} else {
    Write-Output "No release build found at: " $sourcepathrelease
}

$fdlld = Join-Path -Path $sourcepathdebugunopt -ChildPath 'flutter_windows_winrt.dll'
$fpdbd = Join-Path -Path $sourcepathdebugunopt -ChildPath 'flutter_windows_winrt.dll.pdb'
$fexpd = Join-Path -Path $sourcepathdebugunopt -ChildPath 'flutter_windows_winrt.dll.exp'
$flibd = Join-Path -Path $sourcepathdebugunopt -ChildPath 'flutter_windows_winrt.dll.lib'

$cwrapper = Join-Path -Path $sourcepathdebugunopt -ChildPath 'cpp_client_wrapper_winrt'
$flutterwindowsh = Join-Path -Path $sourcepathdebugunopt -ChildPath 'flutter_windows.h'
$flutterexport = Join-Path -Path $sourcepathdebugunopt -ChildPath 'flutter_export.h'
$fluttermessenger = Join-Path -Path $sourcepathdebugunopt -ChildPath 'flutter_messenger.h'
$flutterpluginregistar = Join-Path -Path $sourcepathdebugunopt -ChildPath 'flutter_plugin_registrar.h'

if (!(Test-Path($targetdirbindebug))) {
    New-Item $targetdirbindebug -ItemType Directory
}

# Ephemeral
Write-Host "Copying Engine debug binaries from: " $sourcepathdebugunopt "to" $targetdirbindebug
copy-item $flibd $targetdirbindebug
copy-item $fdlld $targetdirbindebug
copy-item $fpdbd $targetdirbindebug
copy-item $fexpd $targetdirbindebug

#source
$includedir = Join-Path -Path $targetdir -ChildPath 'cpp_client_wrapper_winrt\include\flutter'

Copy-Item -Recurse -Force $cwrapper $targetdir
copy-item $flutterwindowsh $targetdir
copy-item $flutterwindowsh $includedir
copy-item $flutterexport $targetdir
copy-item $fluttermessenger $targetdir
copy-item $flutterpluginregistar $targetdir