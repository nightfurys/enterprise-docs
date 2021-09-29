---
title: "Installing Anchore Enterprise"
linkTitle: "Installing"
weight: 4
---

Anchore Enterprise and its components are delivered as Docker container images which can be deployed co-located, fullly distributed, or anything in-between. As such, it can scale out to increase analysis throughput. The only external system required is a PostgreSQL database (9.6+) that all services connect to, but do not use for communication beyond some very simple service registration/lookup processes. The database is centralized simply for ease of management and operation. For more information on the architecture, go to [Anchore Enterprise Architecture]({{< ref "/docs/overview/architecture" >}}).

As of Anchore Enterprise 3.2.0, Anchore Enterprise is fully integrated with [Grype](https://github.com/anchore/grype) by default for vulnerability scanning. The V2 vulnerability scanner, based on Grype, replaces the legacy vulnerability scanner in previous versions of Anchore Enterprise.
You can keep the legacy vulnerability scanner while using Enterprise 3.2.0, you just need to specifically configure Anchore Enterprise to use the legacy scanner. 

***Note:*** The legacy vulnerability scanner will be removed in a future release.

Jump to the installation guide of your choosing:

- [Docker Compose]({{< ref "/docs/installation/docker_compose" >}})
- [Kubernetes]({{< ref "/docs/installation/helm" >}})