# hello-k8s

This a simple chart that codifies the example deployment manifest from the Kubernetes documentation site.

## End user usage

```sh
helm repo add backstage-rage https://booyaa.github.io/backstage-rage/
helm repo update
helm search repo backstage-rage
helm install hello-k8s backstage-rage/hello-k8s
```

## Developing

### Local validation

```sh
helm lint helm-charts/hello-k8s
../scripts//publish-helm-repo.sh https://booyaa.github.io/backstage-rage/ /tmp/backstage-rage-helm
```

