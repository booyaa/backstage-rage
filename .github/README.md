# Operations Manual

## Helm repository

The chart source lives in [helm-charts/hello-k8s](../helm-charts/hello-k8s/). A GitHub Actions workflow packages the chart, generates `index.yaml`, and publishes the repository to GitHub Pages so anyone can add it with `helm repo add`.

The same packaging and index generation logic is also available locally in [../helm-charts/scripts/publish-helm-repo.sh](../helm-charts/scripts/publish-helm-repo.sh).

### GitHub Pages setup

In the repository settings, the following have been configured for GitHub Pages:

1. Source: GitHub Actions
2. Deployment branch: not used when publishing through Actions
3. Public URL: `https://booyaa.github.io/backstage-rage/`

The workflow publishes the site root containing both `index.yaml` and the packaged chart archives, so Helm can read the repository directly from that URL.
