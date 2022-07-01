import kconnect
import os
import mysql.connector
from mysql.connector import errorcode

conn = kconnect.new_conn()
cursor = conn.cursor()

DB_NAME = os.environ['DATABASE'] 

def create_database(cursor):
    try:
        cursor.execute(
            "CREATE DATABASE {} DEFAULT CHARACTER SET 'utf8'".format(DB_NAME))
    except mysql.connector.Error as err:
        print("Failed creating database: {}".format(err))
        exit(1)

try:
    cursor.execute("USE {}".format(DB_NAME))
except mysql.connector.Error as err:
    print("Database {} does not exists.".format(DB_NAME))
    if err.errno == errorcode.ER_BAD_DB_ERROR:
        create_database(cursor)
        print("Database {} created successfully.".format(DB_NAME))
        conn.database = DB_NAME
    else:
        print(err)
        exit(1)

TABLES = {}

TABLES['stuff'] = (
    "CREATE TABLE stuff ("
    "account VARCHAR(20) PRIMARY KEY,"
    "link VARCHAR(50),"
    "due DATE)"
    )

TABLES['morestuff'] = (
    "CREATE TABLE morestuff ("
    "network VARCHAR(20) PRIMARY KEY,"
    "status VARCHAR(20),"
    "completed DATE)"
    )

cursor.execute("USE {}".format(os.environ['DB_NAME']))
for table_name in TABLES:
    print(table_name)

for table_name in TABLES:
    table_description = TABLES[table_name]
    try:
        print("Creating table {}: ".format(table_name), end='')
        cursor.execute(table_description)
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_TABLE_EXISTS_ERROR:
            print("already exists.")
        else:
            print(err.msg)
    else:
        print("OK")

cursor.close()
conn.close()
