@echo off
::
:: Copyright (C) 2002-2022 Jaida Wu (MlgmXyysd) <mlgmxyysd@meowcat.org> All Rights Reserved.
::
title Unpack - WSAPackagingTool - MlgmXyysd
echo Unpack - WSAPackagingTool v1.3 By MlgmXyysd
echo https://github.com/WSA-Community/WSAPackagingTool
echo *********************************************
echo.
echo [-] Initializing...
set ARCH_X64=
if /i "%PROCESSOR_ARCHITECTURE%" == "AMD64" set ARCH_X64=true
if /i "%PROCESSOR_ARCHITECTURE%" == "IA64" set ARCH_X64=true
if /i "%PROCESSOR_ARCHITECTURE%" == "X64" set ARCH_X64=true
if /i "%PROCESSOR_ARCHITECTURE%" == "EM64T" set ARCH_X64=true
if defined ARCH_X64 (
	set LIB_PATH=x64
) else (
	if /i "%PROCESSOR_ARCHITECTURE%" == "X86" (
		set LIB_PATH=x86
	) else (
		if /i "%PROCESSOR_ARCHITECTURE%" == "ARM64" (
			set LIB_PATH=arm64
		) else (
			if /i "%PROCESSOR_ARCHITECTURE%" == "ARM" (
				echo [*] Warning: ARM architecture detected, but not implemented.
				echo [*] Warning: Attempt to use x86, which may cause unknown problems.
				:: set LIB_PATH=arm
				set LIB_PATH=x86
			) else (
				echo [*] Warning: Unknown system architecture.
				echo [*] Warning: Attempt to use x86, which may cause unknown problems.
				echo [*] Warning: Please send feedback this architecture to Issues: %PROCESSOR_ARCHITECTURE%
				set LIB_PATH=x86
			)
		)
	)
)
cd /d "%~dp0"
if not exist ".\libraries\%LIB_PATH%\makeappx.exe" (
	echo [#] Error: MakeAppx not found.
	goto :EXIT
)
setlocal ENABLEDELAYEDEXPANSION
pwsh -v >nul 2>nul
if not "%errorlevel%" == "9009" (
	set PS=call pwsh -Command
) else (
	powershell -v >nul 2>nul
	if not "!errorlevel!" == "9009" (
		set PS=call powershell
	) else (
		echo [#] Error: Powershell not found.
		goto :EXIT
	)
)
setlocal DISABLEDELAYEDEXPANSION
if not exist "%~1" (
	echo [#] Error: You need specify a valid Msixbundle package.
	goto :EXIT
)
if /i not "%~x1" == ".msixbundle" (
	echo [#] Error: File is not a Msixbundle package.
	goto :EXIT
)
echo [-] Cleaning temp file...
rd /s /q ".\temp" >nul 2>nul
mkdir ".\temp" >nul 2>nul
echo [-] Extracting msixbundle...
call ".\libraries\%LIB_PATH%\makeappx.exe" unbundle /p "%~1" /d temp
if not exist ".\temp\AppxMetadata\AppxBundleManifest.xml" (
	echo [#] Error: Malformed msixbundle.
	goto :LATE_CLEAN
)
for /F "delims=" %%i in ('%PS% "[xml]$p=Get-Content .\temp\AppxMetadata\AppxBundleManifest.xml;$p.Bundle.Identity.Name"') do (set WSAName=%%i)
for /F "delims=" %%i in ('%PS% "[xml]$p=Get-Content .\temp\AppxMetadata\AppxBundleManifest.xml;$p.Bundle.Identity.Publisher"') do (set WSAPublisher=%%i)
for /F "delims=" %%i in ('%PS% "[xml]$p=Get-Content .\temp\AppxMetadata\AppxBundleManifest.xml;$p.Bundle.Identity.Version"') do (set WSAVersion=%%i)
if not "%WSAName%" == "MicrosoftCorporationII.WindowsSubsystemForAndroid" (
	echo [#] Error: Package is not WSA.
	goto :LATE_CLEAN
)
if not "%WSAPublisher%" == "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US" (
	echo [#] Error: Package is provided by unauthenticated publisher.
	goto :LATE_CLEAN
)
for /F "delims=" %%i in ('%PS% "[xml]$p=Get-Content .\temp\AppxMetadata\AppxBundleManifest.xml;$p.Bundle.Packages.Package.FileName"') do (
	echo [-] Processing %%i...
	if not exist ".\temp\%%i" (
		echo [#] Error: Incomplete Msixbundle package.
		goto :LATE_CLEAN
	)
	call ".\libraries\%LIB_PATH%\makeappx.exe" unpack /p ".\temp\%%i" /d temp\%%i_ext
	del /f /q ".\temp\%%i" >nul 2>nul
)
echo [*] Now you can do you what you want to do in "temp".
goto :EXIT
:LATE_CLEAN
pause
rd /s /q ".\temp" >nul 2>nul
goto :EOF
:EXIT
pause
goto :EOF
