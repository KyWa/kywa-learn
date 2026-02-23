#!/usr/bin/env bash

podman run -d --name mongodb_database -e MONGO_INITDB_ROOT_USERNAME=mongoadmin -e MONGO_INITDB_ROOT_PASSWORD=secret -p 27017:27017 docker.io/mongo:8.2
