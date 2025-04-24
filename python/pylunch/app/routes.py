from app import app
from random import randrange
from flask import render_template

@app.route('/')
@app.route('/index')
def index():
    choices = {1:"Robertos",2:"Hyderabad",3:"Spring Food Park",4:"Olive Oil",5:"Freebirds",6:"Torchys",7:"Chick-fil-a"}
    choice = choices[randrange(len(choices))+1]
    print(choice)
    return render_template('index.html', title="yeet", choice=choice)
