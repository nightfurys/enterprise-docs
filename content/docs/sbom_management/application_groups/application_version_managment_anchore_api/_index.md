---
title: "Application Version Management via the Anchore API"
linkTitle: "Application Version Management via the Anchore API"
weight: 4
---

Use the Anchore API to manage your application versions.  For more information about using Anchore APIs via Swagger, see: [Using the Anchore API](https://docs.anchore.com/current/docs/using/api_usage/).

The API application workflow would be like the following.


### Create an Application Version

To use the Anchore API to create an application version that is associated with an already-existing application, POST the JSON in the block below to `http://<host:port>/v1/enterprise/applications/<application_id>/versions/`.

```
{
   "version_name": "v1.0.0"
}
```

### GET the List of All Application Versions

GET the list of all application versions for the application from `http://<host:port>/v1/enterprise/applications/<application_id>/` versions. 
 

### GET a Single Application Version

GET a specific application version from `http://<host:port>/v1/enterprise/applications/<application_id>/versions/<application_version_id>`.
 

### Update an Existing Application

To update the name of an existing application version, PUT the following to `http://<host:port>/v1/enterprise/applications/<application_id>/versions/<application_version_id>`

```
{
    "version_name": "v1.0.1"
}
```

### Remove a Specified Application Version

To delete an application version, Send a DELETE to `http://<host:port>/v1/enterprise/applications/<application_id>/versions/<application_version_id>`.
 
