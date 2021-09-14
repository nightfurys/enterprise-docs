---
title: "Tech Preview - v2 Vulnerability Scanner"
linkTitle: "v2 Scanner"
weight: 100
---

Anchore Enterprise 3.1.0 includes a limited-functionality tech preview of a new v2 scanner based on [Grype](https://github.com/anchore/grype)
for vulnerability scanning. This integration will replace the v1 vulnerability scanner in a future version of Anchore Enterprise,
but is provided in this release in a preview capacity so users can try it out.

***Note:*** This tech preview is not intended for use in production environments. It should be installed in sandbox exnvironments,
and is strictly provided here to give users an early, hands-on preview of the feature. It may not include all of the
functionality of the legacy scanner. Please report any issues found with it via a support ticket.

VulnDB and Micrsoft feed data is not yet supported for the tech preview Grype vulnerability scanner. Those feeds will not be synced,
and Windows image scanning is subsequently not supported.

### Installing
As of 3.1.0, Anchore Enterprise can be configured to use either the legacy or grype vulnerability scanner. It is not possible to run
both vulnerability scanners at the same time. This configuration is picked up at bootstrap, and cannot be changed on a running system.

The tech preview grype scanner is intended for use in sandbox or staging environments in the current release. Downgrading from the
grype scanner back to the legacy scanner is not supported and will cause data issues.

#### Running with docker-compose
1. Install or update to Anchore Enterprise 3.1.0.
2. Add the following environment variable to the policy engine container section of the docker compose file:


    policy-engine:
      ...
      environment:
      ...
      - ANCHORE_VULNERABILITIES_PROVIDER=grype

3. Redeploy the services.

#### Running with helm
1. Install or update to Anchore Enterprise 3.1.0.
2. Update the following value in `stable/anchore-engine/values.yaml`:


    anchorePolicyEngine
      ...
      vulnerabilityProvider: grype

3. Redeploy the services


    helm upgrade

After making the relevant change above and redeploying, the system will start up with the grype vulnerability scanner enabled and will
sync the latest version of grype db. Note that legacy feeds will no longer be synced while grype is configured. All vulnerability data
and scanning will continue to come from the locally deployed feed service for Enterprise users.

