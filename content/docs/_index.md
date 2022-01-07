---
title: "Anchore Enterprise Documentation"
linkTitle: "Anchore Enterprise Documentation"
weight: 20
menu:
  main:
    weight: 20
---

## Welcome to Anchore Enterprise

Anchore Enterprise automates the inspection, analysis, and evaluation of container images. Enterprise uses up-to-date vulnerability information and customer-defined checks to ensure container development and deployment is secure and compliant with organizational software policies.

Anchore Enterprise is a static-analysis and policy-based compliance system for Docker containers. Enterprise provides high confidence in container deployments by ensuring workload content meets the required criteria. Enterprise ultimately provides a policy evaluation result for each image: pass/fail against policies defined by the user. 

You can use Anchore Enterprise to generate a software bill of materials (SBOM) to ensure components are up-to-date and free of vulnerabilities. A software bill of materials is a comprehensive inventory of all of the individual artifacts, along with related metadata, that make up a container image. Artifacts cataloged in an SBOM include image layers and metadata, software packages and libraries, binaries, and files. Metadata for discovered artifacts is also collected, such as language, version, origin, and location in the filesystem. Anchore Enterprise uses SPDX to execute a Syft scan in the workspace directory and upload a workflow artifact SBOM in SPDX format. Anchore Enterprise includes SBOM functionality in the user interface (UI) or from the command line interface (CLI).

Additionally, the way that policies are defined and evaluated allows the policy evaluation itself to double as an audit mechanism that allows point-in-time evaluations of specific image properties and content attributes.

Some of the key capabilities are as follows:
- Providing visibility into container-based applications through a software bill of materials (SBOM).
- Assessing application security issues such as vulnerabilities, secrets, permissions, and more.
- Allowing user-defined policies to enforce security requirements, engineering best practices, and organizational priorities.
- Providing remediation workflows to help developers quickly resolve issues.
- Reporting that helps both application and security teams get a clear picture of where they are

For more information about Anchore Enterprise, see the following:
- [Introduction to Anchore Enterprise]({{< relref "overview" >}})
- [Architecture Overview]({{< relref "overview/architecture" >}})
- [Quickstart Guide Using Docker Compose]({{< ref "/docs/quickstart" >}})
- [Production Installation Guide using Helm in Kubernetes]({{< relref "installation/helm" >}})




