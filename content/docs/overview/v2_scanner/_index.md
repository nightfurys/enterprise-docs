---
title: "V2 Vulnerability Scanner"
linkTitle: "v2 Scanner"
weight: 100
---

As of Anchore Enterprise 3.2.0, Anchore Enterprise is fully integrated with [Grype](https://github.com/anchore/grype) by default for vulnerability scanning. The V2 vulnerability scanner, based on Grype, replaces the legacy vulnerability scanner in previous versions of Anchore Enterprise.
You can keep the legacy vulnerability scanner while using Enterprise 3.2.0, you just need to specifically configure Anchore Enterprise to use the legacy scanner. 

***Note:*** The legacy vulnerability scanner will be removed in a future release.

VulnDB and Micrsoft feed data is supported for the V2 Vulnerability scanner, based on Grype. The feeds are fully synced, and Microsoft Windows image scanning is supported.

### Installing
As of 3.2.0, the V2 vulnerability scanner, based on Grype, is included with Anchore Enterprise by default. Anchore Enterprise can be configured to use the legacy vulnerability scanner. It is not possible to run
both legacy or V2 vulnerability scanners at the same time. This configuration is picked up at bootstrap, and cannot be changed on a running system.

#### To run the legacy vulnerability scanner with docker-compose, do the following:
1. Install or update to Anchore Enterprise 3.2.0.
2. Add the following environment variable to the policy engine container section of the docker compose file:


    policy-engine:
      ...
      environment:
      ...
      - ANCHORE_VULNERABILITIES_PROVIDER=legacy

3. Redeploy the services.

#### Running with helm
1. Install or update to Anchore Enterprise 3.2.0.
2. Update the following value in `stable/anchore-engine/values.yaml`:


    anchorePolicyEngine
      ...
      vulnerabilityProvider: legacy

3. Redeploy the services

After making the relevant change above and redeploying, the system will start up with the legacy vulnerability scanner enabled and will
sync the latest version of the database. 

***Note:*** The Grype feeds will no longer be synced when legacy is configured. All vulnerability data
and scanning will come from the legacy feed.

