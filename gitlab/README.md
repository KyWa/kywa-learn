# GitLab Automation
In this directory you will find manifests to initialize a GitLab instance and setup a repository mirror. You will also find manifests to setup a `CronJob` to trigger a GitLab mirror which should be used if you need the mirror trigger to occur more frequently than the default of 30 minutes.

## GitLab Mirror Trigger
The manifests under `trigger-gitlab-mirror` can be used to create a `CronJob` to trigger GitLab to mirror a repository

### Usage
Update the `trigger-gitlab-mirror-access-token.yaml` with a token generated from GitLab to hit the API. The only other thing to do is update the name of your GitLab instance in the manifest `trigger-gitlab-mirror-cronjob.yaml`. With that, just apply all the manifests to your k8s cluster and it will take care of itself.

## GitLab Initialization and Configuration
These manifests will get a new GitLab instance setup and start mirroring repositories listed in the `projects` section of the `gitlab-config.yaml` file. This is expected to be run against a GitLab instance running in your Kubernetes cluster, but could be modified to target a stand-alone GitLab system.

### Usage
Add your GitLab license to the file `gitlab-license.yaml`, update the file `gitlab-repo-secret.yaml` with your credentials to whichever code repository you are trying to mirror. With those two things done, all you need to do is configure your `gitlab-config.yaml` with whatever configuration you need to get things started and then run `setup.sh` to get everything going.
