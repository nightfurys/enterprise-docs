---
title: "Requirements"
linkTitle: "Requirements"
weight: 3
---

## Introduction

This section details the requirements needed to run Anchore Enterprise

### Database

The Anchore Engine requires PostgreSQL version 9.6 or higher database to provide persistent storage for image, policy and analysis data.

This database can be run in a container, as configured in the example Docker Compose file or can be provided as an external service to the Anchore Engine.
PostgreSQL compatible databases such as Amazon RDS for PostgreSQL can be used for highly scalable cloud deployments.

### Memory

The Anchore Engine container will typically operate at a steady state using less than 2 GB of memory. However under load and during large feed synchronization operations, memory usage may burst above 4GB. Anchore recommends a minimum of 8GB for each service, for production deployments.

### Network

Anchore requires two categories of network access:

- Registry Access
    Network connectivity, including DNS resolution, to the registries from which the Anchore Engine needs to download images.
- Feed Service
    The Anchore Engine synchronizes feed data such as operating system vulnerabilities (CVEs) from the Anchore Cloud Service. The initial synchronization may take 5 to 10 minutes, based on network speed, after which time the Anchore Engine will download updated feed data at a user configurable interval, by default every 4 hours. Only a single end point is required for this synchronization, host: ancho.re TCP port: 443

### Security

Anchore is deployed as container images that can be run manually, using Docker Compose, Kubernetes or any container platform that supports Docker compatible images.

By default, the Anchore does not require any special permissions and can be run as an unprivileged container with no access to the underlying Docker host. 

**Note:** Anchore can be configured to pull images through the Docker Socket however this is not a recommended configuration as it grants the Anchore container added privileges and may incur a performance impact on the Docker Host.

### Storage

Anchore uses a PostgreSQL database to store persistent data for images, tags, policies, subscriptions and other artifacts. One persistent storage volume is required for configuration information and two optional storage volumes may be provided as described below.

- **Configuration volume**
    This volume is used to provide persistent storage to the container from which it will read its configuration files and optionally certificates. *Requirement*: Less than 1MB
- [Optional] **Temporary storage**
    The temporary storage volume is recommended but not required. During the analysis of images Anchore Engine downloads and extracts all of the layers required for an image. These layers are extracted and analyzed after which the layers and extracted data are deleted. If a temporary storage is not configured then the container's ephemeral storage will be used to store temporary files, however performance is likely be improved by using a dedicated volume. A temporary storage volume may also be used for image layer caching to speed up analysis. Requirement: 3 times the uncompressed image size to be analyzed. *Note*: For container hosts using OverlayFS or OverlayFS2 storage with a kernel older than 4.13 a temporary volume is required to work around a kernel driver bug.
- [Optional] **Object storage**
    The Anchore Engine stores documents containing archives of image analysis data and policies as JSON documents. By default these documents are be stored within the PostgreSQL database however the Anchore Engine can be configured to store archive documents in a filesystem (volume), S3 Object store, or Swift Object Store. *Requirement*: Number of images x 10MB (estimated).

### Enterprise UI 

The Anchore Enterprise User Interface is delivered as a Docker container that can be run on any Docker compatible runtime. 

The Anchore Enterprise UI module interfaces with Anchore Engine using the standard Anchore API endpoint. The UI does not require access to the Anchore Engine database, however a Redis server is used to store session information. 

- Runtime
    - Docker compatible runtime (version 1.12 or higher)

- Storage
    - Configuration volume This volume is used to provide persistent storage to the container from which it will read its configuration files and optionally certificates.
    Requirement: Less than 1MB

- Anchore Engine
    - A configured and operational Anchore Engine version 0.2.4 or higher. For installation instructions refer to the following link.

    **Note:** If the Anchore Engine has been configured to sync policies from the Anchore.IO service then you should disable the synchronization. In the credentials: section set the following option: auto_policy_sync: False

- Network
    - Ingress
        - The Anchore UI module publishes a web UI service by default on port 3000 however this port can be remapped.
    - Engress
        - The Anchore UI module requires access to two network services: 
            - Anchore Engine API end point (typically port 8228)
            - Redis Database (typically port 6379)

- Redis Service
    - Version 4 or higher

**Note:** If you're installing the Anchore Enterprise UI using our installation examples, they include a deployment of a redis service as part of the UI deployment process.

### Next Steps

If you feel you have a solid grasp of the requirements for deploying Anchore, we recommend following one of our [installation guides]({{< ref "/docs/installation" >}}).