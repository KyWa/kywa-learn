from app import app
from flask import render_template, redirect, url_for, request

@app.route('/')
@app.route('/index')
def index():
    return render_template('index.html', title="Login Page")

@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        if request.form['username'] != 'admin' or request.form['password'] != 'admin':
            error = 'Invalid Credentials. Please try again.'
        else:
            return redirect(url_for('index'))
    return render_template('login.html', error=error, title="Login Page")
