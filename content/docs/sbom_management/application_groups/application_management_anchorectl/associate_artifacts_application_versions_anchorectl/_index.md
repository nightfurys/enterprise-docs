---
title: "Associate Artifacts with Application Versions - AnchoreCTL"
linkTitle: "Associate Artifacts with Application Versions - AnchoreCTL"
weight: 9
---

### Add an Artifact Association

The following commands require source or image artifacts to already be added to the Anchore Enterprise instance before they can be associated with the application version. 

**Note**: Keep track of the uuid of the sources, and the digest of the images that you will add to the application version. These are the values used to associate each artifact with the application version.

The response body for each artifact association request will contain an `artifact_association_metadata` block with an `association_id` field in it. This field uniquely identifies the association between the artifact and the application version, and is used in requests to remove the association.


### Associate a Source Artifact

To associate a source artifact:
`anchorectl application version artifact add <application_id> <application_version_id> image --image_digest=<image_digest>`


### Associate an Image Artifact

To associate an image artifact:
`anchorectl application version artifact add <application_id> <application_version_id> source --uuid=<source_uuid>`

### List All Associated Artifacts

Each artifact in the response body will contain an `artifact_association_metadata` block with an `association_id` field in it. This field uniquely identifies the association between the artifact and the application version, and is used in requests to remove the association.

### List All Artifacts Associated with an Application Version

To list all artifacts associated with an application version:
`anchorectl application version artifact list <application_id> <application_version_id>`


### Filter the Results by Artifact Type

To filter the results by artifact type, add the argument `--artifact_types=<source,image>` to the end of the command.


### Remove an Artifact Association

Get the `association_id` of one of the associated artifacts and run the following command: 
`anchorectl application version artifact delete <application_id> <application_version_id> <association_id>`


