@echo off
setlocal enabledelayedexpansion

rem Validate input
if "%~1"=="" (
    echo ERROR: Directory path required as argument
    echo Usage: %0 "directory_path"
    exit /b 1
)
echo DEBUG: Input directory: %~1
set "INPUT_DIR=%~f1"
echo DEBUG: Fully qualified input directory: !INPUT_DIR!

rem Define constants
set "PAR_PATH=C:\Utilities\System\par2"
set "PAR_EXE=phpar2_15_x64.exe"
echo DEBUG: PAR_PATH: !PAR_PATH!
echo DEBUG: PAR_EXE: !PAR_EXE!

rem Verify paths
for %%P in ("!PAR_PATH!" "!INPUT_DIR!") do (
    if not exist "%%~P" (
        echo ERROR: Path not found: %%~P
        exit /b 1
    )
)
if not exist "!PAR_PATH!\!PAR_EXE!" (
    echo ERROR: PAR2 executable not found: !PAR_PATH!\!PAR_EXE!
    exit /b 1
)
echo DEBUG: Paths verified successfully: PAR_PATH and INPUT_DIR exist
echo DEBUG: PAR2 executable exists: !PAR_PATH!\!PAR_EXE!

rem Validate and resolve input directory
set "INPUT_DIR=%~f1"
echo DEBUG: Raw input argument: %1
echo DEBUG: Resolved INPUT_DIR: !INPUT_DIR!
if not exist "!INPUT_DIR!\" (
    echo ERROR: Input directory does not exist: !INPUT_DIR!
    exit /b 1
)
dir "!INPUT_DIR!" >nul 2>&1 || (
    echo ERROR: Cannot access input directory: !INPUT_DIR!
    exit /b 1
)
echo DEBUG: Input directory exists and is accessible: !INPUT_DIR!
echo DEBUG: Listing directory contents (all files, excluding directories):
dir "!INPUT_DIR!" /a-d /s || echo DEBUG: No files or access denied
echo DEBUG: Checking for subdirectories:
dir "!INPUT_DIR!" /ad || echo DEBUG: No subdirectories found

rem Calculate directory size in bytes first, then convert to MB
set "SUM_BYTES=0"
set "FILE_COUNT=0"
echo DEBUG: Starting file enumeration in: !INPUT_DIR!
for /f "delims=" %%F in ('dir "!INPUT_DIR!" /a-d /s /b 2^>nul') do (
    set "TEMP_SIZE=%%~zF"
    echo DEBUG: Processing file: %%F
    if defined TEMP_SIZE (
        echo DEBUG: File size: !TEMP_SIZE! bytes
        set /a "SUM_BYTES+=!TEMP_SIZE!" 2>nul || (
            echo DEBUG: Warning - Could not add size for file: %%F
            set "TEMP_SIZE=0"
        )
        set /a "FILE_COUNT+=1"
    ) else (
        echo DEBUG: Warning - File size not available for: %%F
    )
)
rem Convert bytes to MB (1 MB = 1,048,576 bytes)
set /a "SUM=!SUM_BYTES! / 1024 / 1024"
if !SUM! lss 0 set "SUM=0"
echo DEBUG: Total files processed: !FILE_COUNT!
echo DEBUG: Total size in bytes: !SUM_BYTES!
echo DEBUG: Directory size calculated: !SUM! MB
if !FILE_COUNT! equ 0 (
    echo DEBUG: Warning - No files found in directory: !INPUT_DIR!
)

rem Define size thresholds and parameters
set "SIZE_LEVELS=64 128 256 512 1024 2048 4096 16384 65536 262144 524288 1048576 4194304 8388608"
set "BLOCK_SIZES=204800 204800 204800 2048000 2048000 2048000 4096000 8192000 8192000 8192000 8192000 8192000 8192000 8192000"
set "REC_FILES=16 16 16 16 16 16 32 64 128 128 128 256 256 256"
echo DEBUG: SIZE_LEVELS: !SIZE_LEVELS!
echo DEBUG: BLOCK_SIZES: !BLOCK_SIZES!
echo DEBUG: REC_FILES: !REC_FILES!

