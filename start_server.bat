@echo off
SET APP_NAME=FastAPI Server
SET HOST=0.0.0.0
SET PORT=8000
SET MODULE_NAME=main:app

REM Check if Python is installed
python --version >nul 2>&1
IF ERRORLEVEL 1 (
    echo Error: Python is not installed. Please install Python to continue.
    pause
    exit /b 1
)

REM Activate virtual environment
call venv\Scripts\activate
IF ERRORLEVEL 1 (
    echo Error: Could not activate virtual environment. Ensure it exists.
    pause
    exit /b 1
)

REM Install dependencies
python -m pip install -r requirements.txt >nul 2>&1
IF ERRORLEVEL 1 (
    echo Error: Failed to install dependencies. Check requirements.txt.
    pause
    exit /b 1
)

REM Check if uvicorn is installed
python -m uvicorn --version >nul 2>&1
IF ERRORLEVEL 1 (
    echo Uvicorn is not installed. Installing uvicorn...
    python -m pip install uvicorn >nul 2>&1
    IF ERRORLEVEL 1 (
        echo Error: Failed to install uvicorn.
        pause
        exit /b 1
    )
)

REM Start the server
echo Starting %APP_NAME% on http://%HOST%:%PORT%
python -m uvicorn %MODULE_NAME% --host %HOST% --port %PORT% --reload
pause
