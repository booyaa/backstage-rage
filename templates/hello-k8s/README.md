# hello-k8s

## introduction

This is a simple Backstage template to generate a nginx deployment. This is based on the kubernetes [documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment) example.

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

## pre-requisites

- local / standalone Backstage and configured with Kubernetes and GitHub integration
- Kind with a cluster created 

> [!WARNING]
> This template has not been tested against SaaS (roadie) or self hosted/on-prem Backstage installs

## actions

- injects parameters (application and environment name) into template
- creates a new repo and pushes artifacts (manifest, component yaml and README) to GitHub
- register's component

## installation

- clone this repo
- add the following code to your app-config.yaml

```yaml
catalog:
  ... # omitted for brevity
  locations:
    # add our templates
    - type: url
      target: https://github.com/booyaa/backstage-rage/blob/main/templates/hello-k8s/template.yaml
      rules:
        - allow: [Template]
```

## usage

Start up Backstage and dependencies

```sh
# terminal 1
kubectl proxy # assumes your Kind cluster is up and running
# terminal 2
yarn start
```

In Backstage

- Go to http://localhost:3000/create/templates/default/kubernetes-nginx-deployment
- Complete set up wizard

Once component is registered deploy the manifest

```sh
gh repo clone YOUR_USER_OR_ORG/REPO_NAME
cd REPO_NAME
kubectl apply -f deployment.yaml
kubectl get deploy -n ENV
```

Once the deployment is complete return to Backstage

- Go to your component and select the Kubernetes tab (http://localhost:3000/catalog/default/component/YOUR_APP_NAME/kubernetes)

## roadmap

Tasks to be completed before this template is considered feature complete

[ ] create a PR that ArgoCD can deploy

## license

Copyright &copy; 2026, Mark Sta Ana. Release under the MIT License.

