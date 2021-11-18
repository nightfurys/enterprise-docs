---
title: "Quickstart"
linkTitle: "Quickstart"
weight: 1
---

## Introduction

In this section, you'll learn how to get up and running with a stand-alone Anchore Enterprise installation for trial, demonstration, and review with [Docker Compose](https://docs.docker.com/compose/install/).

**Note:** If your intent is to gain a deeper understanding of Anchore and its concepts, we recommend navigating to the [Overview]({{< ref "/docs/overview" >}}) section prior to conducting an [installation]({{< ref "/docs/installation" >}}) of Anchore Enterprise.


## Configuration Files for this Quickstart:

* [Docker Compose File](./docker-compose.yaml)

* (Optional) [Prometheus Configuration for Monitoring](./anchore-prometheus.yml). See [Enabling Prometheus Monitoring]({{< ref "#optional-enabling-prometheus-monitoring" >}})

* (Optional) [Swagger UI Nginx Proxy](./anchore-swaggerui-nginx.conf) to browse the API with a Swagger UI. See [Enabling Swagger UI]({{< ref "#optional-enabling-swagger-ui" >}})


## Requirements

The following instructions assume you are using a system running Docker v1.12 or higher, and a version of Docker Compose that supports at least v2 of the docker-compose configuration format.

