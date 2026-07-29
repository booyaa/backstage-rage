# backstage-rage

Backstage learning notes and a publishable Helm chart repository.

## Helm repository

The chart source lives in [helm-charts/hello-k8s](helm-charts/hello-k8s). A GitHub Actions workflow packages the chart, generates `index.yaml`, and publishes the repository to GitHub Pages so anyone can add it with `helm repo add`.

The same packaging and index generation logic is also available locally in [scripts/publish-helm-repo.sh](scripts/publish-helm-repo.sh).

### Consumer usage

```sh
helm repo add backstage-rage https://YOUR_GITHUB_USER_OR_ORG.github.io/backstage-rage/
helm repo update
helm search repo backstage-rage
helm install hello-k8s backstage-rage/hello-k8s
```

### Local validation

```sh
helm lint helm-charts/hello-k8s
./scripts/publish-helm-repo.sh https://YOUR_GITHUB_USER_OR_ORG.github.io/backstage-rage/ /tmp/backstage-rage-helm
```

Replace `YOUR_GITHUB_USER_OR_ORG` with the account or organization that hosts the Pages site.
