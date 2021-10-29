@echo off
::
:: Copyright (C) 2002-2022 MlgmXyysd. <mlgmxyysd@meowcat.org> All Rights Reserved.
::
title Unpack - WSAMsixbundleTool - MlgmXyysd
echo Unpack - WSAMsixbundleTool v1.0 By MlgmXyysd
echo https://github.com/WSA-Community/WSAPackageTool
echo *********************************************
echo.
cd /d "%~dp0"
if not exist ".\libraries\makeappx.exe" (
	echo [!] Error: MakeAppx not found.
	pause
	exit
)
if exist "%~1" (
	if /i "%~x1" == ".msixbundle" (
		echo [-] Cleaning temp file...
		rd /s /q ".\temp" >nul 2>nul
		mkdir ".\temp" >nul 2>nul
		echo [-] Extracting msixbundle...
		call ".\libraries\makeappx.exe" unbundle /p "%~1" /d temp
	) else (
		echo [!] Error: File is not a msixbundle package.
		pause
		goto :LATE_CLEAN
	)
) else (
	echo [!] Error: You need specify a msixbundle package.
	pause
	goto :LATE_CLEAN
)
if not exist ".\temp\AppxMetadata\AppxBundleManifest.xml" (
	echo [!] Error: Malformed msixbundle.
	pause
	goto :LATE_CLEAN
)
for /F "delims=" %%i in ('powershell "[xml]$p=Get-Content .\temp\AppxMetadata\AppxBundleManifest.xml;$p.Bundle.Identity.Name"') do (set WSAName=%%i)
for /F "delims=" %%i in ('powershell "[xml]$p=Get-Content .\temp\AppxMetadata\AppxBundleManifest.xml;$p.Bundle.Identity.Publisher"') do (set WSAPublisher=%%i)
for /F "delims=" %%i in ('powershell "[xml]$p=Get-Content .\temp\AppxMetadata\AppxBundleManifest.xml;$p.Bundle.Identity.Version"') do (set WSAVersion=%%i)
if not "%WSAName%" == "MicrosoftCorporationII.WindowsSubsystemForAndroid" (
	echo [!] Error: Package is not WSA.
	pause
	goto :LATE_CLEAN
)
if not "%WSAPublisher%" == "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US" (
	echo [!] Error: Package is provided by unauthenticated publisher.
	pause
	goto :LATE_CLEAN
)
for /F "delims=" %%i in ('powershell "[xml]$p=Get-Content .\temp\AppxMetadata\AppxBundleManifest.xml;$a=$p.Bundle.Packages.Package|Where-Object{$_.Type -match 'application'}|Where-Object{$_.Architecture -match 'x64'};$a.FileName"') do (set Package_x64=%%i)
for /F "delims=" %%i in ('powershell "[xml]$p=Get-Content .\temp\AppxMetadata\AppxBundleManifest.xml;$a=$p.Bundle.Packages.Package|Where-Object{$_.Type -match 'application'}|Where-Object{$_.Architecture -match 'arm64'};$a.FileName"') do (set Package_arm64=%%i)
if not exist ".\temp\%Package_x64%" (
	echo [!] Error: Incomplete WSA msixbundle package.
	pause
	goto :LATE_CLEAN
)
if not exist ".\temp\%Package_arm64%" (
	echo [!] Error: Incomplete WSA msixbundle package.
	pause
	goto :LATE_CLEAN
)
echo [-] Processing x64 application...
call ".\libraries\makeappx.exe" unpack /p ".\temp\%Package_x64%" /d temp\%Package_x64%_ext
del /f /q ".\temp\%Package_x64%" >nul 2>nul
echo [-] Processing arm64 application...
call ".\libraries\makeappx.exe" unpack /p ".\temp\%Package_arm64%" /d temp\%Package_arm64%_ext
del /f /q ".\temp\%Package_arm64%" >nul 2>nul
echo [*] Now you can do you want to do in "temp".
pause
goto :EOF
:LATE_CLEAN
rd /s /q ".\temp" >nul 2>nul
goto :EOF