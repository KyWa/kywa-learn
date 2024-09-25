#!/usr/bin/env bash

## ConfigMaps
oc create -f get-init-token.yaml
oc create -f configure-gitlab.yaml

## Secrets
oc create -f gitlab-repo-secret.yaml
oc create -f gitlab-config.yaml
oc create -f gitlab-license.yaml

## Run Job
oc create -f configure-gitlab-job.yaml
