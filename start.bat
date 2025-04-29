@echo off

REM Activate Python backend
cd backend
call venv\Scripts\activate.bat
start cmd /k "python app.py"

REM Activate java frontend
cd ..
cd frontend
start cmd /k "npm start"