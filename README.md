# Flutter-Gallery UWP
A demo project using Flutter Gallery (https://github.com/flutter/gallery) and leveraging the experimental UWP Flutter Embedder (https://github.com/clarkezone/engine).  Has been tested on Windows 10 desktop, Windows 10x emulator, XBOX.  This is not complete nor production quality; it is for demonstration purposes only and illustrating progress to date on the Flutter UWP experiment.

Make sure you read the section below on building Flutter Windows UWP binaries before attempting to compile the project in the repo.

# Prerequisits

* Visual Studio 2019 Community Edition or better
* UWP workload with optional c++ support enabled
* C++/WinRT
* PowerShell with local script execution enabled: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine`
* Flutter Windows UWP binaries

# Building Flutter Windows UWP experimental binaries

In order to be able to run this project you'll need to compile your own flutter_windows_winrt binaries.  There are instructions for that can be here: https://github.com/clarkezone/engine

Recommended layout of projects:

* `rootdir\engine` (from https://github.com/clarkezone/engine)
* `rootdir\fluttergalleryuwp` (this project)
