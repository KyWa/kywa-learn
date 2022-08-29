# Tekton Learnings

## Builds

Current manifest labeled ssh-* are used for building an image using Tekton. This does require the `git-clone` Task from [Tekton Hub](https://hub.tekton.dev/tekton/task/git-clone) and it can be installed using the `tkn` binary via `tkn hub install task git-clone`.

You will need to create an auth file for the `image-pull-secret` (which is only used for pushing) and can be done easily if using [Quay](https://quay.io) as you can grab a `k8s` manifest from your profile. For all others, just create a `dockercfg` for the registry you use and put it in the secret `image-pull-secret.yaml`. An article on how to do this can be found [here](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/).

### Edit manifests

Ensure the parameters you wish to build against are correct in `ssh-pipeline.yaml`:

```yaml
# fetch-repository Task
params:
  - name: url
    value: git@github.com:KyWa/dockerbuilds.git <-- Repo you wish to clone
---
# build Task
params:
  - name: image
    value: quay.io/kywa/go-env <-- Image location to push completed build
  - name: dockerfile_path
    value: go-env <-- Path to the directory with the Dockerfile (defaults to Dockerfile)
```

### Apply manifests

```sh
$ kubectl apply -f image-pull-secret.yaml
$ kubectl apply -f ssh-pipeline.yaml
$ kubectl apply -f ssh-task.yaml
$ kubectl create -f ssh-run.yaml
```

The reason we run `kubectl create` as opposed to `kubectl apply` is to use the `generateName` function for the metadata. This allows the `pipelinerun` objects to generate a name for each run being chosen at random without foring a `name` parameter.

The progress of the `PipelineRun` can be found by running: `kubectl describe pipelinerun $(kubectl get pipelinerun | grep build-pipeline | awk '{print $1}')`