rem Select parameters based on size
set "INDEX=0"
for %%S in (!SIZE_LEVELS!) do (
    set /a "INDEX+=1"
    echo DEBUG: Checking size threshold: %%S, INDEX: !INDEX!
    if !SUM! lss %%S (
        set "COUNT=0"
        for %%B in (!BLOCK_SIZES!) do (
            set /a "COUNT+=1"
            if !COUNT! equ !INDEX! (
                set "BLOCK_SIZE=%%B"
                echo DEBUG: BLOCK_SIZE set to: !BLOCK_SIZE!
                goto :set_rec_files
            )
        )
    )
)
rem Default for sizes > 8TB
set "BLOCK_SIZE=8192000"
set "NUM_REC_FILES=256"
echo DEBUG: Default parameters applied: BLOCK_SIZE=!BLOCK_SIZE!, NUM_REC_FILES=!NUM_REC_FILES!
goto :size_selected

:set_rec_files
set "COUNT=0"
for %%R in (!REC_FILES!) do (
    set /a "COUNT+=1"
    if !COUNT! equ !INDEX! (
        set "NUM_REC_FILES=%%R"
        echo DEBUG: NUM_REC_FILES set to: !NUM_REC_FILES!
        goto :size_selected
    )
)

:size_selected
echo DEBUG: Selected parameters: BlockSize=!BLOCK_SIZE!, RecoveryFiles=!NUM_REC_FILES!

rem Get system resources
for /f "tokens=2 delims==" %%M in ('wmic OS get FreePhysicalMemory /value ^| find "="') do set /a "FREE_MEM_MB=%%M/1024"
if !FREE_MEM_MB! lss 500 set "FREE_MEM_MB=500"
for /f "tokens=2 delims==" %%C in ('wmic cpu get NumberOfLogicalProcessors /value ^| find "="') do set "NUM_CORES=%%C"
echo DEBUG: System resources: FREE_MEM_MB=!FREE_MEM_MB!, NUM_CORES=!NUM_CORES!

rem Setup output directory
set "OUTPUT_DIR=%~dp1%~nx1-PAR"
if not exist "!OUTPUT_DIR!" mkdir "!OUTPUT_DIR!" || (
    echo ERROR: Failed to create output directory: !OUTPUT_DIR!
    exit /b 1
)
echo DEBUG: Output directory created: !OUTPUT_DIR!

rem Setup logging
set "LOG_FILE=!OUTPUT_DIR!\par-time.log"
echo Par Start: %date% - %time% : Using !PAR_EXE! > "!LOG_FILE!"
echo DEBUG: Log file created: !LOG_FILE!
echo DEBUG: Log file initial content: Par Start: %date% - %time% : Using !PAR_EXE!

rem Test final PAR2 command
echo DEBUG: Testing PAR2 command...
set "PAR2_COMMAND=!PAR_PATH!\!PAR_EXE! c -s!BLOCK_SIZE! -r100 -u -m!FREE_MEM_MB! -v -v "!OUTPUT_DIR!\%~nx1.par2" "!INPUT_DIR!\*.*""
echo DEBUG: Final PAR2 command: !PAR2_COMMAND!
echo DEBUG: Verifying PAR2 executable exists: !PAR_PATH!\!PAR_EXE!
if not exist "!PAR_PATH!\!PAR_EXE!" (
    echo ERROR: PAR2 executable not found for command execution
    exit /b 1
)
echo DEBUG: Verifying input directory contains files
dir "!INPUT_DIR!\*.*" >nul 2>&1 || (
    echo ERROR: No files found in input directory: !INPUT_DIR!
    exit /b 1
)
echo DEBUG: PAR2 command test passed

rem Execute PAR2
echo Creating PAR2 files...
echo Command: !PAR2_COMMAND! >> "!LOG_FILE!"
start "Parring data" /wait /low !PAR2_COMMAND! >> "!LOG_FILE!" 2>&1
if errorlevel 1 (
    echo ERROR: PAR2 creation failed >> "!LOG_FILE!"
    exit /b 1
)
echo DEBUG: PAR2 command executed successfully

rem Finalize
echo Par Stop: %date% - %time% : Using !PAR_EXE! >> "!LOG_FILE!"
copy /y "!OUTPUT_DIR!\%~nx1.par2" "!INPUT_DIR!" >> "!LOG_FILE!" 2>&1 || (
    echo WARNING: Failed to copy .par2 file to input directory >> "!LOG_FILE!"
)
echo DEBUG: PAR2 file copy attempted to: !INPUT_DIR!
echo Completed: Size=!SUM!MB, BlockSize=!BLOCK_SIZE!, RecoveryFiles=!NUM_REC_FILES! >> "!LOG_FILE!"
echo DEBUG: Final log entry: Completed: Size=!SUM!MB, BlockSize=!BLOCK_SIZE!, RecoveryFiles=!NUM_REC_FILES!
echo Process completed successfully

endlocal
exit /b 0
