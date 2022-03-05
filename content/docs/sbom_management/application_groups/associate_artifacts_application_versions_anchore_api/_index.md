---
title: "Associating Artifacts with Application Versions via the Anchore API"
linkTitle: "Associating Artifacts with Application Versions via the Anchore API"
weight: 5
---


## Add an Artifact Association

The following commands require source or image artifacts to already be added to the Anchore Enterprise instance before they can be associated with the application version. See [SBOM Management]({{< ref "/docs/sbom_management" >}}) for more information.

**Note**: Keep track of the uuid of the sources, and the digest of the images that you will add to the application version. These are the values used to associate each artifact with the application version.

The response body for each artifact association request will contain an `artifact_association_metadata` block with an `association_id` field in it. This field uniquely identifies the association between the artifact and the application version, and is used in requests to remove the association.


### Associate a Source Artifact

To associate a source artifact, POST the following body to `http://<host:port>/v1/enterprise/applications/<application_id>/versions/<application_version_id>/artifacts`.

Note the fields specific to source artifacts in contrast to the image artifact in the next example.

```
{
    "artifact_type": "source",
    "artifact_keys": {
        "uuid": "<source uuid>"
    }
}
```

### Associate an Image Artifact

To associate an image artifact, POST the following body to `http://<host:port>/v1/enterprise/applications/<application_id>/versions/<application_version_id>/artifacts`.

Note the fields specific to image artifacts in contrast to the source artifact in the previous example.

```
{
    "artifact_type": "image",
    "artifact_keys": {
        "image_digest": "<image_digest>"
    }
}
```

## List All Associated Artifacts

Each artifact in the response body will contain an `artifact_association_metadata` block with an `association_id` field in it. This field uniquely identifies the association between the artifact and the application version, and is used in requests to remove the association.

### List All Artifacts Associated with an Application Version

To list all artifacts associated with an application version, GET `http://<host:port>/v1/enterprise/applications/<application_id>/versions/<application_version_id>/artifacts`.

### Filter the Results by Artifact Type

To filter the results by artifact type, add the `artifact_types=<source,image>` query parameter.

## Remove an Artifact Association

Send a DELETE request to `http://<host:port>/v1/enterprise/applications/<application_id>/versions/<application_version_id>/artifacts/<association_id>`.








