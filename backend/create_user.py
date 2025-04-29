import mysql.connector
from flask_bcrypt import Bcrypt

# Initialize bcrypt for password hashing
bcrypt = Bcrypt()

# Function to add a user
def add_user(username, password, role, db): 
    cursor = db.cursor()

    hashed_password = bcrypt.generate_password_hash(password).decode("utf-8")  # Hash password
    query = "INSERT INTO users (username, password_hash, role) VALUES (%s, %s, %s)"
    cursor.execute(query, (username, hashed_password, role))
    db.commit()
    cursor.close()
    print(f"User {username} added successfully!")

