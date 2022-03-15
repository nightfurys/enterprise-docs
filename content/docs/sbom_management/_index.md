---
title: "SBOM Generation and Management"
linkTitle: "SBOM Generation and Management"
weight: 6
---

An SBOM is a comprehensive inventory of the individual components from source repositories and container images. One or more SBOMs can be grouped together in higher-level applications to visualize related artifacts in applications by versions. Applications are the top-level building block in a hierarchical view, and can represent any project your teams deliver.

Security Engineers are often required to investigate security issues that stem from a source repository or from container images. The security team can use Anchore Enterprise to identify any open source security vulnerabilities or policy evaluation results which originate from a source code repository or image container. This helps them catch security issues earlier. 

You can generate SBOMs using AnchoreCTL as part of a command line or CI/CD workflow, through pulling content from a registry, or by submitting an artifact to the Anchore API. 

SBOMs can be managed using the command line, API or GUI, where contents can be grouped together, annotated, viewed or searched. Artifact metadata, vulnerability information, and policy evaluations can also be viewed and managed through the same interfaces.

All SBOMs can be downloaded into a variety of formats, either individually or collectively, to be sent to security teams, customers or end-users.