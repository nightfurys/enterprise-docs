---
title: "Frequently Asked Questions"
linkTitle: "FAQ"
weight: 2
---

**Open Source vs Enterprise**

[What are the main differences between Anchore Engine and Anchore Enterprise?](#2)

**Environment**

[Where does Anchore run? On-prem? Cloud? Hosted?](#3)

[Can Anchore be used without internet access?](#4)

[What K8S resource allocations are required with Amazon EKS?](#5)

[What are the database requirements?](#6)

[What base image is Anchore Enterprise built on?](#7)

[Why does the Anchore Enterprise container keep exiting?](#8)

**Feeds**

[Where does Anchore get its vulnerability data from?](#9)

[Why aren’t my feeds syncing?](#10)

[How do I manually trigger a feed sync?](#11)

[How often are feeds synced?](#12)

[How long should a feed sync take?](#13)

[Can I only enable certain feeds?](#14)

[Why am I seeing 'UnicodeEncodeError: 'ascii' codec can't encode character in the policy engine logs?](#15)

**Integration**

[What registries are supported?](#16)

[What CI/CD systems are supported?](#17)

[What notification systems are supported? ](#18)

[How does anchore integrate with Kubernetes?](#19)

[How do I access content in my private registry?](#20)

**Scanning**

[What packages does Anchore scanning support?](#21)

[Do I need to rescan images?](#22)

[How can I scan local images?](#23)

[Can Anchore look inside a file and scan for contents?](#24)

**CLI**

[Why do I get an “Unauthorized” error when using the CLI?](#25)

**Vulnerability Results**

[Why am I getting false positives?](#26)

[What can I do in response to a false positive?](#27)

**Reports**

[Can I generate reports using Anchore Enterprise?](#28)

**Monitoring**

[How do I monitor my Anchore deployment?](#29)

**Swagger**

[How can I deploy an interactive Swagger UI?](#30)

**Support**

[Where can I ask other questions?](#31)

---

## Open Source vs Enterprise
### What are the main differences between Anchore Engine and Anchore Enterprise? {#2}
Anchore Engine is an Apache v2-licensed open source project. Anchore Enterprise is a proprietary commercial product which adds additional functionality to Anchore Engine. Anchore Enterprise provides a GUI, enhanced vulnerability feed data, enterprise feed service (for running disconnected from the internet), enterprise reporting service (based on GraphQL) and integrations for popular workflow tools like Github, Jira and others, as well enterprise authentication systems like LDAP and SSO.


## Environment
### Where does Anchore run? On-prem? Cloud? Hosted? {#3}
Anchore can be installed and run on any environment where a container can be run, be this on-premises with a platform like OpenShift or in the public cloud using services like Amazon ECS, EKS et.

### Can Anchore be used without internet access? {#4}
Anchore Enterprise needs to connect to the internet to download the initial vulnerability database and all updates made to it as upstream sources (NVD, Red Hat RHSAs etc) add fresh data. The database service is currently hosted on Amazon Web Services. No other outbound internet access is needed (in contrast to other scanning solutions which push content out to the internet for scanning. For users requiring disconnected installations, Anchore Enterprise provides the ability to run the feed service locally.

### What K8S resource allocations are required with Amazon EKS? {#5}
Minimum resource allocations are included in the Helm chart for Anchore Enterprise which is accessible in our [repository](https://github.com/valancej/Anchore-Enterprise-k8s/blob/master/anchore_values.yaml).

### What are the database requirements? {#6}
Anchore Enterprise requires access to a PostgreSQL database to operate. This database can run in a container as a persisted volume or via an external service such as Amazon RDS. At a minimum, we recommend at least 100GB of storage allocated for images, tags, subscriptions, policies, and other artifacts.  Also, the database should have a max client connections setting of 2000 or higher. This should be increased where you are running more than the default number of Anchore services.

### What base image is Anchore Enterprise built on? {#7}
Red Hat’s UBI image. See: [https://github.com/anchore/anchore-engine/blob/master/Dockerfile](https://github.com/anchore/anchore-engine/blob/master/Dockerfile)

### Why does the Anchore Enterprise container keep exiting? {#8}
The first step here should be to inspect the logs for the exited container. For Docker, running `docker logs <exited container id> ` should return the reason the container exited.

If you see `[MainThread] [anchore_manager.cli.service/start()] [ERROR] Error: cannot locate configuration file (/config/config.yaml)` in the logs, you should verify you have set up the directory for your Anchore installation correctly.

If you are following the quickstart guide, your directory structure should look like the following:

```
cd ~/aevolume
# find .
.
./config
./config/config.yaml
./db
./docker-compose.yaml
```

If you still see the above error, take a look at the `docker-compose.yaml` file and confirm that the config volume mount definition is correct.

Example:

```
volumes:
   - ./config:/config/:z
```

**Note:** If you are following the quickstart guide, you should not need to make any modifications to the configuration files, they are designed to work out of the box.



## Feeds
### Where does Anchore get its vulnerability data from? {#9}
Anchore Enterprise uses feeds from most popular operating systems vendors including Red Hat/Centos, Debian, Ubuntu, Alpine, Oracle, etc. For non-operating system packages, such as NPMs, Gems, etc, NVD is the primary source. Anchore Enterprise adds additional licensed, proprietary sources that provide extra information about library packages and other products. More information is available in the [documentation]({{< ref "/docs/using/cli_usage/feeds" >}}).

### Why aren’t my feeds syncing? {#10}
The initial sync can take several hours depending on host specifications (memory/CPU), network bandwidth, and disk space.  Upon a fresh installation of Anchore Enterprise, the system will take some time to bootstrap. CVE data for Linux distributions such as Alpine, CentOS, Debian, Oracle, Red Hat and Ubuntu will be downloaded. The initial sync may take several hours, depending on the speed of your network connection. First, verify feeds aren’t syncing with:


```
	anchore-cli system feeds list
```


If certain feeds are showing ‘0’ records, you can look at the output of:


```
	anchore-cli event list
```


specifically focusing on the following events:


```
	Error
	System.feeds.sync.group_started
	System.feeds.sync.group_started
	System.feeds.sync.group_completed,
	System.feeds.sync.group_failed
```


You can find more details on an event with:


```
	anchore-cli event get <event_id>
```


For a deeper view of events, see [working with event logs]({{< ref "/docs/using/cli_usage/event" >}}).

One of the most helpful tools in identifying why feeds may not be syncing is to view the logs for the policy-engine container.  There will be lines in the log indicating the merging of records from the feed into your local DB installation.  If there are errors stating the merge has been rolled back, look into memory utilization during the feed sync; an out of memory (OOM) error may occur during the sync and roll back the transaction.


### How do I manually trigger a feed sync? {#11}
A [sync operation](https://docs.anchore.com/current/docs/using/cli_usage/feeds/feed_synchronization/#manually-initiating-feed-sync) can be manually initiated by running:


```
anchore-cli system feeds sync
```


However, this is an operation that is not required under normal operation, only used for advanced troubleshooting and testing.

### How often are feeds synced? {#12}
Feed data is synced by default every ~6 hours.  This is a configurable setting that can be updated to user specifications.  For more information, see our [documentation]({{< ref "/docs/using/cli_usage/feeds/feed_configuration.md#feed-synchronization-interval" >}}).

### How long should a feed sync take? {#13}
There is no exact time frame for the initial sync to complete as it depends heavily on environmental factors, such as the host’s memory/cpu allocation, disk space, and network bandwidth.  Generally, the initial sync should complete within 8 hours but may take longer.  Subsequent feed updates are much faster as only deltas are updated.

### Can I only enable certain feeds? {#14}
Yes. See the [documentation]({{< ref "/docs/using/cli_usage/feeds/feed_configuration.md#feed-synchronization-interval" >}}).

### Why am I seeing 'UnicodeEncodeError: 'ascii' codec can't encode character in the policy engine logs?{#15}

If you see the following error in the policy engine logs:

```
UnicodeEncodeError: 'ascii' codec can't encode character '\xa0' in position 87: ordinal not in range(128)
[service:policy-engine] 2020-04-28 15:36:46+0000 [-] [Thread-45740] [anchore_engine.services.policy_engine.engine.logs/exception()] [ERROR] Error syncing (operation_id=56e48fd78a0f48078cd96d86a5530098, feed=vulndb, group=vulndb:vulnerabilities)
```

Check the configuration of your PostgresSQL database service. The database encoding should be `UTF8`.

Correct Output:

```
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
```

If the database encoding is `SQL_ASCII` you will need to change the encoding to the correct `UTF8`.

## Integration
### What registries are supported? {#16}
Any registry which supports the Docker v2 API is supported, including Docker Hub, Quay, Harbor, Artifactory and all public cloud registries.

### What CI/CD systems are supported? {#17}
Native Plugins are available for Jenkins, CircleCI, Codefresh and CodeReady. Other CI/CD integrations can be used via the anchore-cli tool.

### What notification systems are supported? {#18}
Anchore Enterprise can send alerts to Jira, MS Teams, Github or email.

### How does anchore integrate with Kubernetes? {#19}
The Kubernetes Admission Controller (KAC) for Anchore is a piece of code which causes Kubernetes to request a scan of every image about to be deployed. Anchore can then scan, scan and warn, or scan and block according to policies.

### How do I access content in my private registry? {#20}
Anchore Enterprise will attempt to download images from any registry without requiring further configuration.
However if your registry requires authentication then the registry and corresponding credentials will need to be defined.

* The --insecure option

Anchore Enterprise will only pull images from a TLS/SSL enabled registry. If the registry is protected with a self signed certificate or a certificated signed by an unknown certificate authority then the `--insecure` option can be passed which instructs the system not to validate the certificate.

`anchore-cli registry add REGISTRY USERNAME PASSWORD --insecure`

* The --skip-validate option

Anchore Enterprise attempts to perform a credential validation upon registry addition, but there are cases where a credential can be valid but the validation routine can fail (in particular, credential validation methods are changing for public registries over time).  If you are unable to add a registry but believe that the credential you are providing is valid, or you wish to add a credential to anchore before it is in place in the registry, you can bypass the registry credential validation process using the `--skip-validate` option to the 'registry add' command.

`anchore-cli registry add REGISTRY USERNAME PASSWORD --skip-validate`


## Scanning
### What packages does Anchore scanning support? {#21}
For operating systems: RPM, Deb, APK

For Languages: Python (PIP), Ruby Gems, NPM, Java (jar, ear, war, hpi), .NET (NuGet)

### Do I need to rescan images? {#22}
No! Anchore Enterprise maintains a complete inventory of every file, including its contents and metadata, so when a new vulnerability is found, it only needs to scan the database and not the original image.

### How can I scan local images? {#23}
The Anchore Inline Scanner tool allows you to scan a local image on disk without needing the persistent web service from Anchore Enterprise available. You can also do the local scan and then pass the details to Anchore Enterprise after completion. More information is available in our [documentation](https://docs.anchore.com/current/docs/using/integration/ci_cd/inline_analysis/).

### Can Anchore look inside a file and scan for contents? {#24}
Yes, regexps can be applied in policies rules to scan for arbitrary content.


## CLI
### Why do I get an Unauthorized” error when using the CLI? {#25}
If you run into an "Unauthorized" error, verify you have configured the Anchore CLI correctly, as this error is most commonly seen when the Username, Password, or Service URL are improperly set.

By default the Anchore CLI will try to connect to the Anchore Enterprise at http://localhost:8228/v1 with no authentication. The username, password and URL for the server can be passed to the Anchore CLI as command line arguments.

```
    --u   TEXT   Username     eg. admin (default)
    --p   TEXT   Password     eg. foobar (default)
    --url TEXT   Service URL  eg. http://localhost:8228/v1
```


Rather than passing these parameters for every call to the cli they can be stores as environment variables.

```
    ANCHORE_CLI_URL=http://myserver.example.com:8228/v1
    ANCHORE_CLI_USER=admin
    ANCHORE_CLI_PASS=foobar
```

**Note:** When passing the parameters through the command line, order matters. For example,

```
	anchore-cli --url http://localhost:8228/v1 --u admin --p foobar system status
```

## Vulnerability Matching
### Why am I getting false positives? {#26}
False positives are typically caused by:

* Package names reused across package managers (e.g. a gem and npm package with same name). Many data sources, like NVD don’t provide sufficient specification of the ecosystem a package lives in and thus Anchore may match the right name against the wrong type. This is most commonly seen in non-os (non rpm, deb, apk) packages.

* Distro package managers installing non-distro packages using the application package format and not updating the version number when backports are added. This can cause a match of the package against the application-package vulnerability data instead of the distro data.

### What can I do in response to a false positive? {#27}
The most immediate way to respond is to create a rule in the Anchore policy engine which [allowlists the package](https://docs.anchore.com/current/docs/using/ui_usage/policies/allowlists/).

## Reports
### Can I generate reports using Anchore Enterprise? {#28}
Yes, account wide reporting is available in Anchore Enterprise


### Monitoring
### How do I monitor my Anchore deployment? {#29}
Anchore recommends using Prometheus for gathering metrics. Anchore Enterprise exposes metrics in the API of each service. Set “metrics.enabled” to true in the relevant config.yaml file.

See: [https://docs.anchore.com/current/docs/monitoring/](https://docs.anchore.com/current/docs/monitoring/)


## Swagger
### How can I deploy an interactive Swagger UI? {#30}
#### Docker-Compose
To enable in a quickstart deployment (using docker-compose), simply uncomment the two service sections (the 'anchore-swagger-ui-nginx' and 'anchore-swagger-ui' services) at the end of the default docker-compose.yaml before starting up anchore, according to the regular [Quickstart Guide]({{< ref "/docs/quickstart" >}}).  There is a configuration file for nginx that needs to be mounted in order for the nginx proxy to passthrough to the engine-api.  It can be copied from the anchore-engine Docker image with the following command:

```
# docker create --name ae docker.io/anchore/anchore-engine:latest
# docker cp ae:/config/anchore-swaggerui-nginx.conf .
# docker rm ae
```

Once enabled, you can then direct your browser at your server, port 8080, and start browsing and testing API calls.

http://{servername}:8080/

e.g.

http://localhost:8080/

#### Kubernetes via Helm
To enable in an environment where Anchore was deployed via helm, use the following steps:

- Create a values.yaml file for Swagger UI containing the following
```yaml
---
## Set default image, imageTag, and imagePullPolicy. mode is used to indicate the
##
image:
  repository: swaggerapi/swagger-ui
  tag: latest
  pullPolicy: IfNotPresent

ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/rewrite-target: /$2
  path: /swagger(/|$)(.*)
  hosts:
    - ""
  tls: []

## Used to provide the location of the openapi.json file.
## If jsonPath is empty the chart try to get a json file at the jsonUrl address.
## The server fields have to use to add a custom server.
swaggerui :
  jsonPath : ""
  jsonUrl : http://<engine-api-svc>/v1/swagger.json
  server :
    url: http://<engine-api-svc>/v1/
```

- Install Swagger UI via Helm
```
# helm repo add cetic https://cetic.github.io/helm-charts
# helm install swagger -f swaggerui/values.yaml cetic/swaggerui
```


## Support
### Where can I ask other questions? {#31}
Community Slack: [https://anchore.slack.com](https://anchore.slack.com)

Github Issues:

*   Anchore Engine [https://github.com/anchore/anchore-engine/issues](https://github.com/anchore/anchore-engine/issues)
*   Anchore CLI: [https://github.com/anchore/anchore-cli/issues/](https://github.com/anchore/anchore-cli/issues/)
