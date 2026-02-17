import logging
import psycopg
import os

PSQL_DB_HOST = os.environ["PSQL_HOST"]
PSQL_DB_ADMIN = os.environ["PSQL_ADMIN"]
PSQL_DB_USER = os.environ["PSQL_USER"]
PSQL_DB_PASSWORD = os.environ["PSQL_PASS"]
PSQL_DB_DATABASE = os.environ["PSQL_DB"]

conninfo = f"user=postgres password={PSQL_DB_ADMIN} host={PSQL_DB_HOST} port=5432 dbname=postgres"
noadmin_conninfo = f"user={PSQL_DB_USER} password={PSQL_DB_PASSWORD} host={PSQL_DB_HOST} port=5432 dbname={PSQL_DB_DATABASE}"

logging.basicConfig(level=logging.DEBUG, format="%(asctime)s %(levelname)s %(message)s")
logging.getLogger("psycopg").setLevel(logging.DEBUG)

## DB INIT TESTING
def get_autoconn():
    return psycopg.connect(conninfo=conninfo, autocommit=True)

def get_conn():
    return psycopg.connect(conninfo=noadmin_conninfo)

# Check if DB exists and if not, create it
def init_db():
    with get_autoconn() as conn:
        with conn.cursor() as cur:
            cur.execute(f"SELECT FROM pg_database where datname = '{PSQL_DB_DATABASE}'")
            db_exists = cur.fetchone()
            if db_exists == None:
                cur.execute(f'CREATE DATABASE {PSQL_DB_DATABASE} OWNER {PSQL_DB_USER}')
                cur.execute(f'GRANT ALL ON DATABASE {PSQL_DB_DATABASE} TO {PSQL_DB_USER}')
                configure_db()

# Just to do it from Python
def delete_db():
    with get_autoconn() as conn:
        conn.execute(f'drop database {PSQL_DB_DATABASE}')

# More needed, but a start
def configure_db():
    with get_conn() as conn:
        conn.execute("CREATE TABLE namespace (ns_id SERIAL, ns_name VARCHAR(255), ns_cluster VARCHAR(30), ns_owner varchar(80), PRIMARY KEY (ns_id))")

# Need to variablize this
def insert_data():
    with get_conn() as conn:
        conn.execute("INSERT INTO namespace (ns_name, ns_cluster, ns_owner) VALUES ('some_namespace', 'aws-nonprod-us-east2', 'dude@example.com')")

# Testing print of results from DB
def print_it():
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(f"SELECT * FROM namespace WHERE ns_owner = 'dude@example.com'")
            for result in cur.fetchall():
                print(result)

init_db()
#configure_db()
#delete_db()
#insert_data()
#print_it()
