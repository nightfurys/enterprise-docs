---
title: "Get an Application Version SBOM - AnchoreCTL"
linkTitle: "Get an Application Version SBOM - AnchoreCTL"
weight: 3
---

Run the `anchorectl application version sbom <application_id> <application_version_id> -o=json` command to download a combined SBOM for all components and supply-chain elements of an application. This lets you easily archive the components, or provide them to others for verification process compliance requirements. The data structure includes the version and version metadata for the application version, along with the SBOMs for each associated artifact.

To filter the results by artifact type, add the argument `–-artifact_types=<source,image>` to the end of the command.
