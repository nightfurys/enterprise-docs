---
title: "Overview"
linkTitle: "Overview"
weight: 3
---

### What is Anchore Enterprise?

**_Anchore Enterprise_** automates the inspection, analysis, and evaluation of container images. Enterprise uses up-to-date vulnerability information and customer-defined checks to ensure container deployments are secure and compliant with organizational software policies.

Anchore Enterprise is a Docker container static-analysis and policy-based compliance system. Enterprise provides high confidence in container deployments by ensuring workload content meets the required criteria. Enterprise ultimately provides a policy evaluation result for each image: pass/fail against policies defined by the user. 

You can use Anchore Enterprise to generate a software bill of materials (SBOM) to ensure components are up-to-date and free of vulnerabilities. A software bill of materials is a comprehensive inventory of all of the individual artifacts, along with related metadata, that make up a container image. Artifacts cataloged in an SBOM include image layers and metadata, software packages and libraries, binaries, and files. Metadata for discovered artifacts is also collected, such as language, version, origin, and location in the filesystem. Anchore Enterprise includes SBOM functionality in the user interface (UI) or from the command line interface (CLI).

Additionally, the way that policies are defined and evaluated allows the policy evaluation itself to double as an audit mechanism that allows point-in-time evaluations of specific image properties and content attributes.

## Software Components

- On-Premises Anchore Enterprise 
  - Web UI 
  - API
  - Notifications
  - RBAC
  - Reporting
  - Worker
  - Queue
  - Catalog
  - CLI
- On-Premises Feed Service

![Enterprise Overview](EnterpriseOverview.png)

### Next Steps

Now, let's get familiar with the [Architecture]({{< ref "architecture" >}}) of Anchore Enterprise.
