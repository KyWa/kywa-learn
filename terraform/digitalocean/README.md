# DigitalOcean Terraform Learning

## Using subdirectories as "modules"

```
module "k8s" {
  source = "./k8s"
}
```

You do need to have providers in these submodules even if they are just other resources of the parent project dir. Simple way is to create a symlink if you do not want to duplicate files. Possibly not the "standard" way of doing this, but its the way I've gone with.

## Using the Kubernetes cluster

Obtain the `kubeconfig` via the `doctl` command:

`doctl kubernetes cluster kubeconfig save kywa-learn`

## Using the Container Registry

### Docker Desktop

If using Docker Desktop, you will need to save the docker config with `doctl`:

`doctl registry login`

Then you can use the registry however you normally would via `docker push/pull`

### Docker / Podman static

You will need to save the docker config with `doctl`:

`doctl registry docker-config kywa >> ~/.docker/config.json`

Then you can use the registry however you normally would via `docker push/pull`
