# NeuroBase

An AI-powered web app for querying and managing a MySQL database using natural language.

Created By Luca Serci

23/04/2025

Click on Install.bat and then on Start.bat


## 🔧 Setup

# Backend (Flask)
```bash
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python app.py


# Frontend(React
cd frontend
npm install
npm run build

# Main neurobase Database
mysql -u root -p < mysql/neurodb.sql

# Example company Database
mysql -u root -p < mysql/company1exdb.sql

The Defauld Database Password is root
