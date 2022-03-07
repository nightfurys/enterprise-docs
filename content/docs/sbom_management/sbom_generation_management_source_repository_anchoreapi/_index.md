---
title: "SBOM Generation and Management from Source Repository - Anchore API
"
linkTitle: "SBOM Management from Source Repository - Anchore API
"
weight: 4
---

Use the Anchore API to generate an application or artifact, and import them from a source repository. You can also get information about the source repository, investigate vulnerability packages by requesting vulnerabilities for a single analyzed source repository, or get any policy evaluations.

For more information about using Anchore APIs via Swagger, see: [Using the Anchore API](https://docs.anchore.com/current/docs/using/api_usage/).

The SBOM management API workflow would generally be as follows.

**Note**: Reference the API endpoints in Swagger for the latest information.

1. Use the API to import source repository SBOMs. For example, to create the import “job” (operation) for importing a source.

```
curl -u admin:foobar -X 'POST' 'http://localhost:8228/v1/enterprise/imports/sources'

{"created_at": "2022-02-28T20:34:17Z", "expires_at": "2022-03-01T20:34:17Z", "last_updated": "2022-02-28T20:34:17Z", "status": "pending", "uuid": "767c77fe-8f93-4e7e-a9ff-f0f39e2a80ba"}
```

2. Add the SBOM to the import operation. For example:

```
curl -u admin:foobar -X POST http://localhost:8228/v1/enterprise/imports/sources/767c77fe-8f93-4e7e-a9ff-f0f39e2a80ba/sbom -d @/absolute/path/to/your/sbom.json -H "Content-Type: application/json"

{"created_at": "2022-02-28T20:36:32Z", "digest": "6778145cdda7a3443abc9650683c6d5bf8a87e3e6b4b3c8868224e7755680446"}
```

3. Finalize the import. For example:

```
curl -X 'POST' 'http://localhost:8228/v1/enterprise/imports/sources/767c77fe-8f93-4e7e-a9ff-f0f39e2a80ba/finalize'
  -H 'accept: application/json'
  -H 'Content-Type: application/json’
  -d '{
  "branch_name": "main",
  "change_author": "commit-author@anchore.com",
  "ci_workflow_execution_time": "2022-02-28T20:38:13.117Z",
  "ci_workflow_name": "default",
  "contents": {
    "sbom": "6778145cdda7a3443abc9650683c6d5bf8a87e3e6b4b3c8868224e7755680446"
  },
  "host": "http://github.com",
  "repository_name": "anchore-engine",
  "revision": "8f7e4afb9bc9a284e24b69e529863a0b99373bf7"
}'

{
  "account_id": "admin",
  "analysis_status": "not_analyzed",
  "created_at": "2022-02-28T20:43:58Z",
  "host": "http://github.com",
  "last_updated": "2022-02-28T20:43:58Z",
  "metadata_records": [
    {
      "branch_name": "main",
      "change_author": "commit-author@anchore.com",
      "ci_workflow_execution_time": "2022-02-28T20:38:13Z",
      "ci_workflow_name": "default",
      "uuid": "8b97a668-2044-4f24-a5af-6010e7957ac3"
    }
  ],
  "repository_name": "anchore-engine",
  "revision": "8f7e4afb9bc9a284e24b69e529863a0b99373bf7",
  "source_status": "active",
  "uuid": "a0eb87e2-61ef-4721-bb16-9682ad528bbe",
  "vcs_type": "git"
}
```

4. List all sources that you’ve imported. For example:

```
curl -u admin:foobar -X 'GET' 'http://localhost:8228/v1/enterprise/sources'

[
  {
    "account_id": "admin",
    "analysis_status": "analyzed",
    "created_at": "2022-02-28T20:43:58Z",
    "host": "http://github.com",
    "last_updated": "2022-02-28T20:43:58Z",
    "repository_name": "anchore-engine",
    "revision": "8f7e4afb9bc9a284e24b69e529863a0b99373bf7",
    "source_status": "active",
    "uuid": "a0eb87e2-61ef-4721-bb16-9682ad528bbe"
  },
  …
]
```

5. Get information about a single source that you’ve imported. For example:

```
curl -u admin:foobar -X 'GET' 'http://localhost:8228/v1/enterprise/sources/a0eb87e2-61ef-4721-bb16-9682ad528bbe'

{
  "account_id": "admin",
  "analysis_status": "analyzed",
  "created_at": "2022-02-28T20:43:58Z",
  "host": "http://github.com",
  "last_updated": "2022-02-28T20:43:58Z",
  "metadata_records": [
    {
      "branch_name": "main",
      "change_author": "commit-author@anchore.com",
      "ci_workflow_execution_time": "2022-02-28T20:38:13Z",
      "ci_workflow_name": "default",
      "uuid": "8b97a668-2044-4f24-a5af-6010e7957ac3"
    }
  ],
  "repository_name": "anchore-engine",
  "revision": "8f7e4afb9bc9a284e24b69e529863a0b99373bf7",
  "source_status": "active",
  "uuid": "a0eb87e2-61ef-4721-bb16-9682ad528bbe",
  "vcs_type": "git"
}
```

6. Fetch the available SBOM types for a source. For example:

```
curl -X 'GET' -u admin:foobar 'http://localhost:8228/v1/enterprise/sources/a0eb87e2-61ef-4721-bb16-9682ad528bbe/sbom'

[
  "native"
]
```

7. Fetch a gzip compressed copy of the sbom for a specific type. For example:

```
curl -X 'GET' -u admin:foobar 'http://localhost:8228/v1/enterprise/sources/a0eb87e2-61ef-4721-bb16-9682ad528bbe/sbom/native'

<file>
```

8. Get the types of vulnerabilities that you may fetch with respect to a source. For example:

```
curl -X 'GET'  -u admin:foobar 'http://localhost:8228/v1/enterprise/sources/a0eb87e2-61ef-4721-bb16-9682ad528bbe/vuln' 


[
  "os",
  "non-os",
  "all"
]
```

9. Get the vulnerabilities for a source. For example:

```
curl -X 'GET' -u admin:foobar 'http://localhost:8228/v1/enterprise/sources/a0eb87e2-61ef-4721-bb16-9682ad528bbe/vuln/all'

{
  "source_id": "a0eb87e2-61ef-4721-bb16-9682ad528bbe",
  "vulnerabilities": [
{
  	"feed": "vulnerabilities",
  	"feed_group": "nvd",
  	"fix": "None",
  	"nvd_data": [
    	{
      	"cvss_v2": {
        	"base_score": 5,
        	"exploitability_score": 10,
        	"impact_score": 2.9
      	},
      	"cvss_v3": {
        	"base_score": 7.5,
        	"exploitability_score": 3.9,
        	"impact_score": 3.6
      	},
      	"id": "CVE-2019-13509"
    	}
  	],
  	"package": "docker-4.3.1",
  	"package_cpe": "None",
  	"package_cpe23": "cpe:2.3:a:docker:docker:4.3.1:*:*:*:*:*:*:*",
  	"package_name": "docker",
  	"package_path": "/Users/vijay/Documents/enterprise/requirements-test.txt",
  	"package_type": "python",
  	"package_version": "4.3.1",
  	"severity": "High",
  	"url": "https://nvd.nist.gov/vuln/detail/CVE-2019-13509",
  	"vendor_data": [],
  	"vuln": "CVE-2019-13509",
  	"will_not_fix": false
	},
…
],
  "vulnerability_type": "all"
}
```

10. Get the policy evaluation for a source. For example:

```
curl -X 'GET' -u admin:foobar 'http://localhost:8228/v1/enterprise/sources/a0eb87e2-61ef-4721-bb16-9682ad528bbe/check?interactive=true'

[
  {
    "account_id": "admin",
    "created_at": "2022-02-28T21:11:37Z",
    "evaluation_id": "7a4611f2fa26d80bd680782eb379081f",
    "evaluation_url": "policy_evaluations/7a4611f2fa26d80bd680782eb379081f",
    "final_action": "fail",
    "last_updated": "2022-02-28T21:11:37Z",
    "policy_id": "2c53a13c-1765-11e8-82ef-23527761d060",
    "repository_name": "anchore-engine",
    "result": {
      "account_id": "admin",
      "bundle": <bundle>
      "created_at": "2022-02-28T21:11:37Z",
      "evaluation_problems": [],
      "final_action": "stop",
      "final_action_reason": "policy_evaluation",
      "host": "http://github.com",
      "last_modified": "2022-02-28T21:11:37Z",
      "matched_mapping_rule": {
        "host": "*",
        "id": "9a899100-6e4c-4038-93ba-12f6d8ab97b3",
        "name": "default-source-mapping",
        "policy_id": "f2dbc082-7d10-432a-9f62-02ea8f1e5dbf",
        "repository": "*",
        "whitelist_ids": [
          "37fd763e-1765-11e8-add4-3b16c029ac5c"
        ]
      },
      "repository_name": "anchore-engine",
      "result": {
        "a0eb87e2-61ef-4721-bb16-9682ad528bbe": {
          "result": {
            "final_action": "stop",
            "header": [
              "Source_Id",
              "Host",
              "Repository Name",
              "Trigger_Id",
              "Gate",
              "Trigger",
              "Check_Output",
              "Gate_Action",
              "Whitelisted",
              "Policy_Id"
            ],
            "row_count": 19,
            "rows": [
              [
                "a0eb87e2-61ef-4721-bb16-9682ad528bbe",
                "http://github.com",
                "anchore-engine",
                "deb3f1afb4ea0ddf587e6c62c341c6fa",
                "vulnerabilities",
                "stale_feed_data",
                "The vulnerability feed for this image distro is older than MAXAGE (2) days",
                "warn",
                false,
                "f2dbc082-7d10-432a-9f62-02ea8f1e5dbf"
              ],
              …
            ]
          }
        },
        "policy_data": [],
        "policy_name": "",
        "whitelist_data": [],
        "whitelist_names": []
      },
      "source_id": "a0eb87e2-61ef-4721-bb16-9682ad528bbe",
      "status": "fail"
    },
    "source_id": "a0eb87e2-61ef-4721-bb16-9682ad528bbe",
    "vcs_host": "http://github.com"
  }
]
```

11. Delete any individual source repository SBOM artifact from Anchore Enterprise. For example:

```
curl -X 'DELETE' -u admin:foobar  'http://localhost:8228/v1/enterprise/sources/a0eb87e2-61ef-4721-bb16-9682ad528bbe'

{
  "account_id": "admin",
  "analysis_status": "analyzed",
  "created_at": "2022-02-28T20:43:58Z",
  "host": "http://github.com",
  "last_updated": "2022-02-28T21:17:03Z",
  "metadata_records": [
    {
      "branch_name": "main",
      "change_author": "commit-author@anchore.com",
      "ci_workflow_execution_time": "2022-02-28T20:38:13Z",
      "ci_workflow_name": "default",
      "uuid": "8b97a668-2044-4f24-a5af-6010e7957ac3"
    }
  ],
  "repository_name": "anchore-engine",
  "revision": "8f7e4afb9bc9a284e24b69e529863a0b99373bf7",
  "source_status": "deleting",
  "uuid": "a0eb87e2-61ef-4721-bb16-9682ad528bbe",
  "vcs_type": "git"
}


{
  "detail": {
    "error_codes": []
  },
  "httpcode": 404,
  "message": "Resource a0eb87e2-61ef-4721-bb16-9682ad528bbe not found"
}
```
