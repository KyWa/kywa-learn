# ArgoCD Bootstrap for Kubernetes (docker-desktop)

This is the bootstrap repository for getting a `docker-desktop` Kubernetes cluster setup and ready for use.

To begin using this repo, just run the [setup script](./setup-kube.sh)

Once the setup script has been run, `ArgoCD` will be installed and begin syncing the `apps` directory located [here](https://github.com/KyWa/kywa-argo/apps/). 

## To use with your own repo

If you wish to use this repo for yourself and have ArgoCD install on a Kube cluster and start ArgoCD syncing a repo, there is a skeleton `ArgoCD` repository file that can be modified for your use.

[argocd-repo.yaml](argo-repo-skeleton.yaml)
```yaml
apiVersion: v1
data:
  name: YXJnby1hcHBz
  sshPrivateKey: REPLACE_SSH
  type: Z2l0
  url: REPLACE_URL
kind: Secret
metadata:
  annotations:
    managed-by: argocd.argoproj.io
  labels:
    argocd.argoproj.io/secret-type: repository
  name: repo-skeleton
  namespace: argocd
type: Opaque
```

The data inside should be fine, but there will be 2 things you need to change. The `url` and the `sshPrivateKey` will need to be updated to reflect your repository. The data will need to be `base64 encoded` and a handy script is below to help replace these values for you:

```sh
$ sed -i -e "s/REPLACE_URL/$(echo -n "git@github.com:you/your-argo-repo.git" | base64)/g" argo-repo-skeleton.yaml
$ sed -i -e "s/REPLACE_SSH/$(cat ~/.ssh/id_rsa | tr '\n' | base64)/g" argo-repo-skeleton.yaml
```

The other 2 data items in the secret can be kept (type: git, name: argo-repo) if you so choose, but you can replace them if you wish. For the name you can just run this to replace it: `sed -i -e "s/YXJnby1hcHBz/$(echo -n "new-repo-name" | base64)/g" argo-repo-skeleton.yaml`

Then just `kubectl apply -f init-argo/01-argocd-main.yaml && kubectl apply -f your-argo-repo.yaml` and you are off to the fun world of ArgoCD managing your cluster.
