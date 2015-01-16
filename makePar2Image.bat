rem echo Par Start: %date% - %time% - >> "%~f1\par-time.log"



echo %~f1
setlocal enabledelayedexpansion


set parPath="C:\Utilities\System\par2cmdline-0.4-x86-win32"
set dir=%~f1
set size=0

rem the following will hit a limit at 2^32 - 1
rem for /R "%dir%" %%F in (*) do ( set /a size=!size!+%%~zF )

echo %size%

REM set OneKB=1024
REM set /a OneMB=%OneKB%*%OneKB%
REM echo %OneMB%

REM set /a OneGB=%OneMB%*%OneKB%

REM set /a OneTB=%OneGB%*%OneKB%

REM set /a OnePB=%OneTB%*%OneKB%

REM set /a twoGB=%OneGB%*2
REM set /a fourGB=%OneGB%*4
REM set /a eightGB=%OneGB%*8

REM echo %OneGB%
REM echo %OneTB%

rem setting blocksize based on data set size, algorithm below:
rem < 2GB - bs 204800 b,
rem 2GB - 4GB - bs 2048000 b, 
rem 4GB - 8GB - bs 20480000 b,
rem > 8GB - bs 40960000 b,

REM if %size% LSS %twoGB%(
	REM set blockSize=204800
   REM )
REM else 
	REM if %size% LSS %fourGB%(
		REM set blockSize=2048000
		REM )
	REM else
		REM if %size% LSS %eightGB%(
			REM set blockSize=20480000
		REM )
		REM else (
			REM set blockSize=40960000			
		REM )

REM echo "blockSize is: %blockSize%"

@REM http://stackoverflow.com/questions/759481/batch-file-to-display-directory-size
@REM http://www.dostips.com/DtTipsStringManipulation.php

set /a oneMB=1
set /a oneGB=%oneMB%*1024

set /a twoGB=%OneGB%*2
set /a threeGB=%OneGB%*3
set /a fourGB=%OneGB%*4
set /a eightGB=%OneGB%*8

setLocal EnableDelayedExpansion
set /a value=0
set /a sum=0
FOR /R %1 %%I IN (*) DO (
@REM ----- Begin of DIR sizing and calculations-----
echo "DirSize RAW: %%~zI"
set tempSize=%%~zI
echo "DirSize RAW2: !tempSize!"
echo "DirSize In KB: !tempSize:~0,-3!"
@REM set /a value=%%~zI/1048576
@REM The above command is replaced by the command below with the necessary conversions
set /a value=!tempSize:~0,-3!
set /a sum=!sum!+!value!
@REM ----- End of DIR sizing and calculations-----
)
@echo Size is: !sum! M

set /a size=%sum%

rem http://www.computing.net/answers/programming/batch-file-nested-if-not-working/16298.html

set blockSize=2048000
set numRecoveryfiles=64

if /I %size% LSS %twoGB% (
	set blockSize=2048000
	set numRecoveryfiles=16
   ) else (
	if /I %size% LSS %fourGB% (
		set blockSize=2048000
		set numRecoveryfiles=64
		) else (
		if /I %size% LSS %eightGB% (
			set blockSize=20480000
			set numRecoveryfiles=64
		) else (
			set blockSize=40960000
			set numRecoveryfiles=64
			)
		)
	)

echo "Dataset Size: %size%"
echo "blockSize is: %blockSize%"



@REM set parEXE=phpar2_12.exe
set parEXE=phpar2_13.exe
@REM set parEXE=par2.exe
@REM set parEXE=par2-0.4-chuchusoft-2010-x64.exe


md ".\%~nx1 - PAR"
echo Par Start: %date% - %time% :Using %parEXE% >> ".\%~nx1 - PAR\par-time.log" 2>&1

START "Parring data" /I /WAIT /LOW %parPath%\%parEXE% c -s%blockSize% -r100 -u -n%numRecoveryfiles% -m1500 -v ".\%~nx1 - PAR\%~nx1.par2" "%~f1\*.*"  >> ".\%~nx1 - PAR\par-time.log" 2>&1

echo "Completed parring..." >> ".\%~nx1 - PAR\par-time.log" 2>&1

echo Par Stop : %date% - %time% :Using %parEXE% >> ".\%~nx1 - PAR\par-time.log" 2>&1

copy ".\%~nx1 - PAR\%~nx1.par2" "%~f1" >> ".\%~nx1 - PAR\par-time.log" 2>&1

@REM For x86 versions....
@REM START "Parring data" /I /WAIT /LOW %parPath%\%parEXE% c -s%blockSize% -r100 -u -n%numRecoveryfiles% -m1500 -v ".\%~n1 - PAR\%~n1.par2" "%~f1\*.*"

rem pause





endlocal
