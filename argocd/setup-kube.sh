#!/usr/local/bin/bash

## Check OS
## TODO add in functionality for bash call (Mac using /usr/local/bin/bash all others use symlink to /bin/bash)
#if [ -f /etc/os-release ];then
#    echo "This installer is only meant for setup of Kubernetes running on Mac OSX using docker-desktop"
#    exit
#fi

#### Verify kubernetes is running
checkpods=`kubectl get po -A | grep kube`
if [[ $checkpods = "" ]];then
    echo "Kubernetes isn't running"
    exit
else
    echo "Installing manifests to setup cluster"
    echo ""
fi

## Functions
argoinstall(){
    ## Decrypt argo repo with ansible-vault
    if [[ ! -f ~/.vault-pass ]];then
        echo "Vault File missing. Cannot decrypt initial repo \n"
        echo "Argo will be installed, but no repo will be created"
    else
        ansible-vault decrypt init/argo/02-argo-repo-secret.yaml --vault-password-file=~/.vault-pass
    fi

    ## Create argocd Namespace
    kubectl create namespace argocd

    ## Applying ArgoCD manifests
    if kubectl apply -n argocd -f init/argo/;then
        echo "Installing ArgoCD"
    else
        echo "unable to apply manifest, check configs"
        exit
    fi
}

argopostinstall(){
    ## Applying ArgoCD parent Applications
    if kubectl apply -f apps/;then
        echo "Installing Application Manifests"
    else
        echo "unable to apply manifest, check configs"
        exit
    fi
}

## Main

#ingressinstall
#echo "Installing Ingress"
#minikube addons enable ingress

echo "Beginning ArgoCD Bootstrap"
argoinstall

echo "Deploying initial Argo Applications from apps/"
argopostinstall

echo ""
echo "All manifests have been applied. Services should be live soon as it may take a moment to pull all images."
echo ""

git restore init/argo/
