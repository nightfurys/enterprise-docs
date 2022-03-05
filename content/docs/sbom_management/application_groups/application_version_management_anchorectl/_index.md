---
title: "Application Version management via AnchoreCTL"
linkTitle: "Application Version management via AnchoreCTL"
weight: 8
---

Use AnchoreCTL to manage your application versions.  

The AnchoreCTL application workflow would be like the following.

### Create and Store Versions of your Application

Use AnchoreCTL to create and store versions of your applications. Versioning is useful for audit compliance and reporting. Use the following AnchoreCTL command to create a version:

`anchorectl application version add <application_id> <version_name>`

### List All Application Versions

Use AnchoreCTL to list all application versions that are associated with an application.

`anchorectl application version list <application_id>`

### Update Application Version Properties

Use AnchoreCTL to update application version properties for an existing application in Anchore.

`anchorectl application version update <application_id> <version_id> <version_name>`

### Request a Specific Application Version

Use AnchoreCTL to request a specific version of an application to view its details. The following example shows the AnchoreCTL command to request a version:

`anchorectl application version get <application_id> <application_version_id>`

### Remove Application Version

Use AnchoreCTL to delete application versions. This lets you remove application versions that are no longer useful or important to you.

`anchorectl application version delete <application_id> <application_version_id>`