from flask import jsonify
from openai import OpenAI
from config_manager import load_config
import mysql.connector
from saveQuery import saveQuery


config = load_config()
apiKey = config.get("openai_key")
llm_model = str(config.get("model"))
db_e = config.get("db", {})


client = OpenAI(api_key=apiKey)

def chat(data):
    user_message = str(data.get("messages", []))
    userRole = data.get("userRole")
    username = data.get("username")
    userId = data.get("userId")

    prompt = f"""You are a helpful assistant with access to a MySQL database for a window and door manufacturing company.

Your job is to interpret user questions and generate appropriate SQL queries using the following schema. Only use the tables and fields shown below. Do not guess columns.

Your are helping {username}, he is a {userRole}

### Database Schema:
- Customers(CustomerID INT, Name VARCHAR(255), Email VARCHAR(255), Phone VARCHAR(20), Address TEXT)
- Orders(OrderID INT, CustomerID INT, OrderDate DATE, Status ENUM('Pending', 'In Production', 'Shipped', 'Completed', 'Canceled'), TotalPrice DECIMAL(10,2))
- Products(ProductID INT, Name VARCHAR(255), Type ENUM('Sliding', 'Casement', 'Fixed', 'Door'), FrameMaterial ENUM('Aluminum', 'PVC', 'Wood'), GlassType ENUM('Single', 'Double', 'Triple'), Price DECIMAL(10,2), StockQuantity INT)
- OrderDetails(OrderDetailID INT, OrderID INT, ProductID INT, Quantity INT, Subtotal DECIMAL(10,2))
- Suppliers(SupplierID INT, Name VARCHAR(255), ContactPerson VARCHAR(255), Email VARCHAR(255), Phone VARCHAR(20), Address TEXT)
- Inventory(MaterialID INT, Name VARCHAR(255), MaterialType ENUM('Glass', 'Frame', 'Hardware'), Quantity INT, Unit VARCHAR(50), SupplierID INT)
- Employees(EmployeeID INT, Name VARCHAR(255), Role ENUM('Manager', 'Worker', 'Technician'), Email VARCHAR(255), Phone VARCHAR(20), HireDate DATE)
- ProductionSchedule(ScheduleID INT, OrderID INT, StartDate DATE, EndDate DATE, Status ENUM('In Progress', 'Completed'), AssignedEmployeeID INT)

### Rules:
- If the user is a regular user (`role: user`), only generate `SELECT` queries.
- If the user is a manager or admin, you may generate `INSERT`, `UPDATE`, or `DELETE` queries **but only one query at a time**.
- Do not run multiple statements.
- Do not modify the schema or return fake data.
- Write the SQL code in a single line, without andy indentations

When answering user queries, always respond in two parts:

1. First, write a natural language explanation or answer to the user.
2. Then, after the string `--SQL--`, provide a valid SQL query if one is needed.

If no SQL is needed, write nothing after `--SQL--`.

### Format Example:

The product "Window A" is our best seller with 320 units sold.

--SQL--
SELECT name, SUM(quantity) AS total_sold FROM OrderDetails JOIN Products ON Products.ProductID = OrderDetails.ProductID GROUP BY name ORDER BY total_sold DESC LIMIT 1

"""
    
    response = client.chat.completions.create(
        model=llm_model,
        messages=[
            { "role": "system", "content": prompt },
            { "role": "user", "content": user_message }
        ]
    )

    llm_output = response.choices[0].message.content.strip()

    # Split output into explanation and SQL
    parts = llm_output.split("--SQL--")
    explanation = parts[0].strip()
    sql_query = parts[1].strip() if len(parts) > 1 else ""

    print(llm_output)
    print("sql only VV")
    print("")
    print(f"Running SQL: {sql_query!r}")

    if userRole == "user" and sql_query.lower().startswith(("insert", "update", "delete")):
        return jsonify({ "error": "You do not have permission to modify the database." }), 403


    try:
        conn = mysql.connector.connect(
            host=db_e.get("host"),
            user=db_e.get("user"),
            password=db_e.get("password"),
            database=db_e.get("database"),
        )        
        cursor = conn.cursor(dictionary=True)

        # if sql_query and sql_query.lower().startswith(("select", "insert", "update", "delete")):
        #     try:
        #         cursor.execute(sql_query)
        #         if sql_query.lower().startswith("select"):
        #             results = cursor.fetchall()
        #             saveQuery(userId, "Select created by the chatBot", llm_output)                    
        #             return jsonify({ "response": explanation, "result": results, "query": sql_query })
        #         else:
        #             conn.commit()
        #             saveQuery(userId, "Query created by the chatBot", llm_output)
        #             return jsonify({ "response": explanation, "result": f"{cursor.rowcount} row(s) affected.", "query": sql_query })
        #     except Exception as e:
        #         return jsonify({ "response": explanation, "error": str(e), "query": sql_query }), 400
        if sql_query:
            if sql_query.lower().startswith(("insert", "update", "delete")):
                return jsonify({
                    "response": explanation,
                    "query": sql_query,
                    "confirm": True  # 🔥 flag for frontend to ask confirmation
                })

            elif sql_query.lower().startswith("select"):
                try:
                    cursor.execute(sql_query)
                    results = cursor.fetchall()
                    saveQuery(userId, "Select created by the chatBot", llm_output)
                    cursor.close()
                    return jsonify({ "response": explanation, "result": results, "query": sql_query })
                except Exception as e:
                    cursor.close()
                    return jsonify({ "response": explanation, "error": str(e), "query": sql_query }), 400
        else:
            return jsonify({ "response": explanation })  # Just text, no query


    except Exception as e:
        return jsonify({ "error": str(e), "query": sql_query }), 400

def execute_confirmed(data):
    sql_query = data.get("query")
    role = data.get("role")
    userId = data.get("userId")

    if not sql_query or not sql_query.lower().startswith(("insert", "update", "delete")):
        return jsonify({ "error": "Invalid query for confirmation." }), 400

    if role == "user":
        return jsonify({ "error": "You do not have permission to modify the database." }), 403

    try:
        conn = mysql.connector.connect(
            host=db_e.get("host"),
            user=db_e.get("user"),
            password=db_e.get("password"),
            database=db_e.get("database")
        )
        cursor = conn.cursor()
        cursor.execute(sql_query)
        conn.commit()
        saveQuery(userId, "Query confirmed by user", sql_query)
        cursor.close()
        return jsonify({ "result": f"{cursor.rowcount} row(s) affected." })
    except Exception as e:
        cursor.close()
        return jsonify({ "error": str(e) }), 400
