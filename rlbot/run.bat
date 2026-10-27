@echo off
setlocal

REM libtorch must be the SAME build the exe was linked against (CMakeLists.txt LIBTORCH_ROOT).
REM This package ships those DLLs right here, so the bot runs on a machine that has no libtorch
REM installed at all - just unzip and go. The RLBot5 paths below are only a fallback for running
REM straight out of the repo during development.
REM
REM Getting this wrong is nasty to debug: the process dies instantly with 0xC0000139
REM ENTRYPOINT_NOT_FOUND and prints NOTHING, which looks like the bot silently doing nothing.
if exist "%~dp0torch_cpu.dll" (
    set "TORCH_LIB=%~dp0"
) else if exist "%LOCALAPPDATA%\RLBot5\bots\torch-archive\torch\lib\torch_cpu.dll" (
    set "TORCH_LIB=%LOCALAPPDATA%\RLBot5\bots\torch-archive\torch\lib"
) else (
    echo [RainStream] Could not find torch_cpu.dll next to the bot or in RLBot5's torch-archive.
    exit /b 1
)

set "PATH=%TORCH_LIB%;%PATH%"

cd /d "%~dp0"
"%~dp0GGLBot.exe"
