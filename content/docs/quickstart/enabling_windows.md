---
title: "Enabling Windows Scanning"
linkTitle: "Enabling Windows in Quickstart"
weight: 1
---

To enable Microsoft Windows support in the quickstart install docker-compose.yaml file you must do the following:

1. Go to the directory where you have the quickstart docker-compose.yaml downloaded. Or, see [Quickstart]({{< ref "/docs/quickstart" >}}) for download and setup instructions.

1. If your system is already running, shut it down: `docker-compose down`. 
(**Warning**: Do **NOT** use the `-v` option as it will delete your database and reset the system entirely).

1. Enable the feeds service to run. Uncomment the feeds service and enterprise-feeds-db services in docker-compose.yaml.

   The following also includes the GitHub advisories feed for NuGet/.NET support and for parity with the hosted feed service.

   Note that you will need to obtain and provide access tokens for MSRC and GitHub vulnerability feed configuration. See the comments inline for instructions on how to obtain these tokens.


    ```
    services:
      ...
      # Uncomment this section to add an on-prem feed service to this deployment. This will incur first-time feed sync delay, but is included for completeness / review of enterprise service deployment options
      enterprise-feeds-db:
        image: "postgres:9"
        volumes:
        - enterprise-feeds-db-volume:/var/lib/postgresql/data
        environment:
        - POSTGRES_PASSWORD=mysecretpassword
        expose:
        - 5432
        logging:
          driver: "json-file"
          options:
            max-size: 100m
      feeds:
        image: docker.io/anchore/enterprise:v3.1.0
        volumes:
        - feeds-workspace-volume:/workspace
        - ./license.yaml:/license.yaml:ro
        #- ./config-enterprise.yaml:/config/config.yaml:z
        depends_on:
        - enterprise-feeds-db
        ports:
        - "8448:8228"
        logging:
          driver: "json-file"
          options:
            max-size: 100m
        environment:
        - ANCHORE_ENDPOINT_HOSTNAME=feeds
        - ANCHORE_DB_HOST=enterprise-feeds-db
        - ANCHORE_DB_PASSWORD=mysecretpassword
        - ANCHORE_ENABLE_METRICS=false
        - ANCHORE_LOG_LEVEL=INFO
        # Uncomment the following to enable Microsoft msrc driver. Follow https://portal.msrc.microsoft.com/en-us/developer to generate an API key
        - ANCHORE_ENTERPRISE_FEEDS_MSRC_DRIVER_ENABLED=true
        - ANCHORE_ENTERPRISE_FEEDS_MSRC_DRIVER_API_KEY=<INSERT YOUR MSRC KEY HERE>
        # Uncomment ANCHORE_ENTERPRISE_FEEDS_GITHUB_DRIVER_TOKEN for github driver.
        # Generate token with https://github.com/settings/tokens/new?scopes=user,public_repo,repo,repo_deployment,repo:status,read:repo_hook,read:org,read:public_key,read:gpg_key
        # and assign the value to environment variable
        - ANCHORE_ENTERPRISE_FEEDS_GITHUB_DRIVER_TOKEN=<INSERT YOUR GITHUB KEY HERE>
        command: ["anchore-enterprise-manager", "service", "start",  "feeds"]

    ```

**Note:** Microsoft Windows image analysis is available for the V2 vulnerability scanner based on Grype.

1. Configure the policy engine to use the deployed feed service instead of the hosted feed service. Enable the Microsoft feed by uncommenting the ANCHORE_FEEDS_MICROSOFT_ENABLED variable.

    Ensure the following environment variables are set in the docker-compose.yaml file:

    ```
    services:
      ...
      policy-engine:
        ...
        environment:
          ...
          # Uncomment the ANCHORE_FEEDS_* environment variables (and uncomment the feeds db and service sections at the end of this file) to use the on-prem feed service
          - ANCHORE_FEEDS_URL=http://feeds:8228/v1/feeds
          - ANCHORE_FEEDS_CLIENT_URL=null
          - ANCHORE_FEEDS_TOKEN_URL=null
          # Uncomment the next variable in addition to enabling the on-prem feed service just above, to enable syncing of the MSRC data feeds for Microsoft Windows scanning support.
          - ANCHORE_FEEDS_MICROSOFT_ENABLED=true
      ...
    ```

1. Start/Restart the deployment: `docker-compose up -d`.

1. Wait for vulnerability data to sync.  Now that your installation includes a local feed service, you must first wait for the local feed service to populate, and then for your Anchore Enterprise policy engine to synchronize its feeds with the new local service.  This can take several hours for the initial sync, depending on network and local resource speeds.  When the feed synchronization is complete, execute the following command to show the 'microsoft' feed, with 'msrc' group data entries:

```
# docker-compose exec api anchore-cli system feeds list
```

In addition, you can use `anchore-cli event list` to show a feed sync complete event for the 'microsoft' feed.

Now you can scan Microsoft Windows-based images using the Anchore Enterprise UI, or the command line interface (CLI).

Installed KBs are also available via the 'OS' content type: `anchore-cli image content <windows img> os`.
