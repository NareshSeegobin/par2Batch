rem echo Par Start: %date% - %time% - >> "%~f1\par-time.log"

REM PATH GITHUB and C Drive path Utilities/System/par2cmdline-0.4-x86-win32/


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
rem echo Par Start: %date% - %time% - >> "%~f1\par-time.log"



echo %~f1
setlocal enabledelayedexpansion


set parPath="C:\Utilities\System\par2"
set dir=%~f1
set size=0

rem the following will hit a limit at 2^32 - 1
rem for /R "%dir%" %%F in (*) do ( set /a size=!size!+%%~zF )

echo %size%



@REM http://stackoverflow.com/questions/759481/batch-file-to-display-directory-size
@REM http://www.dostips.com/DtTipsStringManipulation.php

set /a oneMB=1
set /a oneGB=%oneMB%*1024

set /a sixteenthGB=%oneMB%*64
set /a eightGB=%oneMB%*128
set /a quarterGB=%oneMB%*256
set /a halfGB=%oneMB%*512
set /a oneGB=%OneGB%*1
set /a twoGB=%OneGB%*2
set /a threeGB=%OneGB%*3
set /a fourGB=%OneGB%*4
set /a eightGB=%OneGB%*8
set /a sixteenGB=%OneGB%*16
set /a thirtytwoGB=%OneGB%*32
set /a sixtyfourGB=%OneGB%*64
set /a onetwentyeightGB=%OneGB%*128
set /a twofiftysixGB=%OneGB%*256
set /a fivetwelveGB=%OneGB%*512
set /a oneTB=%OneGB%*1024
set /a twoTB=%OneGB%*2048
set /a fourTB=%OneGB%*4096
set /a eightTB=%OneGB%*8192

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
@REM need to divide by 1024 or you will get the values in bytes and exceed the 2^32 integer size
set /a value=!value!/1024
set /a sum=!sum!+!value!
@REM ----- End of DIR sizing and calculations-----
)
@echo Size is: !sum! M

set /a size=%sum%

rem http://www.computing.net/answers/programming/batch-file-nested-if-not-working/16298.html

echo "Comparison sizes:"
echo %sixteenthGB%
echo %eightGB%
echo %quarterGB%
echo %halfGB%
echo %oneGB%
echo %twoGB%
echo %fourGB%
echo %eightGB%
echo %sixteenGB%
echo %thirtytwoGB%
echo %sixtyfourGB%
echo %onetwentyeightGB%
echo %twofiftysixGB%
echo %fivetwelveGB%
echo %oneTB%
echo %twoTB%
echo %fourTB%
echo %eightTB%

set blockSize=2048000
@rem set numRecoveryfiles=64
set numRecoveryfiles=16

if /I %size% LSS %sixteenthGB% (
	set blockSize=2048
	set numRecoveryfiles=16
   ) else (
	if /I %size% LSS %quarterGB% (
		set blockSize=20480
		set numRecoveryfiles=16
	   ) else (
		if /I %size% LSS %oneGB% (
			set blockSize=204800
			set numRecoveryfiles=16
		   ) else (
			if /I %size% LSS %twoGB% (
				set blockSize=2048000
				set numRecoveryfiles=16
			   ) else (
				if /I %size% LSS %fourGB% (
					set blockSize=2048000
					set numRecoveryfiles=16
					) else (
					if /I %size% LSS %eightGB% (
						set blockSize=2048000
						set numRecoveryfiles=16
					) else (
						if /I %size% LSS %sixteenGB% (
							set blockSize=4096000
							set numRecoveryfiles=32
						) else (
							if /I %size% LSS %sixtyfourGB% (
								set blockSize=8192000
								set numRecoveryfiles=64
							) else (
								if /I %size% LSS %twofiftysixGB% (
									set blockSize=8192000
									set numRecoveryfiles=128
								) else (
									if /I %size% LSS %fivetwelveGB% (
										set blockSize=8192000
										set numRecoveryfiles=128
									) else (
										if /I %size% LSS %oneTB% (
											set blockSize=8192000
											set numRecoveryfiles=128
										) else (
											if /I %size% LSS %fourTB% (
												set blockSize=8192000
												set numRecoveryfiles=256
											) else (
												if /I %size% LSS %eightTB% (
													set blockSize=8192000
													set numRecoveryfiles=256
												) else (
													set blockSize=8192000
													set numRecoveryfiles=256
													)
												)
											)
										)
									)
								)
							)
						)
					)
				)
			)
		)
	)

echo "Dataset Size: %size%"
echo "blockSize is: %blockSize%"

