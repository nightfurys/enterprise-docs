---
title: "Storage Overview"
linkTitle: "Storage"
weight: 6
---

## Storage During Analysis

### Scratch Space

Anchore uses a local directory for image analysis operations including downloading layers and unpacking the image content
for the analysis process. This space is necessary on each analyzer worker service and should not be shared. The scratch
space is ephemeral and can have its lifecycle bound to that of the service container.

### Layer Cache

The layer cache is an extension of the analyzer's scratch space that is used to cache layer downloads to reduce analysis
time and network usage during the analysis process itself. For more informaiton, see, [Layer Caching]({{< ref "layer_caching" >}}).

## Storing Analysis Results

Anchore Enterprise is a data intensive system and uses external storage systems for all data persistence. None of the services
are stateful in themselves.

For structured data that must be quickly queried and indexed, Anchore relies on PostgreSQL as its primary data store. Any
database that is compatible with PostgresSQL 10 or higher should work, such as Amazon Aurora and Google Cloud SQL.

For more information, see, [Database]({{< ref "database" >}})

For less structured data, Anchore implements an internal object store that can be overlayed on different backend providers, 
but defaults to also using the main postgres db to reduce the out-of-the-box dependencies. However, S3 and Swift APIs are
both supported for leveraging external systems.

For more information on configuration and requirements for the core database and object stores see, [Object Storage]({{< ref "object_store" >}}).

## Analysis Archive

To aid in capacity management, Anchore provides a separate storage location where completed image analysis can be moved to. This reduces consumption of database capacity and primary object storage. It also removes the analysis from most API actions
but makes it available to restore into the primary storage systems as needed. The analysis archive is 
configured as an alternate object store. For more information, see: [Configuring Analysis Archive]({{< ref "analysis_archive" >}}). 