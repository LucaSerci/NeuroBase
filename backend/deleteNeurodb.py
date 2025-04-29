import mysql.connector

# Connect to MySQL
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root",
    database="neurodb"
)
cursor = db.cursor()

cursor.execute("DROP DATABASE neurodb")