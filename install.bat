@echo off
echo Setting up NeuroBase...

:: Backend
cd backend
if not exist venv (
  python -m venv venv
)
call venv\Scripts\activate
pip install -r requirements.txt
cd ..

:: Frontend
cd frontend
npm install
npm run build
cd ..

:: MySQL setup
echo Please run this manually:
mysql -u root -p < mysql/neurodb.sql
mysql -u root -p < mysql/company1exdb.sql

pause
