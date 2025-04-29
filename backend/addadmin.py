import mysql.connector
from flask_bcrypt import Bcrypt

# Initialize bcrypt for password hashing
bcrypt = Bcrypt()

# Connect to MySQL
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root",
    database="neurodb"
)
cursor = db.cursor()

# Function to add a user
def add_user(username, password, email):
    cursor.execute("SELECT * FROM users WHERE username='admin'")
    admin = cursor.fetchone()
    if admin:
        print(f"Admin already exists")
    else:
        hashed_password = bcrypt.generate_password_hash(password).decode("utf-8")  # Hash password
        query = "INSERT INTO users (username, password_hash, role) VALUES (%s, %s, %s)"
        cursor.execute(query, (username, hashed_password, email))
        db.commit()
        print(f"User {username} added successfully!")

# Add a user (Change username, password, and email)
add_user("admin", "admin", "admin")

# Close connection
cursor.close()
db.close()
