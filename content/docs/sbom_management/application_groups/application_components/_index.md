---
title: "Application Components"
linkTitle: "Application Components"
weight: 1
---


## Applications

Applications are the top-level building block in this hierarchical view, containing artifacts like packages or image artifacts. Applications can represent any project your teams deliver. Applications have user-specified `name` and `description` fields to describe them. Applications are expected to be long-lived constructs, typically with multiple versions added over time.


### Application Versions

Each application is associated with one or more application versions. Application versions track the specific grouping of artifacts that comprise a product version. They have one directly user-editable field called version_name which reflects the name of the product’s application version. This field has no special constraints on it, so you can use it to reflect the versioning scheme or schemes for your projects.

Each application, on creation, automatically has one application version created for it, named “HEAD”. “HEAD” is a special version meant to track the in-development version of your product through its release. A typical flow is that, as your CI jobs build new versions of your software, they will add new versions of your source and image artifacts to Anchore Enterprise and associate them with your HEAD application version. On release, you update your “HEAD” version to reflect the actual name of your release (for example, “v1.0.0”), and then create a new “HEAD” version to track development on the next version of your project. Any application version, including the “HEAD” version, can be deleted if needed.

Application versions, rather than applications, are directly associated with artifacts from sources and images. As your project grows and evolves, the packages and package versions associated with it will naturally change and advance over time. Associating them with application versions (rather than directly with applications) allows older application versions to maintain their associations with the older packages that compose them. This allows for historical review auditing and comparison across versions.


### Associating Artifacts with Application Versions

An artifact is a generic term that encompasses any SDLC artifact that can be associated with an application version. Currently, that includes sources and images. The application API has endpoints (and AnchoreCTL has subcommands) to manage the associations between application versions and artifacts.

One important distinction is that these endpoints and commands are operating on the association between artifacts and application versions, not on the artifacts themselves. A source or image must already be added to Anchore Enterprise before it can be associated with an application. Similarly, removing the association with an application version does not remove the artifact from Anchore Enterprise. It can later be reassociated with the application version, or another application version. 


### Application Version SBOMs

Once an application version has artifacts associated with it, users can generate an application version SBOM, which aggregates the SBOMs for all of the artifacts associated with the application version.