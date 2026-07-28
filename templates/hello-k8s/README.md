# hello-k8s

This is a very simple Backstage template to generate a nginx deployment. This is based on the kubernetes [documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment) example.


> [!WARNING]
> This template only generates the deployment manifest it does not deploy to kubernetes yet

## Tasks

- [ ] deploy manifest to Kubernetes cluster (temporary method of deployment)
- [ ] register as a new component in the catalog
- [ ] create a PR that ArgoCD can deploy

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: dev
spec:
  selector:
    matchLabels:
      app: webslinger
  replicas: 2 # tells deployment to run 2 pods matching the template
  template:
    metadata:
      labels:
        app: webslinger
        env: dev
        backstage.io/kubernetes-id: webslinger
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```