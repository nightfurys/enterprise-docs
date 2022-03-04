---
title: "Install with Helm on Kubernetes"
linkTitle: "Kubernetes with Helm"
weight: 3
---

## Introduction

The preferred method for deploying Anchore Enterprise on Kubernetes is with [Helm](https://helm.sh). The [Anchore Engine Helm Chart](https://github.com/anchore/anchore-charts/blob/master/stable/anchore-engine) now includes configuration options for a full Enterprise deployment. This deploys an Anchore Engine system as well as the enterprise extensions and services. 

The [README](https://github.com/anchore/anchore-charts/blob/master/stable/anchore-engine/README.md) in the chart repository contains more details on how to configure the Anchore Engine Helm chart and should always be consulted before proceeding with installation or upgrades.

Helm charts will update to install PostgresSQL 12 by default for new installs. You should use a PostgreSQL 10 or higher database. This may be handled by the chart or supplied externally, and executes in a service-based architecture utilizing the following Anchore Engine services: External API, Simplequeue, Catalog, Policy Engine, and Analyzer.

This chart can also be used to install the following Anchore Enterprise services: GUI, RBAC, On-prem Feeds. Enterprise services require a valid Anchore Enterprise license, as well as credentials with access to the private dockerhub repository hosting the images. These are not enabled by default.

Each of these services can be scaled and configured independently.

### Chart Details

The chart is split into global and service specific configurations for the OSS Anchore Engine, as well as global and services specific configurations for the Enterprise components.

  * The `anchoreGlobal` section is for configuration values required by all Anchore Engine components.
  * The `anchoreEnterpriseGlobal` section is for configuration values required by all Anchore Engine Enterprise components.
  * Service specific configuration values allow customization for each individual service.

For a description of each component, view the official documentation at: [Anchore Enterprise Service Overview](../../overview/architecture)

### Installation Steps

Enterprise services require an Anchore Enterprise license, as well as credentials with
permission to the private docker repositories that contain the enterprise images.

To use this Helm chart with the enterprise services enabled, perform these steps.

*Note: It's best to quote user supplied strings in case there are any special characters. For example, the username, password, and email supplied in Step 2 below might contain symbols, dots, underscores, etc.*

1. Create a Kubernetes secret containing your license file.

    `kubectl create secret generic anchore-enterprise-license --from-file='license.yaml=<PATH/TO/LICENSE.YAML>'`

1. Create a Kubernetes secret containing Dockerhub credentials with access to the private Anchore Enterprise repositories.

    `kubectl create secret docker-registry anchore-enterprise-pullcreds --docker-server='docker.io' --docker-username='<DOCKERHUB_USER>' --docker-password='<DOCKERHUB_PASSWORD>' --docker-email='<EMAIL_ADDRESS>'`

1. Install the Helm chart using a custom anchore_values.yaml file (see examples below). Note that <release_name> is a name that you choose.

    #### Helm v3 installation
    `helm repo add anchore https://charts.anchore.io`

    `helm install <release_name> -f anchore_values.yaml anchore/anchore-engine`

#### Example anchore_values.yaml file for installing Anchore Enterprise
*Note: This installs with chart managed PostgreSQL & Redis databases. This is not a production ready config.*

  ```
  ## anchore_values.yaml

  postgresql:
    postgresPassword: <PASSWORD>
    persistence:
      size: 50Gi

  anchoreGlobal:
    defaultAdminPassword: <PASSWORD>
    defaultAdminEmail: <EMAIL>
    enableMetrics: True

  anchoreEnterpriseGlobal:
    enabled: True

  anchore-feeds-db:
    postgresPassword: <PASSWORD>

  anchore-ui-redis:
    password: <PASSWORD>
  ```

### Upgrading from a Previous Helm deployment
A Helm post-upgrade hook job has been added starting with Chart version 1.6.0 - this job will shut down all previously running Anchore services and perform the Anchore DB upgrade process using a Kubernetes job. 
The upgrade will only be considered successful when this job completes successfully. Performing an update after v1.6.0 will cause the Helm client to block until the upgrade job completes and the new Anchore service pods are started.

```
helm repo update
helm upgrade <release_name> anchore/anchore-engine -f anchore_values.yaml
```

### Next Steps

Now that you have Anchore Enterprise running, you can begin to learning more about Anchore Enterprise architecture, Anchore concepts, and Anchore usage.

- To learn more about Anchore Enterprise, go to [Overview]({{< ref "/docs/overview" >}})
- To learn more about Anchore Concepts, go to [Concepts]({{< ref "/docs/overview/concepts" >}})
- To learn more about using Anchore Usage, go to [Usage]({{< ref "/docs/using" >}})
