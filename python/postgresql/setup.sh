#!/usr/bin/env bash

PSQL_ADMIN="postgresql"
PSQL_USER="test"
PSQL_PASS="test"
PSQL_DB="test"

podman run -d --name postgresql_database -e POSTGRESQL_ADMIN_PASSWORD=$PSQL_ADMIN -e POSTGRESQL_USER=$PSQL_USER -e POSTGRESQL_PASSWORD=$PSQL_PASS -e POSTGRESQL_DATABASE=$PSQL_DB -p 5432:5432 registry.redhat.io/rhel8/postgresql-16
