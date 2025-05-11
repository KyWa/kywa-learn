from flask import Flask, render_template
import os

import config

app = Flask(__name__)

if os.environ.get('RUNTIME_ENVIRONMENT') == "production":
    app.config.from_object('config.ProductionConfig')
else:
    app.config.from_object('config.DevelopmentConfig')

@app.route("/")
def hello_world():
    return "Hello World!"

@app.route('/hello/<name>')
def hello_name(name):
    return render_template("index.html", name = name.capitalize())

# Never put a route function like this in anything, I'm only doing it for testing random stuff
@app.route("/varcheck/<somevar>")
def varcheck(somevar):
    return "The value of the requested setting is: %s" % app.config[somevar]

if __name__ == '__main__':
    app.run()
