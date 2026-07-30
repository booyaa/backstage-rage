# argo cd

notes on how to integrate argo cd with backstage

> [!WARNING]
> It's assumed you have a Kind cluster and a standalone version of Backstage 


## Tasks

- [ ] - Set up ArgoCD template [scaffolding](https://roadie.io/backstage/scaffolder-actions/argocd-create-resources/). May need to read this [doc](https://github.com/backstage/software-templates/blob/main/all-templates.yaml) too.

## Installation

Source: [docs](https://argo-cd.readthedocs.io/en/stable/try_argo_cd_locally/)

```sh
# terminal 1
kubectl create namespace argocd
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get deploy -n argocd --watch # until replicas are ready

# install cli 
VERSION=$(curl -L -s https://raw.githubusercontent.com/argoproj/argo-cd/stable/VERSION)
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/v$VERSION/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
argocd admin initial-password -n argocd
argocd login localhost:8080
argocd cluster add $(kubectl config get-contexts -o name)

# get password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d

# terminal 2
kubectl port-forward svc/argocd-server -n argocd 8080:443

# verify set up by logging into argocd (accept warnings about self certified cert)
# user: admin password: (see terminal 1)
# https://localhost:8080
```

## deploy guestbook app (hello world)

Source: [docs](https://argo-cd.readthedocs.io/en/stable/getting_started/#6-create-an-application-from-a-git-repository)

```sh
kubectl config set-context --current --namespace=argocd
# make sure kubectl proxy is enabled
argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default
argocd app get guestbook
argocd app sync guestbook
```

## create custom using existing repo (with auto sync)

```sh
# temporarily add credentials via PAT
argocd repo add https://github.com/booyaa/flible-florb.git \
  --username gitops-service-account --password "${GITHUB_TOKEN}"

argocd app create flible-florb \
  --repo https://github.com/booyaa/flible-florb.git \
  --path . \
  --directory-exclude "catalog-info.yaml" \
  --sync-policy automated \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace staging
```

## set up argocd integration

source: [roadie](https://roadie.io/backstage/plugins/argo-cd/)

```sh
cd kube-stage # current backstage installation
yarn --cwd packages/app  add @roadiehq/backstage-plugin-argo-cd
yarn --cwd packages/backend add @roadiehq/backstage-plugin-argo-cd-backend
```

```js
# add plugin to packages/backend/src/index.ts
# // Add the Argo CD backend plugin
backend.add(import('@roadiehq/backstage-plugin-argo-cd-backend'));
```

```sh
cd ../backstage-rage/argocd # return to our repo

# create new user
kubectl apply -f new-user.yaml

# verify credentials
argocd account list
argocd account get --account backstage

# set password
# if you are managing users as the admin user, <current-user-password> should be the current admin password.
argocd account update-password \
  --account backstage \
  --current-password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d) \
  --new-password STRONG_PASSWORD_PLZ

argocd logout

# login using new credentials
argocd login

# generate auth token
argocd account generate-token --account backstage

# export new vars
export ARGOCD_USERNAME=backstage
export ARGOCD_PASSWORD=STRONG_PASSWORD_PLZ
export ARGOCD_AUTH_TOKEN=DAT_TOKEN

# known issue with using argocd with port forwarding: https://github.com/RoadieHQ/roadie-backstage-plugins/issues/802
# Use ngrok to get across the line
kubectl apply -f insecure-mode.yaml # turns off tls
kubectl rollout restart deployment argocd-server -n argocd

# go back to terminal 2
# stop port forwarding use a higher port (this might be unnecessary)
kubectl port-forward svc/argocd-server -n argocd 31137:443

# terminal 5
# set up ngrok and define a custom dev domain https://dashboard.ngrok.com/domains
ngrok http 31337 --url YOUR-CUSTOM-SUBDOMAIN.ngrok-free.app
```

```yaml
# update app-config.yaml
argocd:
  username: ${ARGOCD_USERNAME}
  password: ${ARGOCD_PASSWORD}
  appLocatorMethods:
    - type: 'config'
      instances:
        - name: argoInstance1
          url: https://YOUR-CUSTOM-SUBDOMAIN.ngrok-free.app.ngrok-free.app
          token: ${ARGOCD_AUTH_TOKEN}
```

add annotates to an exist app to verify everything works

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: "flible-florb"
  annotations:
    ...
    argocd/app-name: "flible-florb"
```

You can verify everything works if you visit: http://localhost:3000/catalog/default/component/flible-florb/argocd