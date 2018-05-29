@echo off
REM This batch is used to trigger its shell script
REM .bat supports drag-and-drop but not .sh

:config
REM Add this line to avoid changes in cd path
cd /d "%~dp0"
SET sh=LFS_GUI.sh

:start

if exist ".\%sh%" goto file_exist
goto file_not_exist

:file_exist
if "%~1"=="" (goto without_parameter)
if "%~1"=="-b" (goto without_parameter)
goto with_parameter
goto end

:file_not_exist
echo Unable to run batch file. (%sh% not found)
echo Tips: %sh% should be placed at the same level of this batch file.
echo.
pause
goto end

:without_parameter
start .\%sh%
goto end

:with_parameter
start .\%sh% "%~1" --windows
goto end

:end
exit
