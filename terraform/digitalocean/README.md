# DigitalOcean Terraform Learning

Using subdirectories as "modules"

```
module "k8s" {
  source = "./k8s"
}
```

You do need to have providers in these submodules even if they are just other resources of the parent project dir. Simple way is to create a symlink if you do not want to duplicate files. Possibly not the "standard" way of doing this, but its the way I've gone with.
