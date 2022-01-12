---
title: "Next-Gen Vulnerability Scanner"
linkTitle: "Next-Gen Vulnerability Scanner"
weight: 100
---

The next-gen vulnerability scanner based on [Grype](https://github.com/anchore/grype) 
is fully supported and is the default scanner for new Anchore Enterprise deployments that use Anchore-provided deployment templates. 
This scanner replaces the legacy vulnerability scanner in previous versions of Anchore Enterprise.

***Note:*** The legacy scanner is available for use but new features and improvements will only go into the Next-Gen scanner.

***Note:*** Changing the vulnerability scanner may require re-analysis of images if changing from Next-Gen back to legacy. See [Changing Providers](#Changing-Vulnerability-Providers) for more details. 

# Unified Vulnerability Feed and Feed Sync Behavior

The next-gen "Grype" vulnerability provider has different feed sync behavior for the vulnerabilities feeds. The legacy provider
has a set of individual feeds from different vulnerability sources such as "vulnerabilities", "nvdv2", "microsoft", "github", and "vulndb".
The new scanner has a single "vulnerabilities" feed with "nvd", "microsoft", "github", and "vulndb" as specific groups within the vulnerabilities
feed. This more accurately represents how vulnerabilities are managed in the new provider where a single image may have packages matched
against several sources. 

The single "vulnerabilities" feed is created in the on-premises feed service from the same sources and databases that the legacy scanner uses. There is a new
driver in the feed service that aggregates the feed data together into a single atomic database and makes it available to 
the policy engine, including timestamps and digests for verification. The policy engine synchronizes the entire vulnerability 
database in a single atomic operation.

**Visible changes to the operator:**

1. All groups within the "vulnerabilities" feed should show the same update timestamp.
2. Support for enabling and disabling specific groups within the "vulnerabilities" feed for the next-gen scanner is not supported and will return errors.

# Scanner Configuration & Vulnerability Providers

The scanner is configured as a vulnerability provider because it includes both the scanning engine and feed sync behaviors. 
A provider must be explicitly defined in the configuration file. If left unspecified, then the policy engine service will 
raise an error and fail to start. Anchore-provided deployment templates such as the [Helm Chart](https://github.com/anchore/anchore-charts/stable/anchore-engine) 
and [quickstart Docker Compose file]({{< ref "/docs/quickstart" >}}) set the default for new deployments to be the next-gen
provider and for upgrades will use scanner from the deployment being upgraded so as not to introduce an unexpected changes.

***Note:*** It is not possible to run both legacy and next-gen scanners at the same time. The configuration is set at policy-engine 
service startup, and cannot be changed on a running system without restarting the policy engine components. It should be set to
the same value for all policy engine instances in the deployment.

The following YAML snippet is from the _config.yaml_ used by the policy engine service and shows the "vulnerabilities" configuration
key and the values to configure the provider.

Next-Gen Provider ("grype"):
```yaml
    policy_engine:
        enabled: true
        ...
        vulnerabilities:
          provider: "grype"
          sync:
            enabled: true
            ssl_verify: true
            connection_timeout_seconds: 3
            read_timeout_seconds: 60
            data:
              grypedb:
                enabled: true
                url: https://<On-Premises Feed Service Host>:<port>/v1/databases/grype # This is typically setup for you in deployment templates
              ...
```

Legacy Provider ("legacy") configuration with specific feeds selection options:
```yaml
    policy_engine:
      enabled: true
      ...
      vulnerabilities:
        provider: "legacy"
        sync:
          enabled: true
          ssl_verify: true
          connection_timeout_seconds: 3
          read_timeout_seconds: 60
          data:
            # The 'grypedb' key is ignored since the provider=legacy
            grypedb:
              enabled: false
              url: ""
            # The following feeds are synced if provider is set to legacy
            vulnerabilities:
              enabled: true
              url: https://<On-Prem Feed Service Host>:<port>/v1/feeds
            nvdv2:
              enabled: true
              url: https://<On-Prem Feed Service Host>:<port>/v1/feeds
            github:
              enabled: true
              url: https://<On-Prem Feed Service Host>:<port>/v1/feeds
            # Enabling vulndb syncs vulndb vulnerability data from an on-premise anchore enterprise feeds service. Please contact
            # anchore support for finding out more about this service
            vulndb:
              enabled: true
              url: https://<On-Prem Feed Service Host>:<port>/v1/feeds
            # Enabling microsoft syncs MSRC data from an on-premise anchore enterprise feeds service. Please contact
            # anchore support for finding out more about this service
            microsoft:
              enabled: true
              url: https://<On-Prem Feed Service Host>:<port>/v1/feeds
            # Warning: enabling the packages and nvd sync causes the service to require much
            #   more memory to do process the significant data volume. We recommend at least 4GB available for the container
            # packages feed is synced if it is enabled regardless of the provider
            #packages:
            #  enabled: true
            #  url: ${ANCHORE_FEEDS_URL}

            ...
```

## New Deployments: Using the Next-Gen Provider: "grype"

This is the default setting for Anchore-provided templates for new deployments. To use it, you do not have to do
anything if you are deploying from the [Helm Chart](https://github.com/anchore/anchore-charts/stable/anchore-engine)
or [quickstart Docker Compose file]({{< ref "/docs/quickstart" >}}).

## New Deployments: Using the Legacy Provider: "legacy"

### With Quickstart docker-compose, do the following:
1. Install or update to the Enterprise 3.2.0 [Quickstart Docker Compose file]({{< ref "/docs/quickstart" >}}).
2. Add the following environment variable to the policy engine container section of the docker-compose.yaml file:


    policy-engine:
      ...
      environment:
      ...
      - ANCHORE_VULNERABILITIES_PROVIDER=legacy

3. Run `docker compose up -d` to start or restart the deployment.

### With Anchore-Provided Helm Chart
1. See [Installing With Helm]({{< ref "/docs/installation/helm" >}}) for information on the helm chart and customization.
2. Update the following value in `values.yaml`:


    anchorePolicyEngine
      ...
      vulnerabilityProvider: legacy

3. Run `helm install <deployment name> -f <your local values.yaml>` as per the helm install instructions.

After making the relevant change above and redeploying, the system will start up with the legacy vulnerability scanner enabled and will
sync the latest version of the vulnerability database.

***Note:*** The next-gen feeds will no longer be synced when legacy is configured. All vulnerability data
and scanning will come from the legacy feed. Any images analyzed while using the next-gen scanner must be re-analyzed in order
for the legacy provider to scan them accurately.


## Upgrading an Existing Deployment: Helm

We recommend upgrading previous versions of Anchore Enterprise to 3.2.0 first without changing the scanner, then use the new version
of the scanner in a development environment, and finally update the configuration in the production deployment.

1. Upgrade production environment to 3.2.0 using legacy scanner. Vulnerability provider = "legacy".
2. Install an evaluation deployment of 3.2.0 with the Next-Gen provider (provider="grype") in a development environment to
understand any potential changes on your exact workload and images.
3. When ready, modify the configuration of the production deployment to use the new scanner by setting the vulnerability provider to "grype". 

## Changing Vulnerability Providers

#### Updating from Legacy to Next-Gen
This path is relatively simple and no re-analysis of images is necessary for upgrades or reconfigurations. No image re-analysis is required.

#### Moving back from Next-Gen to Legacy
This change requires re-analyzing images that were analyzed while the next-gen scanner was enabled because it requires slightly
different analysis loading processes that are not used in the next-gen scanner. After following the re-configuration steps
you should re-analyze any image that has a _created_at_ date during the period that the next-gen scanner was in use.