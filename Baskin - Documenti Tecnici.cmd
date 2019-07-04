@echo off

rem --- VARIABILI --- INIZIO ---
set REVISIONE=4.5
set TITOLO=%~n0
set SEJDACOMMAND=C:\Users\Daniele\Documents\Baskin\Baskin-Daniele Lolli\My Baskin Sketchbook\_tools\sejda-console-3.2.76\bin\sejda-console
rem --- VARIABILI --- FINE ---

cls
echo %TITOLO% - rev. %REVISIONE%
echo.

rem -- process date from http://stackoverflow.com/questions/1192476/format-date-and-time-in-a-windows-batch-script
set hour=%time:~0,2%
if "%hour:~0,1%" == " " set hour=0%hour:~1,1%
set min=%time:~3,2%
if "%min:~0,1%" == " " set min=0%min:~1,1%
set secs=%time:~6,2%
if "%secs:~0,1%" == " " set secs=0%secs:~1,1%
set year=%date:~-4%
set month=%date:~3,2%
if "%month:~0,1%" == " " set month=0%month:~1,1%
set day=%date:~0,2%
if "%day:~0,1%" == " " set day=0%day:~1,1%

set FILEOUTPUT=%TITOLO% - rev. %REVISIONE% (%year%-%month%-%day% %hour%-%min%-%secs%).pdf
set FILETEMP=%TITOLO% - rev. %REVISIONE% [FILETEMP].pdf
set FILELISTA=%TITOLO%_lista.csv

echo.
echo.
echo Unione documenti...
echo.
echo "%SEJDACOMMAND%" merge -l "%FILELISTA%" -o "%FILETEMP%" --overwrite >"%TITOLO% - rev. %REVISIONE% [UNISCI].cmd"
call "%TITOLO% - rev. %REVISIONE% [UNISCI].cmd"

echo.
echo.
echo Aggiungo i numeri di pagina...
echo.
echo "%SEJDACOMMAND%" setheaderfooter -o "%FILEOUTPUT%" -f "%FILETEMP%" --pageRange all --verticalAlign bottom --horizontalAlign center --label "%TITOLO% - Rev. %REVISIONE% - pag. [PAGE_OF_TOTAL]"  >"%TITOLO% - rev. %REVISIONE% [NUMERA].cmd"
call "%TITOLO% - rev. %REVISIONE% [NUMERA].cmd"

echo.
echo.
echo Pulizia...
echo.
if exist "%TITOLO% - rev. %REVISIONE% [UNISCI].cmd" del "%TITOLO% - rev. %REVISIONE% [UNISCI].cmd"
if exist "%TITOLO% - rev. %REVISIONE% [NUMERA].cmd" del "%TITOLO% - rev. %REVISIONE% [NUMERA].cmd"
if exist "%FILETEMP%" del "%FILETEMP%"

set REVISIONE=
set TITOLO=
set FILEOUTPUT=
set FILETEMP=
set FILELISTA=

echo FINITO.
echo.
pause
