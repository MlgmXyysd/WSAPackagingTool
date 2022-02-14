@Echo off
::
:: Copyright (C) 2002-2022 Jaida Wu (MlgmXyysd) <mlgmxyysd@meowcat.org> All Rights Reserved.
::
title Repack - WSAPackagingTool - MlgmXyysd
echo Repack - WSAPackagingTool v1.1 By MlgmXyysd
echo https://github.com/WSA-Community/WSAPackagingTool
echo *********************************************
echo.
cd /d "%~dp0"
mkdir ".\out" >nul 2>nul
del /f /q ".\libraries\WSA.cer" >nul 2>nul
if not exist ".\temp\AppxMetadata\AppxBundleManifest.xml" (
	echo [#] Error: You need do unpack first.
	goto :EXIT
)
if not exist ".\libraries\signtool.exe" (
	echo [#] Error: Signtool not found.
	goto :EXIT
)
if not exist ".\libraries\makeappx.exe" (
	echo [#] Error: MakeAppx not found.
	goto :EXIT
)
if not exist ".\libraries\install.cmd" (
	echo [#] Error: Installation utility template not found.
	goto :EXIT
)
setlocal ENABLEDELAYEDEXPANSION
pwsh -v >nul 2>nul
if not "%errorlevel%" == "9009" (
	set PS=pwsh -Command
) else (
	echo [#] Error: Repack requires Powershell 6+.
	goto :EXIT
)
setlocal DISABLEDELAYEDEXPANSION
for /F "delims=" %%i in ('%PS% "[xml]$p = Get-Content .\temp\AppxMetadata\AppxBundleManifest.xml; $p.Bundle.Identity.Name"') do (set WSAName=%%i)
for /F "delims=" %%i in ('%PS% "[xml]$p = Get-Content .\temp\AppxMetadata\AppxBundleManifest.xml; $p.Bundle.Identity.Publisher"') do (set WSAPublisher=%%i)
for /F "delims=" %%i in ('%PS% "[xml]$p = Get-Content .\temp\AppxMetadata\AppxBundleManifest.xml; $p.Bundle.Identity.Version"') do (set WSAVersion=%%i)
if not "%WSAName%" == "MicrosoftCorporationII.WindowsSubsystemForAndroid" (
	echo [#] Error: Package unpack project is not WSA.
	goto :LATE_CLEAN
)
if not "%WSAPublisher%" == "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US" (
	echo [#] Error: Package unpack project is provided by unauthenticated publisher.
	goto :LATE_CLEAN
)
if not exist ".\libraries\WSA.pfx" (
	goto :CERT_NOT_FOUND
) else (
	goto :CERT_FOUND
)
:CERT_NOT_FOUND
echo [-] Generating certificate...
for /F "delims=" %%i in ('%PS% "New-SelfSignedCertificate -Type Custom -Subject 'CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US' -KeyUsage DigitalSignature -FriendlyName 'MlgmXyysd WSA Certificate' -CertStoreLocation 'Cert:\CurrentUser\My' -NotAfter (Get-Date).AddYears(233) -TextExtension @('2.5.29.37={text}1.3.6.1.5.5.7.3.3', '2.5.29.19={text}')"') do (set thumbprint=%%i)
set thumbprint=%thumbprint:~0,40%
%PS% "$c=Get-ChildItem -Path 'Cert:\CurrentUser\My\%thumbprint%';$p=ConvertTo-SecureString -String 'mlgmxyysd' -Force -AsPlainText;Export-PfxCertificate -cert $c -FilePath '.\libraries\WSA.pfx' -Password $p; Remove-Item 'Cert:\CurrentUser\My\%thumbprint%'" >nul 2>nul
:CERT_FOUND
echo [-] Checking certificate availability...
%PS% "$p=ConvertTo-SecureString -String 'mlgmxyysd' -Force -AsPlainText;Get-PfxCertificate -FilePath '.\libraries\WSA.pfx' -Password $p|Export-Certificate -FilePath '.\libraries\WSA.cer' -Type CERT" >nul 2>nul
if not exist ".\libraries\WSA.cer" (
	echo [#] Certificate test fail.
	del /f /q ".\libraries\WSA.pfx" >nul 2>nul
	goto :CERT_NOT_FOUND
)
echo [-] Creating msix...
for /F "delims=" %%i in ('%PS% "[xml]$p=Get-Content .\temp\AppxMetadata\AppxBundleManifest.xml;$p.Bundle.Packages.Package.FileName"') do (
	echo [-] Processing %%i...
	if not exist ".\temp\%%i_ext\AppxManifest.xml" (
		echo [#] Error: Incomplete unpack project.
		goto :LATE_CLEAN
	)
	call ".\libraries\makeappx.exe" pack /o /p ".\temp\%%i" /d temp\%%i_ext
	rd /s /q ".\temp\%%i_ext" >nul 2>nul
)
echo [-] Processing msix...
for %%i in (.\temp\*.msix) do (call ".\libraries\signtool.exe" sign /fd sha256 /a /f ".\libraries\WSA.pfx" /p mlgmxyysd "%%~i" >nul 2>nul)
echo [-] Creating msixbundle...
call ".\libraries\makeappx.exe" bundle /o /bv %WSAVersion% /p "out\%WSAName%_%WSAVersion%_repack_mlgmxyysd.msixbundle" /d temp
echo [-] Processing msixbundle...
call ".\libraries\signtool.exe" sign /fd sha256 /a /f ".\libraries\WSA.pfx" /p mlgmxyysd ".\out\%WSAName%_%WSAVersion%_repack_mlgmxyysd.msixbundle" >nul 2>nul
echo [-] Generating installation utility...
call certutil -encode ".\libraries\WSA.cer" ".\libraries\WSA.pem" >nul 2>nul
del /f /q ".\libraries\WSA.cer" >nul 2>nul
%PS% "Get-Content '.\libraries\install.cmd'|foreach{if($_ -eq ':: ----------Certificate----------'){Get-Content '.\libraries\WSA.pem'|foreach{'echo {0}>>\".\WSA.pem\"' -f $_}}else{$_}}" >".\out\install.cmd" 2>nul
del /f /q ".\libraries\WSA.pem" >nul 2>nul
if not "%~1" == "" (
	move /y "out\%WSAName%_%WSAVersion%_repack_mlgmxyysd.msixbundle" "%~1" >nul 2>nul
	set out=%~1
) else (
	set out=out\%WSAName%_%WSAVersion%_repack_mlgmxyysd.msixbundle
)
echo [*] Done, new package is "%out%".
goto :LATE_CLEAN
:LATE_CLEAN
pause
rd /s /q ".\temp" >nul 2>nul
goto :EOF
:EXIT
pause
goto :EOF
