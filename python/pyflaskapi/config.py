class Config:
    DEBUG = False
    TESTING = False
    STATIC_FOLDER = 'static'
    TEMPLATES_FOLDER = 'templates'
    SECRET_KEY = 'your_secret_key'
    SQLALCHEMY_DATABASE_URI = 'sqlite:///default.db'

class DevelopmentConfig(Config):
    DEBUG = True
    SQLALCHEMY_DATABASE_URI = 'sqlite:///development.db'

class TestingConfig(Config):
    TESTING = True
    SQLALCHEMY_DATABASE_URI = 'sqlite:///testing.db'

class ProductionConfig(Config):
    SQLALCHEMY_DATABASE_URI = 'postgresql://user:password@localhost/production_db'

#import os
#
#class Config:
#    """Base config."""
#    SECRET_KEY = os.environ.get('SECRET_KEY')
#    SESSION_COOKIE_NAME = os.environ.get('SESSION_COOKIE_NAME')
#    STATIC_FOLDER = 'static'
#    TEMPLATES_FOLDER = 'templates'
#class DevelopmentConfig(Config):
#    FLASK_ENV = 'development'
#    DEBUG = True
#    TESTING = True
#    DATABASE_URI = os.environ.get('DEV_DATABASE_URI')