@REM For large number of files - large blick size and large number of recovery files.

@REM Get free memory
@REM https://stackoverflow.com/questions/9095948/how-to-retrieve-available-ram-from-windows-command-line
@REM https://stackoverflow.com/questions/108439/how-do-i-get-the-result-of-a-command-in-a-variable-in-windows
@REM https://stackoverflow.com/questions/2323292/assign-output-of-a-program-to-a-variable
@REM https://stackoverflow.com/questions/20219527/batch-file-set-wmi-output-as-a-variable

set /a FreeMemoryValueMB=1500
FOR /F "tokens=*" %%I IN ('wmic OS get FreePhysicalMemory /Value ^| find "="') DO set /a FreeMemoryValue=%%I

IF %FreeMemoryValue% GEQ 1000000 (
	set /a FreeMemoryValueMB=!FreeMemoryValue!/1111
)

echo Memory to be used: %FreeMemoryValueMB%


@REM https://stackoverflow.com/questions/22919076/find-number-of-cpus-and-cores-per-cpu-using-command-prompt

set /a NumCores=1
FOR /F "tokens=*" %%I IN ('wmic cpu get NumberOfLogicalProcessors /Value ^| find "="') DO set /a NumCoresValue=%%I

IF %NumCoresValue% GEQ 1 (
	set /a NumCores=!NumCoresValue!
)

echo Number of threads to be used: %NumCores%


@REM set parEXE=phpar2_12.exe
@REM set parEXE=phpar2_13.exe
@REM set parEXE=phpar2_15_x86.exe
set parEXE=phpar2_15_x64.exe
@REM set parEXE=par2.exe
@REM set parEXE=par2-0.4-chuchusoft-2010-x64.exe

echo %CD%

@REM md ".\%~nx1-PAR"
md "%CD%\%~nx1-PAR"

echo Par Start: %date% - %time% :Using %parEXE% >> "%CD%\%~nx1-PAR\par-time.log" 2>&1

@REM START "Parring data" /I /WAIT /LOW %parPath%\%parEXE% c -s%blockSize% -r100 -u -n%numRecoveryfiles% -m1500 -v -v "%CD%\%~nx1-PAR\%~nx1.par2" "%~f1\*.*"  >> "%CD%\%~nx1-PAR\par-time.log" 2>&1
@REM 20150110 - START "Parring data" /I /WAIT /LOW %parPath%\%parEXE% c -s%blockSize% -r100 -u  -m%FreeMemoryValueMB% -v "%CD%\%~nx1-PAR\%~nx1.par2" "%~f1\*.*"  >> "%CD%\%~nx1-PAR\par-time.log" 2>&1
echo [Command to be used:] START "Parring data" /I /WAIT /LOW %parPath%\%parEXE% c -s%blockSize% -r100 -u  -m%FreeMemoryValueMB% -v "%CD%\%~nx1-PAR\%~nx1.par2" "%~f1\*.*"  >> "%CD%\%~nx1-PAR\par-time.log" 2>&1
START "Parring data" /I /WAIT /LOW %parPath%\%parEXE% c -s%blockSize% -r100 -u -m%FreeMemoryValueMB% -v -v "%CD%\%~nx1-PAR\%~nx1.par2" "%~f1\*.*"  >> "%CD%\%~nx1-PAR\par-time.log" 2>&1

echo "Completed parring..." >> "%CD%\%~nx1-PAR\par-time.log" 2>&1

echo Par Stop : %date% - %time% :Using %parEXE% >> "%CD%\%~nx1-PAR\par-time.log" 2>&1

copy "%CD%\%~nx1-PAR\%~nx1.par2" "%~f1" >> "%CD%\%~nx1-PAR\par-time.log" 2>&1

@REM For x86 versions....
@REM START "Parring data" /I /WAIT /LOW %parPath%\%parEXE% c -s%blockSize% -r100 -u -n%numRecoveryfiles% -m1500 -v "%CD%\%~n1-PAR\%~n1.par2" "%~f1\*.*"

@REM pause
 
@rem START "Parring data" /I /WAIT /LOW /B C:\Utilities\System\par2cmdline-0.4-x86-win32\par2-cuda.exe  c -s20480000 -r100 -u -n16 -m1500 -v -t0 "%~n1.par2" "%~f1\*.*"
@rem START "Parring data" /I /WAIT /LOW /B C:\Utilities\System\par2cmdline-0.4-x86-win32\par2-intel.exe  c -s20480000 -r100 -u -n16 -m1500 -v -t0 "%~n1.par2" "%~f1\*.*" 



endlocal
