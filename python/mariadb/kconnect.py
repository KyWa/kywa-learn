import mysql.connector
import os

def new_conn():
    config = { 'user':'root', 'password':os.environ['MYSQL_ROOT_PASSWORD'], 'host':'127.0.0.1', 'database':os.environ['DB_NAME'], 'raise_on_warnings': True }
    
    try:
        conn = mysql.connector.connect(**config)
    except mysql.connector.Error as err:
      if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("Something is wrong with your user name or password")
      elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("Database does not exist")
      else:
        print(err)
    return conn
