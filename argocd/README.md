# ArgoCD Example repository setup

The `ApplicationSet` that resides under `apps/applicationset.yaml` will create an ArgoCD `Application` for the cluster in question for each directory it finds files in under `cluster-config/*/CLUSTERNAME/*`. This `ApplicationSet` will create the resulting `Application` under the name of the 2nd field (in the example dir it is `openshift-config`) and will place the resulting objects in the namespace which also matches that field/path.
