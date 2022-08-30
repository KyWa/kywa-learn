from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:' + os.environ['MYSQL_ROOT_PASSWORD'] + '@' + os.environ['DB_HOST'] + '/' + os.environ['DATABASE']
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

from app import routes
