@echo off

REM Get the current script's directory
SET SCRIPT_DIR=%~dp0

REM Navigate to the project directory (relative to the script location)
cd /d %SCRIPT_DIR%

REM Ask for user input for ARDUINO_PORT and BAUD_RATE
set /p ARDUINO_PORT=Enter the Arduino port (e.g., COM7): 
set /p BAUD_RATE=Enter the baud rate (e.g., 9600): 

REM If no input is provided, use defaults
if "%ARDUINO_PORT%"=="" set ARDUINO_PORT=COM7
if "%BAUD_RATE%"=="" set BAUD_RATE=9600

REM Write the values to the .env file
echo ARDUINO_PORT=%ARDUINO_PORT% > .env
echo BAUD_RATE=%BAUD_RATE% >> .env

REM Check if venv folder exists, if not, create it
IF NOT EXIST "venv" (
    echo Virtual environment not found. Creating a new one...
    python -m venv venv
)

REM Activate the virtual environment
call venv\Scripts\activate

REM Check if requirements.txt exists
IF EXIST "requirements.txt" (
    REM Install dependencies from requirements.txt
    echo Installing dependencies from requirements.txt...
    pip install -r requirements.txt
) ELSE (
    echo requirements.txt not found. Skipping installation.
)

REM Start FastAPI server with the updated .env file
echo Starting FastAPI server with ARDUINO_PORT=%ARDUINO_PORT% and BAUD_RATE=%BAUD_RATE%...
start /b python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload

REM Wait for server to start
timeout /t 5

REM Navigate to the public folder and start the static website server
echo Starting static website from the 'public' folder...
cd /d %SCRIPT_DIR%public
start /b host_website.bat

REM Wait for the user to press any key before closing the script
pause
