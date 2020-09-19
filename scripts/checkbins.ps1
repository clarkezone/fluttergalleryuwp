$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$srcdir = Join-Path -Path $PSScriptRoot -ChildPath '..\src' -Resolve 
$targetdir = Join-Path -Path $srcdir -ChildPath 'shared\flutter\ephemeral'

if (!(Test-Path($targetdir))) {
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    $oReturn=[System.Windows.Forms.Messagebox]::Show("Please read the readme.md.  You haven't installed flutter binaries correctly.")
    exit 1
}

Write-Host "Flutter binaries found"