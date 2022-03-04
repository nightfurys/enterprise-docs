---
title: "Anchore Enterprise Vulnerability Scanner"
linkTitle: "Anchore Enterprise Vulnerability Scanner"
weight: 100
---

The Anchore Enterprise vulnerability scanner scans applications for known vulnerabilities. The scanner updates vulnerability feed data on a configurable basis, then uses stored SBOMs to quickly scan for vulnerabilities in applications. By relying on local feeds as well as pre-computed SBOMs, the scanner is able to quickly scan a large number of applications many times a day.

While the SBOM will not change for cataloged applications, new vulnerabilities are constantly being found and reported. Anytime new vulnerabilities are added to public data sets, the Anchore Enterprise feed service will download and update the local data. Because the vulnerability data is always changing, it is important to continuously scan applications to alert on new findings in a way that does not create unnecessary load on the analyzers.


# Unified Vulnerability Feed and Feed Sync Behavior

The vulnerability scanner uses a single “vulnerabilities” feed as a result of aggregating multiple source feeds combined with multiple source feeds. 

The single “vulnerabilities” feed is created in the on-premises feed service from the same sources and databases that the vulnerability scanner uses. There is a driver in the feed service that aggregates the feed data together into a single atomic database and makes it available to the policy engine, including timestamps and digests for verification. The policy engine synchronizes the entire vulnerability database in a single atomic operation.


**Visible changes to the operator:**

1. All groups within the "vulnerabilities" feed should show the same update timestamp.
2. Support for enabling and disabling specific groups within the "vulnerabilities" feed for the vulnerability scanner is not supported and will return errors.

# Vulnerability Scanner Configuration and Vulnerability Providers

The vulnerability scanner is configured as a vulnerability provider because it includes both the scanning engine and feed sync behaviors. 
A provider must be explicitly defined in the configuration file. If left unspecified, then the policy engine service will 
raise an error and fail to start. Anchore-provided deployment templates such as the [Helm Chart](https://github.com/anchore/anchore-charts/stable/anchore-engine) 
and [quickstart Docker Compose file]({{< ref "/docs/quickstart" >}}) set deployments to the vulnerability provider.

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
                url: https://<On-Premises Feed Service Host>:<port>/v1/databases/grype # This is typically set up for you in deployment templates
              ...
```

## Using the Vulnerability Scanner

This is the default setting for Anchore-provided templates for deployments. To use it, you do not have to do
anything if you are deploying from the [Helm Chart](https://github.com/anchore/anchore-charts/stable/anchore-engine)
or [quickstart Docker Compose file]({{< ref "/docs/quickstart" >}}).


## Upgrading an Existing Deployment: Helm

We recommend upgrading previous versions of Anchore Enterprise to the latest version first without changing the vulnerability scanner, then use the new version of the vulnerability scanner in a development environment. Then update the configuration in the production deployment.