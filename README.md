# Lagoon build-deploy-image retagger

With the rapid pace of development in Lagoon, we have observed that the tagged release of Lagoon will cause
an updated `uselagoon/kubectl-build-deploy:latest` to be published. As this image is referenced in all of our remote-controllers, we want to avoid any inadvertent releases of functionality that may not be available on the production amazee.io clusters.

To alleviate this issue, we specify an overrideBuildDeployImage in the lagoon-build-deploy installs (as per https://github.com/uselagoon/lagoon-charts/blob/main/charts/lagoon-build-deploy/values.yaml#L85) like so

```
overrideBuildDeployImage: docker.io/amazeeio/build-deploy-image:production
```

We recommend cloning this repo yourself, to put yourself in control of ensuring the tag used for deploying builds matches the Lagoon version run in your cluster.

This Repository runs a Github Action on a push to the main branch (straight push, no PR needed). It uses built-in variables to determine where it is being run (and hence where it should push to), and requires secrets for the dockerhub push (if required)

It performs:

1. A docker pull of the upstream image and tag specified as envs in [the workflow](.github/workflows/kbdd_retagger.yaml#L6-L7)
2. The creation of a pair of new tags `:production` and a tag to match the upstream version
3. A push of the same image digest from upstream to the following images
  * docker.io/amazeeio/build-deploy-image:production
  * ghcr.io/amazeeio/build-deploy-image:production
  * docker.io/amazeeio/build-deploy-image:{upstreamTag}
  * ghcr.io/amazeeio/build-deploy-image:{upstreamTag}