* A stand-alone installation requires at least 4GB of RAM, and enough disk space available to support the largest container images you intend to analyze (we recommend 3x largest container image size).  For small images/testing (like basic Linux distro images or database images), between 5GB and 10GB of disk space should be sufficient.
* To access the Anchore Enterprise, you need a valid `license.yaml` file that has been issued to you by Anchore.  If you do not have a license yet, visit this [page](https://info.anchore.com/contact) for instructions on how to request one.


### Step 1: Ensure you can authenticate to DockerHub to pull the images

You'll need authenticated access to the `anchore/enterprise` and `anchore/enterprise-ui` repositories on DockerHub. Anchore support should have granted your DockerHub user access when you received your license.

```
# docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: <your_dockerhub_account>
Password: <your_dockerhub_password>
```

### Step 2: Download compose, copy license, and start.

Now, ensure the license.yaml file you got from Anchore Sales/Support is in the directory where you want to run the containers from, then download the compose file and start it.
You can use the link at the top of this page, or use curl or wget to download it as shown below.

```
# cp <path/to/your/license.yaml> ./license.yaml
# curl https://docs.anchore.com/current/docs/quickstart/docker-compose.yaml > docker-compose.yaml
# docker-compose up -d
```

### Step 3: Verify service availability

After a few minutes (depending on system speed) Anchore Enterprise and Anchore UI services should be up and running, ready to use.  You can verify the containers are running with docker-compose:

```
# docker-compose ps
             Name                           Command                  State               Ports         
-------------------------------------------------------------------------------------------------------
anchorequickstart_analyzer_1          /docker-entrypoint.sh anch ...   Up (healthy)   8228/tcp              
anchorequickstart_anchore-db_1        docker-entrypoint.sh postgres    Up             5432/tcp              
anchorequickstart_api_1               /docker-entrypoint.sh anch ...   Up (healthy)   0.0.0.0:8228->8228/tcp
anchorequickstart_catalog_1           /docker-entrypoint.sh anch ...   Up (healthy)   8228/tcp              
anchorequickstart_notifications_1     /docker-entrypoint.sh anch ...   Up (healthy)   0.0.0.0:8668->8228/tcp
anchorequickstart_policy-engine_1     /docker-entrypoint.sh anch ...   Up (healthy)   8228/tcp              
anchorequickstart_queue_1             /docker-entrypoint.sh anch ...   Up (healthy)   8228/tcp              
anchorequickstart_rbac-authorizer_1   /docker-entrypoint.sh anch ...   Up (healthy)   8089/tcp, 8228/tcp    
anchorequickstart_rbac-manager_1      /docker-entrypoint.sh anch ...   Up (healthy)   0.0.0.0:8229->8228/tcp
anchorequickstart_reports_1           /docker-entrypoint.sh anch ...   Up (healthy)   0.0.0.0:8558->8228/tcp
anchorequickstart_ui-redis_1          docker-entrypoint.sh redis ...   Up             6379/tcp              
anchorequickstart_ui_1                /docker-entrypoint.sh node ...   Up             0.0.0.0:3000->3000/tcp
```

You can run a command to get the status of the Anchore Enterprise services:

```
# docker-compose exec api anchore-cli system status
Service rbac_manager (anchore-quickstart, http://rbac-manager:8228): up
Service apiext (anchore-quickstart, http://api:8228): up
Service analyzer (anchore-quickstart, http://analyzer:8228): up
Service simplequeue (anchore-quickstart, http://queue:8228): up
Service catalog (anchore-quickstart, http://catalog:8228): up
Service reports (anchore-quickstart, http://reports:8228): up
Service notifications (anchore-quickstart, http://notifications:8228): up
Service rbac_authorizer (anchore-quickstart, http://rbac-authorizer:8228): up
Service policy_engine (anchore-quickstart, http://policy-engine:8228): up

Engine DB Version: 0.0.4
Engine Code Version: 2.3.0

```

**Note:** The first time you run Anchore Enterprise, vulnerability data will sync to the system in a few minutes. If the on-prem feed service is also used, it will take a while for the vulnerability data to get synced into the system (2+ hours in many cases, depending on network speed). For the best experience, wait until the core vulnerability data feeds have completed before proceeding.  You can check the status of your feed sync using the CLI:

```
# docker-compose exec api anchore-cli system feeds list
Feed                   Group                  LastSync                    RecordCount
vulnerabilities        alpine:3.10            2021-11-18T12:03:35Z        2321
vulnerabilities        alpine:3.11            2021-11-18T12:03:35Z        2621
vulnerabilities        alpine:3.12            2021-11-18T12:03:35Z        2967
vulnerabilities        alpine:3.13            2021-11-18T12:03:35Z        3324
vulnerabilities        alpine:3.14            2021-11-18T12:03:35Z        3649
vulnerabilities        alpine:3.2             2021-11-18T12:03:35Z        306
vulnerabilities        alpine:3.3             2021-11-18T12:03:35Z        471
vulnerabilities        alpine:3.4             2021-11-18T12:03:35Z        680
vulnerabilities        alpine:3.5             2021-11-18T12:03:35Z        903
vulnerabilities        alpine:3.6             2021-11-18T12:03:35Z        1075
vulnerabilities        alpine:3.7             2021-11-18T12:03:35Z        1461
vulnerabilities        alpine:3.8             2021-11-18T12:03:35Z        1671
vulnerabilities        alpine:3.9             2021-11-18T12:03:35Z        1957
vulnerabilities        amzn:2                 2021-11-18T12:03:35Z        678
vulnerabilities        debian:10              2021-11-18T12:03:35Z        22674
vulnerabilities        debian:11              2021-11-18T12:03:35Z        22674
vulnerabilities        debian:12              2021-11-18T12:03:35Z        22714
vulnerabilities        debian:9               2021-11-18T12:03:35Z        25045
vulnerabilities        debian:unstable        2021-11-18T12:03:35Z        24853
vulnerabilities        github:composer        2021-11-18T12:03:35Z        404
vulnerabilities        github:gem             2021-11-18T12:03:35Z        416
vulnerabilities        github:go              2021-11-18T12:03:35Z        199
vulnerabilities        github:java            2021-11-18T12:03:35Z        838
vulnerabilities        github:npm             2021-11-18T12:03:35Z        2089
vulnerabilities        github:nuget           2021-11-18T12:03:35Z        142
vulnerabilities        github:python          2021-11-18T12:03:35Z        743
vulnerabilities        msrc:10379             2021-11-18T12:03:35Z        1458
vulnerabilities        msrc:10543             2021-11-18T12:03:35Z        1546
vulnerabilities        msrc:10729             2021-11-18T12:03:35Z        1713
vulnerabilities        msrc:10735             2021-11-18T12:03:35Z        1785
vulnerabilities        msrc:10788             2021-11-18T12:03:35Z        466
vulnerabilities        msrc:10789             2021-11-18T12:03:35Z        437
vulnerabilities        msrc:10816             2021-11-18T12:03:35Z        1856
vulnerabilities        msrc:10852             2021-11-18T12:03:35Z        1772
vulnerabilities        msrc:10853             2021-11-18T12:03:35Z        1860
vulnerabilities        msrc:10855             2021-11-18T12:03:35Z        1835
vulnerabilities        msrc:10951             2021-11-18T12:03:35Z        716
vulnerabilities        msrc:10952             2021-11-18T12:03:35Z        766
vulnerabilities        msrc:11453             2021-11-18T12:03:35Z        1241
vulnerabilities        msrc:11454             2021-11-18T12:03:35Z        1291
vulnerabilities        msrc:11466             2021-11-18T12:03:35Z        395
vulnerabilities        msrc:11497             2021-11-18T12:03:35Z        1455
vulnerabilities        msrc:11498             2021-11-18T12:03:35Z        1515
vulnerabilities        msrc:11499             2021-11-18T12:03:35Z        981
vulnerabilities        msrc:11563             2021-11-18T12:03:35Z        1345
vulnerabilities        msrc:11568             2021-11-18T12:03:35Z        1554
vulnerabilities        msrc:11569             2021-11-18T12:03:35Z        1614
vulnerabilities        msrc:11570             2021-11-18T12:03:35Z        1539
vulnerabilities        msrc:11571             2021-11-18T12:03:35Z        1623
vulnerabilities        msrc:11572             2021-11-18T12:03:35Z        1603
vulnerabilities        msrc:11583             2021-11-18T12:03:35Z        1039
vulnerabilities        msrc:11644             2021-11-18T12:03:35Z        1056
vulnerabilities        msrc:11645             2021-11-18T12:03:35Z        1091
vulnerabilities        msrc:11646             2021-11-18T12:03:35Z        1057
vulnerabilities        msrc:11647             2021-11-18T12:03:35Z        1076
vulnerabilities        msrc:11712             2021-11-18T12:03:35Z        1132
vulnerabilities        msrc:11713             2021-11-18T12:03:35Z        1167
vulnerabilities        msrc:11714             2021-11-18T12:03:35Z        1137
vulnerabilities        msrc:11715             2021-11-18T12:03:35Z        1001
vulnerabilities        msrc:11766             2021-11-18T12:03:35Z        825
vulnerabilities        msrc:11767             2021-11-18T12:03:35Z        828
vulnerabilities        msrc:11768             2021-11-18T12:03:35Z        848
vulnerabilities        msrc:11769             2021-11-18T12:03:35Z        836
vulnerabilities        msrc:products          2021-11-18T12:03:35Z        37
vulnerabilities        nvd                    2021-11-18T12:03:35Z        171525
vulnerabilities        ol:5                   2021-11-18T12:03:35Z        1255
vulnerabilities        ol:6                   2021-11-18T12:03:35Z        1640
vulnerabilities        ol:7                   2021-11-18T12:03:35Z        1611
vulnerabilities        ol:8                   2021-11-18T12:03:35Z        613
vulnerabilities        rhel:5                 2021-11-18T12:03:35Z        7682
vulnerabilities        rhel:6                 2021-11-18T12:03:35Z        7561
vulnerabilities        rhel:7                 2021-11-18T12:03:35Z        7085
vulnerabilities        rhel:8                 2021-11-18T12:03:35Z        3069
vulnerabilities        sles:11                2021-11-18T12:03:35Z        594
vulnerabilities        sles:11.1              2021-11-18T12:03:35Z        5951
vulnerabilities        sles:11.2              2021-11-18T12:03:35Z        3291
vulnerabilities        sles:11.3              2021-11-18T12:03:35Z        6834
vulnerabilities        sles:11.4              2021-11-18T12:03:35Z        6360
vulnerabilities        sles:12                2021-11-18T12:03:35Z        4245
vulnerabilities        sles:12.1              2021-11-18T12:03:35Z        5204
vulnerabilities        sles:12.2              2021-11-18T12:03:35Z        6824
vulnerabilities        sles:12.3              2021-11-18T12:03:35Z        7649
vulnerabilities        sles:12.4              2021-11-18T12:03:35Z        7635
vulnerabilities        sles:12.5              2021-11-18T12:03:35Z        7782
vulnerabilities        sles:15                2021-11-18T12:03:35Z        1080
vulnerabilities        sles:15.1              2021-11-18T12:03:35Z        535
vulnerabilities        ubuntu:12.04           2021-11-18T12:03:35Z        14932
vulnerabilities        ubuntu:12.10           2021-11-18T12:03:35Z        5641
vulnerabilities        ubuntu:13.04           2021-11-18T12:03:35Z        4117
vulnerabilities        ubuntu:14.04           2021-11-18T12:03:35Z        26306
vulnerabilities        ubuntu:14.10           2021-11-18T12:03:35Z        4437
vulnerabilities        ubuntu:15.04           2021-11-18T12:03:35Z        6084
vulnerabilities        ubuntu:15.10           2021-11-18T12:03:35Z        6488
vulnerabilities        ubuntu:16.04           2021-11-18T12:03:35Z        23425
vulnerabilities        ubuntu:16.10           2021-11-18T12:03:35Z        8606
vulnerabilities        ubuntu:17.04           2021-11-18T12:03:35Z        9094
vulnerabilities        ubuntu:17.10           2021-11-18T12:03:35Z        7899
vulnerabilities        ubuntu:18.04           2021-11-18T12:03:35Z        17696
vulnerabilities        ubuntu:18.10           2021-11-18T12:03:35Z        8366
vulnerabilities        ubuntu:19.04           2021-11-18T12:03:35Z        8635
vulnerabilities        ubuntu:19.10           2021-11-18T12:03:35Z        8415
vulnerabilities        ubuntu:20.04           2021-11-18T12:03:35Z        11616
vulnerabilities        ubuntu:20.10           2021-11-18T12:03:35Z        9992
vulnerabilities        ubuntu:21.04           2021-11-18T12:03:35Z        10133
vulnerabilities        vulndb                 2021-11-18T12:03:35Z        268142
```

As soon as you see RecordCount values set for all vulnerability groups, the system is fully populated and ready to present vulnerability results.   Note that feed syncs are incremental, so the next time you start up Anchore Enterprise it will be ready immediately.  The CLI tool includes a useful utility that will block until the feeds have completed a successful sync:

```
# docker-compose exec api anchore-cli system wait
Starting checks to wait for anchore-engine to be available timeout=-1.0 interval=5.0
API availability: Checking anchore-engine URL (http://localhost:8228)...
API availability: Success.
Service availability: Checking for service set (catalog,apiext,policy_engine,simplequeue,analyzer)...
Service availability: Success.
Feed sync: Checking sync completion for feed set (vulnerabilities)...
Feed sync: Checking sync completion for feed set (vulnerabilities)...
...
...
Feed sync: Success.

```

### Step 4: Start using Anchore

To get started, you can add a few images to Anchore Enterprise using the CLI. Once complete, you can also run an additional CLI command to monitor the analysis state of the added images, waiting until the images move into an 'analyzed' state.

```
# docker-compose exec api anchore-cli image add docker.io/library/alpine:latest
...
...

# docker-compose exec api anchore-cli image add docker.io/library/nginx:latest
...
...

# docker-compose exec api anchore-cli image list
Full Tag                               Image Digest                                                                   Analysis Status        
docker.io/library/alpine:latest        sha256:39eda93d15866957feaee28f8fc5adb545276a64147445c64992ef69804dbf01        analyzed               
docker.io/library/nginx:latest         sha256:cccef6d6bdea671c394956e24b0d0c44cd82dbe83f543a47fdc790fadea48422        analyzing              

# docker-compose exec api anchore-cli image wait docker.io/library/nginx:latest
...
...

# docker-compose exec api anchore-cli image list
Full Tag                               Image Digest                                                                   Analysis Status        
docker.io/library/alpine:latest        sha256:39eda93d15866957feaee28f8fc5adb545276a64147445c64992ef69804dbf01        analyzed               
docker.io/library/nginx:latest         sha256:cccef6d6bdea671c394956e24b0d0c44cd82dbe83f543a47fdc790fadea48422        analyzed               

```


Now that some images are in place, you can point your browser at the Anchore Enterprise UI by directing it to _http://localhost:3000/_.

Enter the username _admin_ and password _foobar_ to log in.  These are some of the features you can use in the browser:

- Navigate images
- Inspect image contents
- Perform security scans
- Review compliance policy evaluations
- Edit compliance policies with a complete policy editor UI
- Manage accounts, users, and RBAC assignments
- Review system events

**Note:** This document is intended to serve as a quickstart guide. Before moving further with Anchore Enterprise, it is highly recommended to read the [Overview]({{< ref "/docs/overview" >}}) sections to gain a deeper understanding of fundamentals, concepts, and proper usage.

### Enabling Windows Image Support

To enable scanning of Windows images, you'll have to configure more of the system to deploy a feed service and setup the proper drivers to collect vulnerability data for Windows.


See: [Enabling Windows]({{< ref "/docs/quickstart/enabling_windows" >}})

### Next Steps

Now that you have Anchore Enterprise running, you can begin to learn more about Anchore Enterprise Architecture, Anchore Concepts, and Anchore Usage.

- To learn more about Anchore Enterprise, go to [Overview]({{< ref "/docs/overview" >}})
- To learn more about Anchore Concepts, go to [Concepts]({{< ref "/docs/overview/concepts" >}})
- To learn more about other installation methods, go to [Installation]({{< ref "/docs/installation" >}})
- To learn more about using Anchore Usage, go to [Usage]({{< ref "/docs/using" >}})


### Optional: Enabling Prometheus Monitoring

1. Uncomment the following section at the bottom of the docker-compose.yaml file:

    ```
    #  # Uncomment this section to add a prometheus instance to gather metrics. This is mostly for quickstart to demonstrate prometheus metrics exported
    #  prometheus:
    #    image: docker.io/prom/prometheus:latest
    #    depends_on:
    #      - api
    #    volumes:
    #      - ./anchore-prometheus.yml:/etc/prometheus/prometheus.yml:z
    #    logging:
    #      driver: "json-file"
    #      options:
    #        max-size: 100m
    #    ports:
    #      - "9090:9090"
    #
    ```

1. For each service entry in the docker-compose.yaml, change the following to enable metrics in the API for each service

    ```
    ANCHORE_ENABLE_METRICS=false
    ```

    to

    ```
    ANCHORE_ENABLE_METRICS=true
    ```

1. Download the example prometheus configuration into the same directory as the docker-compose.yaml file, with name _anchore-prometheus.yml_

    ```
    curl https://docs.anchore.com/current/docs/quickstart/anchore-prometheus.yml > anchore-prometheus.yml
    docker-compose up -d
    ```

    You should see a new container started and can access prometheus via your browser on `http://localhost:9090`


### Optional: Enabling Swagger UI

1. Uncomment the following section at the bottom of the docker-compose.yaml file:

    ```
    #  # Uncomment this section to run a swagger UI service, for inspecting and interacting with the system API via a browser (http://localhost:8080 by default, change if needed in both sections below)
    #  swagger-ui-nginx:
    #    image: docker.io/nginx:latest
    #    depends_on:
    #      - api
    #      - swagger-ui
    #    ports:
    #      - "8080:8080"
    #    volumes:
    #      - ./anchore-swaggerui-nginx.conf:/etc/nginx/nginx.conf:z
    #    logging:
    #      driver: "json-file"
    #      options:
    #        max-size: 100m
    #  swagger-ui:
    #    image: docker.io/swaggerapi/swagger-ui
    #    environment:
    #      - URL=http://localhost:8080/v1/swagger.json
    #    logging:
    #      driver: "json-file"
    #      options:
    #        max-size: 100m
    ```

1. Download the nginx configuration into the same directory as the docker-compose.yaml file, with name _anchore-swaggerui-nginx.conf_

    ```
    curl https://docs.anchore.com/current/docs/quickstart/anchore-swaggerui-nginx.conf > anchore-swaggerui-nginx.conf
    docker-compose up -d
    ```

    You should see a new container started and can access swagger UI via your browser on `http://localhost:8080`
