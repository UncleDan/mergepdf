@echo off

@rem Questo programma può funzionare in due modi:
@rem 1.	Creando un elenco con lo stesso nome del batch più "_lista.csv" se si desidera un ordine particolare.
@rem 	Esempio: se il batch si chiama "Baskin - Documenti Tecnici.cmd" la lista si deve chiamare "Baskin - Documenti Tecnici_lista.csv"
@rem 2.	Se nessuna lista è specificata il programma processerà i file presenti nella cartella %PERCORSOPDF% in ordine alfabetico.

rem --- VARIABILI --- INIZIO ---
set REVISIONE=4.5
set TITOLO=%~n0
set PERCORSOPDF=PDF
set PAGINEDANUMERARE=3-126,130-198
set SEJDACOMMAND=..\_tools\sejda-console-3.2.76\bin\sejda-console
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
set FILETEMP=__TEMP__%FILEOUTPUT%
set FILELISTA=%TITOLO%_lista.csv
if exist %FILELISTA% goto AbbiamoLista
	set FILELISTA=__TEMP__%FILELISTA%
	if exist "__DA_RIORDINARE%FILELISTA%" del "__DA_RIORDINARE%FILELISTA%"
	for %%a in ("%PERCORSOPDF%\*.pdf") do echo %%~fa>>"__DA_RIORDINARE%FILELISTA%"
	if exist "%FILELISTA%" del "%FILELISTA%"
	sort "__DA_RIORDINARE%FILELISTA%" /o "%FILELISTA%"
	if exist "__DA_RIORDINARE%FILELISTA%" del "__DA_RIORDINARE%FILELISTA%"
	if exist "%FILELISTA%" set CANCELLALISTA=*VERO*
:AbbiamoLista
set CMDUNISCI=__TEMP__%TITOLO% - rev. %REVISIONE% [UNISCI].cmd
set CMDNUMERA=__TEMP__%TITOLO% - rev. %REVISIONE% [NUMERA].cmd

echo.
echo.
echo Unione documenti...
echo.
echo "%SEJDACOMMAND%" merge -l "%FILELISTA%" -o "%FILETEMP%" --overwrite >"%CMDUNISCI%"
call "%CMDUNISCI%"

echo.
echo.
echo Aggiungo i numeri di pagina...
echo.
echo "%SEJDACOMMAND%" setheaderfooter -o "%FILEOUTPUT%" -f "%FILETEMP%" --pageRange all --verticalAlign bottom --horizontalAlign center --label "%TITOLO% - Rev. %REVISIONE% - [PAGE_OF_TOTAL]" -s %PAGINEDANUMERARE%>"%CMDNUMERA%"
call "%CMDNUMERA%"

echo.
echo.
echo Pulizia...
echo.
if exist "%CMDUNISCI%" del "%CMDUNISCI%"
if exist "%CMDNUMERA%" del "%CMDNUMERA%"
if exist "%FILETEMP%" del "%FILETEMP%"
if "%CANCELLALISTA%"=="*VERO*" del "%FILELISTA%"

set REVISIONE=
set TITOLO=
set PERCORSOPDF=
set PAGINEDANUMERARE=
set SEJDACOMMAND=
set hour=
set min=
set secs=
set year=
set month=
set day=
set FILEOUTPUT=
set FILETEMP=
set FILELISTA=
set CANCELLALISTA=
set CMDUNISCI=
set CMDNUMERA=

echo FINITO.
echo.
pause
