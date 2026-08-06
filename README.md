# backstage-rage

Theses are notes and artifacts I've created to learn how to use Backstage with Kubernetes and ArgoCD.

In this repo you will find the following:

## backstage

- [templates](./templates/hello-k8s/README.md) - to create and register new components
- [example YAMLs](./examples/README.md) - a simple org example with a main engineering team and a feature and platform engineering sub-team, api and dependant resources

## adjacent technologies

- [argocd](./argocd/README.md) - setting up an argocd instance to test out Backstage integration
- [helm repository](./helm-charts/hello-k8s/README.md) - codifying deployments that will eventually be used for ArgoCD

## miscellany

- [material icon reference](https://mui.com/material-ui/material-icons/) - Find the correct name to replace the icons (example below)

```tsx
<Sidebar>
    <SidebarLogo />
    <SidebarGroup label="Search" icon={<SearchIcon />} to="/search">
    <SidebarSearchModal />
    </SidebarGroup>
...
</Sidebar>
```