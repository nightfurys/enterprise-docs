---
title: "Application Management via the Anchore API"
linkTitle: "Application Management via the Anchore API"
weight: 3
---

Use the Anchore API to manage your applications.  For more information about using Anchore APIs via Swagger, see: [Using the Anchore API](https://docs.anchore.com/current/docs/using/api_usage/).

The API application workflow would be like the following.

### Create an Application

Create an application by POSTing the JSON in the block below to `http://<host:port>/v1/enterprise/applications/`.

```
{
   "name": "Application name",
   "description": "Application description"
}
```

**Note**: Creating an application will also create an application version named `HEAD`, used to track the in-development version.

### GET the List of All Applications

GET the list of all applications from `​​http://<host:port>/v1/enterprise/applications/`. 

Add the `include_versions=true` flag to include all application versions under each application in the API response.
 

### GET a Single Application

GET a single application by adding the `application_id` to the GET command. For example: `http://<host:port>/v1/enterprise/applications/<application_id>/`.

Add the `include_versions=true` flag to include all application versions under each application in the API response.
 

### Update an Existing Application

PUT the following to `http://<host:port>/v1/enterprise/applications/<application_id>/` to update an existing application, such as changing the name and description.

```
{
   "name": "Updated application name",
   "description": "Updated application description"
}
``` 

### Remove a Specified Application

Send a DELETE to `http://<host:port>/v1/enterprise/applications/<application_id>/` to remove the specified application. 
