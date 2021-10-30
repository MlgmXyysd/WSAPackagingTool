@echo off
::
:: Copyright (C) 2002-2022 MlgmXyysd. <mlgmxyysd@meowcat.org> All Rights Reserved.
::
title Install - WSAMsixbundleTool - MlgmXyysd
echo Install - WSAMsixbundleTool v1.0 By MlgmXyysd
echo https://github.com/WSA-Community/WSAPackageTool
echo *********************************************
echo.
cd /d "%~dp0"
if not exist ".\WSA.cer" (
	echo [!] Error: Certificate not found.
	goto :EXIT
)
call pwsh -v >nul 2>nul
if not "%errorlevel%" == "9009" (
	set PS=call pwsh -Command
) else (
	call powershell -v >nul 2>nul
	if not "%errorlevel%" == "9009" (
		set PS=call powershell
	) else (
		echo [!] Error: Powershell not found.
		goto :EXIT
	)
)
set IS_ADMIN=%~1
set CMD_LINE="%~1"
set PACKAGE=%~2
:COMMAND_LINE
shift /1
if "%~1" == "" (
	goto :COMMAND_LINE_DONE
)
set CMD_LINE=%CMD_LINE% "%~1"
goto :COMMAND_LINE
:COMMAND_LINE_DONE
if not "%IS_ADMIN%" == "am_admin" (
	echo [!] Currently running with non Administrator privileges, raising...
	%PS% Start-Process -Verb runAs -FilePath '"%~0"' -ArgumentList 'am_admin %CMD_LINE%'
	goto :EOF
)
shift /1
if exist "%PACKAGE%" (
	echo [-] Installing package...
	%PS% "$r='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock';if(-not(Test-Path -Path $r)){New-Item -Path $r -ItemType Directory -Force};if(-not(Get-ItemProperty -Path $r -Name AllowDevelopmentWithoutDevLicense)){New-ItemProperty -Path $r -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1}else{Set-ItemProperty -Path $r -Name AllowDevelopmentWithoutDevLicense -Value 1}" >nul 2>nul
	certutil -addstore root ".\WSA.cer" >nul 2>nul
	%PS% "Add-AppxPackage '%PACKAGE%'"
	echo [*] Install complete.
	goto :EXIT
) else (
	echo [!] Error: You need specify a valid Msixbundle package.
	goto :EXIT
)
:EXIT
pause
goto :EOF