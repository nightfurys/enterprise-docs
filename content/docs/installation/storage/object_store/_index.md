---
title: "Object Storage"
linkTitle: "Object Storage"
weight: 6
---

Anchore Enterprise uses a PostgreSQL database to store structured data for images, tags, policies, subscriptions and metdata
about images, but other types of data in the system are less structured and tend to be larger pieces of data. Because of
that, there are benefits to supporting key-value access patterns for things like image manifests, analysis reports, and 
policy evaluations. For such data, Anchore has an internal object storage interface that, while defaulted to use the
same Postgres database for storage, can be configured to use external object storage providers to support simpler capacity
management and lower costs. The options are:

- PostgreSQL database (default)
- Filesystem 
- S3 Object Store
- Swift Object Store

The configuration for the object store is set in the catalog's service configuration in the config.yaml.



 