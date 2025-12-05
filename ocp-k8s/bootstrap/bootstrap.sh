#!/usr/bin/env bash

## OpenShift GitOps
setup_gitops(){
oc get namespace openshift-gitops-operator &> /dev/null
if [ $? -eq 0 ];then
  echo "Namespace exists... Skipping"
else
  oc create namespace openshift-gitops-operator
  oc create namespace openshift-gitops
  oc create -f op_gitops.yaml
  ## Generate GitOps Repo Secret
  sed -e 's/SSH_KEY/'$(echo -n "`/usr/bin/cat ~/.ssh/id_ed25519`" | base64 -w0)'/g' secret_gitops.yaml | oc create -n openshift-gitops -f -
fi

}

## OpenShift Pipelines
setup_pipelines(){
oc get namespace openshift-pipelines &> /dev/null
if [ $? -eq 0 ];then
  echo "Namespace exists... Skipping"
else
  oc create namespace openshift-pipelines
  oc create -f op_pipeline.yaml
fi
}

setup_gitops
setup_pipelines
