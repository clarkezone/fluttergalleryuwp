# Flutter-Gallery UWP
A demo project using Flutter Gallery (https://github.com/flutter/gallery) and leveraging the experimental UWP Flutter Embedder (https://github.com/clarkezone/engine).  Has been tested on Windows 10 desktop, Windows 10x emulator, XBOX.  This is not complete nor production quality; it is for demonstration purposes only and illustrating progress to date on the Flutter UWP experiment.

Make sure you read the section below on building Flutter Windows UWP binaries before attempting to compile the project in the repo.

# Prerequisits

* Visual Studio 2019 Community Edition or better with:
  * UWP workload with optional C++ support enabled
  * C++/WinRT Extension
    * To install, go to Extensions->Manage Extensions, search for
      C++/WinRT, install that extension, and then exit Visual Studio.
* PowerShell with local script execution enabled:
  * `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine`

# Building Flutter Windows UWP experimental binaries

In order to be able to run this project you'll need to compile your own flutter_windows_winrt binaries.

## Setup

Check out the experimental UWP engine fork next to this project:

* `rootdir\fluttergalleryuwp` (this project)
* `rootdir\engine` (from https://github.com/clarkezone/engine)
  * Ensure that you have the `flutter-uwp-feb2021` branch checked out.

(If you use a different layout, you will need to modify
`copy-local-engine.ps1` accordingly.)

## Building

* Follow [the instructions to build the fork](https://github.com/clarkezone/engine#build-instructions)[https://github.com/clarkezone/engine#build-instructions)].
* Once the build is complete, run `.\scripts\copy-local-engine.ps1`
  in this project.

If you rebuild the engine, you will need to re-run `copy-local-engine`.

# Running Flutter Gallery

Once the UWP engine binaries have been copied, open
`src\FlutterGalleryUWP.sln` and run it. (There is currently no
integration with the `flutter` tool.)
