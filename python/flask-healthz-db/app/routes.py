from app import app
from flask import render_template
import mysql.connector
from mysql.connector import errorcode
import json
import os

@app.route('/')
@app.route('/index')
def index():
    user = {'username': 'Kyle'}
    posts = [
              {
                  'author': {'username': 'John'},
                  'body': 'Bootifull day'
              },
              {
                  'author': {'username': 'Sally'},
                  'body': 'Not so Bootifull day'
              }
    ]
    return render_template('index.html', title="yeet", user=user, posts=posts)
@app.route('/healthz')
def healthz():
    config = { 'user':'root', 'password':os.environ['MYSQL_ROOT_PASSWORD'], 'host':'mariadb', 'database':os.environ['DB_NAME'], 'raise_on_warnings': True }
    
    try:
        conn = mysql.connector.connect(**config)
        cursor = conn.cursor()
        return json.dumps({'success':True}), 200, {'ContentType':'application/json'} 
    except mysql.connector.Error as err:
      if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        return json.dumps({'fail':True}), 500, {'ContentType':'application/json'} 
      elif err.errno == errorcode.ER_BAD_DB_ERROR:
        return json.dumps({'fail':True}), 500, {'ContentType':'application/json'} 
      else:
        return json.dumps({'fail':True}), 500, {'ContentType':'application/json'} 

