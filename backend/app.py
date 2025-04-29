from flask import Flask, request, jsonify, Response, stream_with_context
from flask_cors import CORS
import json
from flask_bcrypt import Bcrypt
from flask_jwt_extended import JWTManager, create_access_token
import mysql.connector
from create_user import add_user
from chat import chat, execute_confirmed
from config_manager import load_config, save_config
from datetime import datetime
from saveQuery import saveQuery

app = Flask(__name__)
CORS(app)
bcrypt = Bcrypt(app)
app.config['JWT_SECRET_KEY'] = 'your_secret_key'
jwt = JWTManager(app)

db = mysql.connector.connect(host="localhost", user="root", password="root", database="neurodb")
cursor = db.cursor(dictionary=True)

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM users WHERE username=%s", (data['username'],))
    user = cursor.fetchone()
    if user and bcrypt.check_password_hash(user['password_hash'], data['password']):
        token = create_access_token(identity=user['id'])
        cursor.close()
        return jsonify({"token": token, "user": {"userid": user['id'], "username": user['username'], "role": user['role']}})
    cursor.close()
    return jsonify({"error": "Invalid credentials"}), 401

@app.route('/listUsers', methods=['GET'])
def get_users():
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT id, username, role FROM users")
    users = cursor.fetchall()
    cursor.close()
    return jsonify(users)

@app.route('/queryHistory', methods=['POST'])
def get_queries():
    data = request.get_json()
    db = mysql.connector.connect(host="localhost", user="root", password="root", database="neurodb")
    cursor = db.cursor(dictionary=True)
    username = data.get("username")
    role = data.get("role")

    try:
        cursor = db.cursor(dictionary=True)

        if role in ["admin", "manager"]:
            cursor.execute("""
                SELECT q.id, q.userId, u.username, q.query, q.response, q.executionDate
                FROM queryhistory q
                JOIN users u ON q.userId = u.id
                ORDER BY q.executionDate DESC
            """)
        else:
            # Limit to this user's queries
            cursor.execute("""
                SELECT q.id, q.userId, u.username, q.query, q.response, q.executionDate
                FROM queryhistory q
                JOIN users u ON q.userId = u.id
                WHERE u.username = %s
                ORDER BY q.executionDate DESC
            """, (username,))

        rows = cursor.fetchall()
        cursor.close()
        return jsonify(rows)

    except Exception as e:
        cursor.close()
        return jsonify({ "error": str(e) }), 500

@app.route('/createUser', methods=['POST'])
def createUser():
    data= request.get_json()

    cursor2 = db.cursor(dictionary=True)
    cursor2.execute("SELECT * FROM users WHERE username=%s", (data['username'],))
    user = cursor2.fetchone()
    cursor2.close()
    
    if user:
        return jsonify({"error": "User already exists"}), 401
    else:    
        add_user(data['username'], data['password'], data['role'], db)
        return jsonify({"message": "User created successfully"}), 200
    
@app.route("/save-config", methods=["POST"])
def save_config_route():
    data = request.get_json()
    save_config(data)
    return jsonify({ "message": "Config saved." })

@app.route("/load-config", methods=["GET"])
def load_config_route():
    config = load_config()
    return jsonify(config)

@app.route("/chat", methods=["POST"])
def char_response():
    return chat(data = request.get_json())

@app.route("/execute-confirmed", methods=["POST"])
def execution_confirmation():
    return execute_confirmed(data = request.get_json())

@app.route("/run-query", methods=["POST"])
def run_query():
    data = request.get_json()
    sql = data.get("query")
    userid = int(data.get("userid"))

    config = load_config()
    db_e = config.get("db", {})

    try:
        conn = mysql.connector.connect(
            host=db_e.get("host"),
            user=db_e.get("user"),
            password=db_e.get("password"),
            database=db_e.get("database"),
        )
        cursor3 = conn.cursor(dictionary=True)
        cursor3.execute(sql)

        if sql.strip().lower().startswith("select"):
            rows = cursor3.fetchall()
            cursor3.close()
            saveQuery(userid, sql, "Select")
            return jsonify({ "result": rows })
        else:
            conn.commit()
            rowcount=(cursor3.rowcount)
            rows = rowcount+" row(s) affected."
            saveQuery(userid, sql, rows)
            cursor3.close()
            return jsonify({ "result": f"{rowcount} row(s) affected." })

    except Exception as e:
        return jsonify({ "error": str(e) }), 400

@app.route("/updateUser/<int:user_id>", methods=["PUT"])
def update_user(user_id):
    data = request.get_json()
    username = data.get("username")
    password = data.get("password")  # may be None
    role = data.get("role")

    try:
        if password:
            hashed = bcrypt.generate_password_hash(password).decode("utf-8")
            print(hashed)
            cursor.execute("UPDATE users SET username=%s, password_hash=%s, role=%s WHERE id=%s", (username, hashed, role, user_id))
        else:
            cursor.execute("UPDATE users SET username=%s, role=%s WHERE id=%s", (username, role, user_id))

        db.commit()
        return jsonify({ "message": "User updated" })
    except Exception as e:
        return jsonify({ "error": str(e) }), 500

@app.route("/deleteUser/<int:user_id>", methods=["DELETE"])
def delete_user(user_id):
    try:
        cursor.execute("DELETE FROM users WHERE id=%s", (user_id,))
        db.commit()
        return jsonify({ "message": "User deleted" })
    except Exception as e:
        return jsonify({ "error": str(e) }), 500


    
if __name__ == "__main__":
    app.run(debug=True)