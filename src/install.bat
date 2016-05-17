@echo off&color e
echo.
echo   ****************************************
echo   *                                      *
echo   *                                      *
echo   *          StudNET Auto Reset          *
echo   *             Version: 1.1             *
echo   *                                      *
echo   *        Author: Kevin Shrestha        *
echo   *                                      *
echo   *                                      *
echo   *                                      *
echo   ****************************************

@setlocal enableextensions
@cd /d "%~dp0"
set OLDDIR=%CD%
set XML="%OLDDIR%\StudNETAutoReset.xml"
set profiles=HKEY_LOCAL_MACHINE\software\microsoft\windows nt\currentversion\networklist\Profiles
set /a n=1
set list[1]=0
set guid=Any

SET adminRights=0
FOR /F %%i IN ('WHOAMI /PRIV /NH') DO (
	IF "%%i"=="SeTakeOwnershipPrivilege" SET adminRights=1
)

echo.

IF %adminRights% == 1 (
	GOTO elevated
) ELSE (
	echo Checking for elevated permissions ... FAILED
	echo.
	echo Elevated permissions absent.
	echo This file needs to be run as an Administrator.
	echo.
	echo Close this window, right-click on the file and click "Run as Administrator".
	echo   OR
	echo Log on to an Administrator account and run this file normally. 
	
	echo.
	echo.
	
	copy "%OLDDIR%\StudNET_Reset.bat" "C:\Program Files\StudNET_Reset.bat"
	
	pause >nul
)


:elevated	
	echo Checking for elevated permissions ... SUCCESS
	echo.
	echo Continue Installation?
	echo.
	Pause
	
	CLS
	color 7
	
	echo.
	echo Testing Connection Reset ...
	echo.
	echo.
	taskkill /f /im "studnet.exe"
	echo attempting to start StudNet Client  ...

	if %PROCESSOR_ARCHITECTURE%==x86 (
	  start %windir%\System32\studnet\studnet.exe /auto
	) else (
	  start %windir%\SysWOW64\studnet\studnet.exe /auto
	)
	echo.
	echo testing connection ...
	ping google.com
	echo.
	Pause
	CLS
	explorer.exe shell:::{8E908FC9-BECC-40f6-915B-F4CA0E70D03D}
	echo.
	echo  Searching registry for network profiles ...
	echo.
	echo.
	echo  Network profiles found:
	echo.
	echo  Please select your current network profile. 
	echo  See the Network and Sharing Center for reference
	echo.
	echo.
	
	set profiles=HKEY_LOCAL_MACHINE\software\microsoft\windows nt\currentversion\networklist\Profiles
	set /a n=1
	set list[1]="Any"
	set guid="Any"
	
	setlocal EnableDelayedExpansion

	echo   !n!.	ANY		Attempt a StudNET login when connecting to ANY network

	for /f "delims=" %%a in ('reg query "%profiles%" ^| FIND "{"') do (
		set /a n=n+1	
		for /f "tokens=2,*" %%b in ('reg query "%profiles%\%%~nxa" ^| FIND "ProfileName"') do (
			echo   !n!.	%%c  	%%~nxa  
			set list[!n!]=%%~nxa
		) 
	)
	echo.
	echo.
	echo.
	echo.

	set /p choice="Please select the network profile used by StudNET (1-%n%): "
	set guid=!list[%choice%]!
	echo.
	echo.
	echo.
	
	if %guid%=="Any" (
		Powershell.exe -executionpolicy Unrestricted -File %OLDDIR%\replace.ps1 !name! ANYTEST
		echo You have chosen network profile %choice%:  Any
		set XML="%OLDDIR%\StudNETAutoResetAny.xml"
	) else (
		for /f "tokens=2,*" %%b in ('reg query "%profiles%\%guid%" ^| FIND "ProfileName"') do (
		echo You have chosen network profile %choice%:  %%c
		set guid="!list[%choice%]!"
		set name="%%c"
		)
		Powershell.exe -executionpolicy Unrestricted -File "%OLDDIR%\replace.ps1" !name! !guid!
	)
	

	pause
	CLS
	echo.
	echo.
	echo.
	copy "%OLDDIR%\StudNET_Reset.bat" "C:\Program Files\StudNET_Reset.bat"
	echo.
	echo.
	echo.
	::schtasks /CREATE /XML "%XML%" /TN StudNETAutoReset
	schtasks /CREATE /XML "%OLDDIR%\StudNETAutoReset.xml" /TN StudNETAutoReset
	echo.
	echo.
	echo.
	::start taskschd.msc
	pause
	