---
title: "Upgrading Anchore Enterprise"
linkTitle: "Upgrade"
weight: 10
---

Upgrading from one version of Anchore Enterprise to another is normally handled seamlessly by the Helm chart or 
trial docker-compose configuration files that are provided along with each release. Those follow the general methods from this guide. 
See [Specific Instructions](#specific-versions) section for special instructions related to specific versions.

### Upgrade scenarios

See the following scenarios when upgrading from an earlier version of Enterprise to 3.2.0.

- The legacy vulnerability scanner is no longer supported. If you currently have Enterprise configured to use the legacy vulnerability scanner, you will not be able to successfully upgrade and start the system without explicitly configuring the default vulnerability scanner. Or, you can remove that configuration variable so the system can default to the current vulnerability scanner.

- If you choose not to upgrade, instead performing a new installation of Enterprise, the vulnerability scanner will be configured by default.

Anchore is distributed as a docker image, which is composed of smaller micro-services that can be deployed in a single container or scaled out to handle load.

The latest version of the Anchore image will be tagged with both the latest tag and a version number. For example **latest** and **v0.7.1**.

To retrieve the version of a running instance of Anchore, the system status command can be run.

```
# anchore-cli system status
...
...
...

Engine DB Version: 0.0.13
Engine Code Version: 0.7.0
```

In this example the Anchore version is 0.7.0 and the database schema is version 0.0.13.  In cases where the database schema is changed between releases, Anchore will upgrade the database schema at launch.

### Pre-upgrade Procedure

Prior to upgrading Anchore, it is highly recommended to perform a database backup/snapshot by stopping your Anchore installation, and back up the database in its entirety. There is no automatic downgrade capability, thus the only way to downgrade after an upgrade (whether it succeeds or fails) is to restore your database contents to a state from a prior version of Anchore, and explicitly run the compatible version of Anchore against the corresponding database contents.

Whether or not you wish to have the ability to downgrade, we recommend backing up your Anchore database prior to upgrading the software as a best practice.

### Upgrade Procedure (for deployments using Helm)

For the latest upgrade instructions using the Helm chart, please refer to the official Anchore Helm Chart documentation

- [Anchore Helm Chart](https://github.com/anchore/anchore-charts/blob/master/stable/anchore-engine)


### Upgrade Procedure (example with docker-compose)

1. Stop all running instances of Anchore
```
# docker-compose down
```

2. Make a copy of your original docker-compose.yaml file as backup
```
# cp docker-compose.yaml docker.compose.yaml.backup
```

3. Download the latest docker-compose.yaml
```
# curl https://docs.anchore.com/current/docs/quickstart/docker-compose.yaml
```

4. Review the latest docker-compose.yaml and merge any edits/changes from your original docker-compose.yaml.backup to the latest docker-compose.yaml

5. Restart the Anchore containers
```
# docker-compose up -d
```

To monitor the progress of your upgrade, you can watch the docker logs from your catalog container, where you should see some initial output indicating whether or not an upgrade is needed or being performed, followed by the regular Anchore log output.

```
# docker-compose logs -f catalog
```

Once completed, you can review the new state of your Anchore install to verify the new version is running using the regular system status command.

```
# anchore-cli system status
...
...
...

Engine DB Version: 0.0.13
Engine Code Version: 0.7.1
```

### Advanced / Manual Upgrade Procedure

If for any reason the automated upgrade fails, or you would like to perform the upgrade of the anchore database manually, you can use the following (general) procedure. This should only be done by advanced operators after backing up the anchore database, ensuring that the anchore database is up and running, and that all running anchore components are stopped.

- Install the desired Anchore container manually.
- Run the Anchore container but override the entrypoint to run an interactive shell instead of the default 'anchore-manager service start' entrypoint command.
- Manually execute the database upgrade command, using the appropriate db_connect string.  For example, if using Postgres, the db_connect string will look like `postgresql://$ANCHORE_DB_HOST/$ANCHORE_DB_NAME?user=$ANCHORE_DB_USER&password=$ANCHORE_DB_PASSWORD`

```
# anchore-manager db --db-connect "postgresql://$ANCHORE_DB_HOST/$ANCHORE_DB_NAME?user=$ANCHORE_DB_USER&password=$ANCHORE_DB_PASSWORD" upgrade
[MainThread] [anchore_manager.cli.utils/connect_database()] [INFO] DB params: {"db_connect_args": {"timeout": 86400, "ssl": false}, "db_pool_size": 30, "db_pool_max_overflow": 100}
[MainThread] [anchore_manager.cli.utils/connect_database()] [INFO] DB connection configured: True
[MainThread] [anchore_manager.cli.utils/connect_database()] [INFO] DB attempting to connect...
[MainThread] [anchore_manager.cli.utils/connect_database()] [INFO] DB connected: True
...
...
```
- The output will indicate whether or not a database upgrade is needed. It will then prompt for confirmation if it is, and will display upgrade progress output before completing.


## Specific Version Upgrades {#specific-versions}
---
This section is intended as a guide for any special instructions and information related to upgrading to specific versions of Enterprise.

### Upgrading Enterprise 3.1.1 to 3.2.0

The major change between 3.1.0 and 3.2.0. is that Anchore Enterprise uses the new vulnerability scanner. This vulnerability scanner replaces the legacy vulnerability scanner in previous versions of Anchore Enterprise.

See the following scenarios when upgrading from Enterprise 3.1.0 to 3.2.0.

- If you are upgrading from Enterprise 3.1.0 with the legacy scanner configured, then Enterprise 3.2.0 will continue to respect that configured (legacy) scanner.

- If you are upgrading from Enterprise 3.1.0 without the scanner configured, then Enterprise 3.2.0 will notice that it is an upgrade and default to the V1 vulnerability scanner (legacy), just as the 3.1.0 instance defaulted to.

- If you have Enterprise 3.2.0 that is using the V1 vulnerability scanner (legacy), either configured or because of an upgrade, you can follow the directions to configure it to the new vulnerability scanner and switch to it. But if you switch to the new vulnerability scanner, you cannot revert back to the legacy scanner unless you do a fresh install with the V1 scanner configured.

- If you choose not to upgrade, instead performing a new installation of 3.2.0, you will have the vulnerability scanner configured by default. 


#### Upgrading with Helm Chart

The new version of the Helm chart for Anchore Engine/Enterprise has a few significant changes:

1. Explicit database upgrade process executed via 2 post-upgrade hook jobs. These will run and execute the database schema upgrade while the new versions of the 
service pods wait for the database schema to be updated.

Doing the upgrade:

1. Pull latest chart: `helm repo update`

1. Review any custom values.yaml configuration and compare to the defaults in the chart. Either use 

    `helm pull anchore/anchore-engine`
 
    to view the updated chart, or view on [Helm Charts Github repository](https://github.com/anchore/anchore-charts/blob/master/stable/anchore-engine)

1. Upgrade your deployment: `helm upgrade <your release name, e..g anchore> anchore/anchore-engine <-f custom_values.yaml>`

1. The command will wait while the upgrade jobs complete before returning a success. This may take some time as the database upgrade involves some data migrations.


#### Upgrading with Docker Compose

We do not recommend just changing the image reference in an existing Docker Compose file unless you are sure the configuration is valid for the new release. The expected
method if using an Anchore-provided docker-compose.yaml file from the Quickstart guide, is to replace the previous docker-compose.yaml with the new one, as below.

From the directory in your system where you have the previous docker-compose.yaml file:


1. Download the new docker-compose.yaml file
    ```
    curl https://docs.anchore.com/current/docs/quickstart/docker-compose.yaml > docker-compose-new.yaml
    ```

1. Create backup of old compose file:
    ```
    cp docker-compose.yaml docker-compose.yaml.old
    ```

1. Shut down the deployment but leave volumes in place:
    ```
    docker-compose down
    ```

1. Substitute the new docker-compose.yaml file
    ```
    cp docker-compose-new.yaml docker-compose.yaml
    ```

1. Start the deployment back up:
    ```
    docker-compose up -d
    ```


### Additional Steps for the RHSA -> CVE Change in 2.3.0

The upgrade will run and complete by itself. Due to a feeds change in 2.3.0 to migrate to CVE matches instead of RHSA matches for RHEL/CentOS images, there will be vulnerability
matches for both types after the new feed groups sync. You can leave these matches or remove them by flushing the old data manually. Existing RHEL/CentOS/UBI images analyzed before
the upgrade will have both RHSA and CVE matches. New images analyzed after upgrade will have only CVE matches against the new data.

For more information on the upgrade process and how to flush the old RHSA matches see: [RHSA to CVE Migration]({{< ref "/docs/releasenotes/2.3.0/centos_to_rhel_upgrade">}})

#### Enterprise 2.3.0 Manual / Advanced Upgrade

If you are manually deploying or using a method other than our provided installation tools, it is recommended that you inspect the latest Helm chart and/or the latest docker-compose.yaml
 to review the addition of the reporting service, reporting service configuration environment variables and section in the enterprise service config.yaml, and the addition of the new 
 required configuration options to your existing UI config-ui.yaml configuration file.
