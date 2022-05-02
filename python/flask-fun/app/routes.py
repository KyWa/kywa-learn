from app import app
from flask import render_template

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
