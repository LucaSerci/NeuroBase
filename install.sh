#!/bin/bash

echo "🔧 Setting up NeuroBase..."

# === Backend Setup ===
echo "📦 Installing Python backend dependencies..."
cd backend || exit

# Create virtualenv if not exists
if [ ! -d "venv" ]; then
  python3 -m venv venv
fi

source venv/bin/activate
pip install -r requirements.txt

# Optional: Set up .env file if not exists
if [ ! -f ".env" ]; then
  echo "✅ Creating .env file..."
  cat <<EOF > .env
OPENAI_API_KEY=your-key-here
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=password
DB_NAME=neurobase
EOF
fi

cd ..

# === Frontend Setup ===
echo "💻 Installing React frontend..."
cd frontend || exit
npm install
npm run build
cd ..

# === Database Setup ===
echo "🗃️  Setting up MySQL database..."

echo "👉 You may be prompted for your MySQL root password"
mysql -u root -p < mysql/neurodb.sql
mysql -u root -p < mysql/company1exdb.sql

echo "✅ All components are set up!"

echo ""
echo "🚀 To start the app:"
echo "1. Activate backend: cd backend && source venv/bin/activate && python app.py"
echo "2. Open http://localhost:5000 or http://localhost:3000 (if running separately)"
