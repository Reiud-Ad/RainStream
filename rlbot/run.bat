@echo off
setlocal

REM GGLBot.exe is the Torch-free launcher: it locates 000-runtime\GGLBotCore.exe
REM and the shared RLBot torch-archive, then starts the core with PATH set.
cd /d "%~dp0"
"%~dp0GGLBot.exe" %*
