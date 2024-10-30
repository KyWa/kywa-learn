# [External Secrets Operator](https://external-secrets.io/latest/)

## Installation and Configuration
The `external-secrets-operator` can be installed via OLM in your OpenShift cluster, as it is in the Community Operators catalog, or by using its [Helm](https://github.com/external-secrets/external-secrets/tree/main/deploy/charts/external-secrets) chart. Once it the Operator is installed you will need to configure it with a `OperatorConfig` object with an example found [here](01a-operator-config.yaml).

**NOTE** If you are in a disconnected environment and installed the Operator via OLM, you will most likely need to patch the `ClusterServiceVersion` to specify where its image should come from. To do this you will need to run a script like the following (image tag/digest will be needed):

```sh
oc patch csv external-secrets-operator.v0.9.17 --type json -p='[{"op": "replace", "path": "/spec/install/spec/deployments/0/spec/template/spec/containers/0/image", "value":"container-registry.example.com/community-operators/external-secrets@sha2563c822882f8b598da8484c81e1573bd55f0b8756eea1705a165a18a9b622db477"}]'
```

There is also a small BASH script here called `helper-scripts.sh` which has 2 functions that can help format certificates for use with ESO (and a secret vault).

## Connecting to a SecretStore
With ESO installed and running, you now need to connect to a provider of some type. The examples in this repository are based on using CyberArk Conjur as a provider. You have 2 options to connect with a provider, and both can be done in tandem, is a `ClusterSecretStore` or a `SecretStore`. The advantages of a `ClusterSecretStore` is typically for platform teams that want to manage `Secrets` across multiple namespaces without having the overhead of managing a `SecretStore` object which goes into each namespace. There is one difference in configuration between these two objects and that is the `ClusterSecretStore` has to specify which `namespaces` it is going to look into/at. ESO does not add `labels` or `RoleBindings` to a `namespace` to allow it to manage `Secrets` inside of said `namespace`. When deployed, ESO creates a `ClusterRole` and `ClusterRoleBinding` that grants it cluster-wide permission to do these activities.

Examples for the 2 types of `SecretStores` are provided in `02a-cluster-secret-store.yaml` and `02b-secret-store.yaml`.

## ExternalSecret
The last component needed to make use of ESO is to create an `ExternalSecret` object which is going to manage a `Secret` in a given `namespace`. Each `ExternalSecret` object is going to manage a single `Secret` and provides numerous options for managing it. For administrators using OpenShift GitOps (ArgoCD), you will need to ensure that the `ExternalSecret` template has a `creationPolicy` of `Owner`, otherwise ArgoCD will prune the resulting `Secret` object as it exists with the labels for the namespace, but has no `owner`. An example `ExternalSecret` object is found in 2 different files with one of them being an example of managing TLS certificates through an `ExternalSecret`. Please note that the example, `03a-certificate-secret.yaml`, assumes that your TLS key has the fields of `-----BEGIN PRIVATE KEY-----`, but some may be different depending on provider and could be this instead, `-----BEGIN RSA PRIVATE KEY-----`.

A `Secret` managed by an `ExternalSecret` will be updated/created and should have the following "extra" fields, `labels`, `annotations` and `ownerReferencees`,  when the `creationPolicy` is set to `Owner`:

```yaml
apiVersion: v1
data:
  bindPassword: REDACTED_BASE64_ENCODED_STRING
kind: Secret
metadata:
  annotations:
    reconcile.external-secrets.io/data-hash: e69c747d4___RANDOM___d9f164290280
  labels:
    reconcile.external-secrets.io/created-by: 5ea8715___RANDOM___ccdcd2
  name: ldap-secret
  namespace: group-sync-operator
  ownerReferences:
  - apiVersion: external-secrets.io/v1beta1
    blockOwnerDeletion: true
    controller: true
    kind: ExternalSecret
    name: ldap-secret
type: Opaque
```
