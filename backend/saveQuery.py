from datetime import datetime
import mysql.connector

def saveQuery(userid, request, output):
    db = mysql.connector.connect(host="localhost", user="root", password="root", database="neurodb")
    cursor = db.cursor(dictionary=True)

    date = datetime.today().strftime("%Y-%m-%d")
    id = int(userid)
    output = ' '.join(output.splitlines())
    query = "INSERT INTO queryhistory (`userId`, `query`, `response`) VALUES (%s, %s, %s);"
    values = (id, request, output)
    collapsed_query = query % tuple(repr(v) for v in values)
    print(collapsed_query)
    cursor.execute(collapsed_query)
    db.commit()
    cursor.close()
    print("Query stored")
