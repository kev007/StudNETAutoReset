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

@cd /d "%~dp0"

SET adminRights=0
FOR /F %%i IN ('WHOAMI /PRIV /NH') DO (
	IF "%%i"=="SeTakeOwnershipPrivilege" SET adminRights=1
)
echo.
IF %adminRights% == 1 (
	echo.
	echo Checking for elevated permissions ... SUCCESS
	echo.
	echo Continue UNINSTALL?

	schtasks /DELETE /TN StudNETAutoReset
	ERASE "C:\Program Files\StudNET_Reset.bat"
	Pause
	
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

ERASE "C:\Program Files\StudNET_Reset.bat"

pause >nul
)