---
title: "Application Management via AnchoreCTL"
linkTitle: "Application Management via AnchoreCTL"
weight: 7
---


Use AnchoreCTL to manage your applications. The AnchoreCTL application workflow would be like the following.

### Create a Named Application

Use AnchoreCTL to create a named application. For example: `anchorectl application create <name> <description>`

**Note**: Creating an application will also create an application version named `HEAD`, used to track the in-development version.


### List All Applications

Use the AnchoreCTL to list all applications. For example: `anchorectl application list`.


### Request an Individual Application

Request an individual application from Anchore via AnchoreCTL to view details about it. For example:
`anchorectl application get <application_id>`.


### Update and Change Properties of an Existing Application

Update and change the properties of an existing application via AnchoreCTL. For example, change the application name, version, or description as follows: `anchorectl application update <application_id> --name=<new_name> --description=<new_description>`.


### Remove an Application

Use AnchoreCTL to delete applications. This lets you remove applications that are no longer useful or important to you. For example:
`anchorectl application delete <application_id>`

