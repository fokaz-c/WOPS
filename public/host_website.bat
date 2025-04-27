@echo off
SET HOST=0.0.0.0
SET PORT=3000
SET WEB_DIRECTORY=%~dp0public  REM This sets the path to the 'public' folder relative to the batch file location

REM Check if Python is installed
python --version >nul 2>&1
IF ERRORLEVEL 1 (
    echo Error: Python is not installed. Please install Python to continue.
    pause
    exit /b 1
)

REM Navigate to the web directory
cd /d %WEB_DIRECTORY%

REM Start the Python HTTP server to serve HTML
echo Hosting %WEB_DIRECTORY% on http://0.0.0.0:%PORT% (accessible by others using your IP address)
start http://localhost:%PORT%

python -m http.server %PORT% --bind %HOST%

pause
