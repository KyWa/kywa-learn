# Quay API Automation

## Requirements
1. Logged into the OpenShift Cluster where you are to install Quay
2. An active LDAP account to pass into the playbook for setting up Quay's LDAP
3. The binary `jq` is used in this and must be present in the `$PATH` of the user running this playbook

## Setup
There are 2 vars files in the `vars` directory, one for generic information and the other for secret data. The latter should be in some secrets management, but `ansible-vault` will work just fine for testing.

## How to use
```sh
ansible-playbook quay-playbook.yaml
```

## Files created

PullSecret to put in a namespace: 
- `manifests/YOUR_ORG-org-robot-secret.yaml`
