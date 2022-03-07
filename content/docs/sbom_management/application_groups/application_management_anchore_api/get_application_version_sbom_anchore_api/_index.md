---
title: "Get an Application Version SBOM - Anchore API "
linkTitle: "Get an Application Version SBOM - Anchore API "
weight: 3
---

Users can also use the application API to generate a combined SBOM for all artifacts within an application version. This lets you easily archive the components, or provide them to others for verification process compliance requirements. The data structure metadata for the application and application version, along with the SBOMs for each artifact associated with the application version.

### Download a Combined SBOM

To download a combined SBOM, GET the application version SBOM from `http://<host:port>/v1/enterprise/applications/<application_id>/versions/<application_version_id>/sboms/json`.


### Filter Results by Artifact Type

To filter the results by artifact type, add the `artifact_types=<source,image>` query parameter.

