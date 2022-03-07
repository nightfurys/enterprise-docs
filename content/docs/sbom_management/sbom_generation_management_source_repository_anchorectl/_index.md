---
title: "SBOM Generation and Management from Source Repository - AnchoreCTL
"
linkTitle: "SBOM Management from Source Repository - AnchoreCTL
"
weight: 3
---

Use AnchoreCTL to generate an application or artifact, and import them from a source repository. You can also get information about the source repository, investigate vulnerability packages by requesting vulnerabilities for a single analyzed source repository, or get any policy evaluations.
The workflow would generally be as follows.

1. Generate an SBOM. The format is similar to the following:
`anchorectl sbom create <path> -o json > <resulting filename>.json`
For example:

```
# ./anchorectl sbom create dir:../../enterprise -o json > enterprise_alpha.json
[0000]  INFO End User Licensing Agreement
Usage of this tool requires an Anchore Enterprise License.
Please check with your system administrator to ensure you have the proper license.
Unauthorized use of this tool will violate the license terms provided by Anchore, Inc.
See https://anchore.com for more details.
```

2. Import the SBOM from a source with metadata. This would normally occur as part of a CI/CD pipeline, and the various metadata would be programmatically added via environment variables. The response from AnchoreCTL includes the new ID of the Source in Anchore Enterprise. For example:

```
# ./anchorectl source import --sbomFile ./enterprise_alpha.json --branch main --changeAuthor "user name" --executionTime 2002-10-02T15:00:00Z --repoHost github.com --repoName demo --revision 12305233 --workflowName Testing
[0000]  INFO End User Licensing Agreement
Usage of this tool requires an Anchore Enterprise License.
Please check with your system administrator to ensure you have the proper license.
Unauthorized use of this tool will violate the license terms provided by Anchore, Inc.
See https://anchore.com for more details.
[0000]  INFO Transaction complete record: "04a2acfb-8f83-412b-934d-f0b74c5512ac"
```

3. List the analyzed source repositories that you have sent to Anchore Enterprise. This step will allow the operator to list all available source repositories within the system and their current status.
```
# ./anchorectl source list
[0000]  INFO End User Licensing Agreement
Usage of this tool requires an Anchore Enterprise License.
Please check with your system administrator to ensure you have the proper license.
Unauthorized use of this tool will violate the license terms provided by Anchore, Inc.
See https://anchore.com for more details.
```

```
UUID: 04a2acfb-8f83-412b-934d-f0b74c5512ac 
ACCOUNT ID: admin
HOST: github.com
REPOSITORY NAME: demo
BRANCH NAME: main
COMMIT HASH: 12305233
ANALYSIS STATUS: analyzed
SOURCE STATUS: active
CREATED AT: 0001-01-01T00:00:00Z
LAST UPDATED: 0001-01-01T00:00:00Z
```

4. Retrieve a UUID for the source repository. For example:
`[0000]  INFO Transaction complete record:"04a2acfb-8f83-412b-934d-f0b74c5512ac"`

5. Fetch the uploaded SBOM for a source from Anchore Enterprise.
The <id> for this command is taken from the UUID(s) of the listed source repositories.
`# ./anchorectl source get --id 04a2acfb-8f83-412b-934d-f0b74c5512ac --filename sbom_archive.gzip`

```
[0000]  INFO End User Licensing Agreement
Usage of this tool requires an Anchore Enterprise License.
Please check with your system administrator to ensure you have the proper license.
Unauthorized use of this tool will violate the license terms provided by Anchore, Inc.
See https://anchore.com for more details.
[0000]  INFO
### file: '04a2acfb-8f83-412b-934d-f0b74c5512ac' was written to: './sbom_archive.gzip' ###
```

6. Get the info details of the source. Info will return the detailed information about stored source artifacts. For example:

```
anchorectl source info --id 12e62d96-c2ad-4be0-9a4f-3e9bb170d31c
UUID: 12e62d96-c2ad-4be0-9a4f-3e9bb170d31c
HOST: github.com
REPOSITORY NAME: anchore/enterprise
REVISION: 754a3c87-f31b-429d-8363-6f38714f9dd6
ANALYSIS STATUS: analyzed
SOURCE STATUS: active
VCS TYPE:
BRANCH NAME: source-policy
CHANGE AUTHOR: User email
WORKFLOW NAME: default
WORKFLOW EXECUTION TIME: 28 Feb 22 12:37 UTC
```

7. Use anchoreCTL to investigate vulnerability packages by requesting vulnerabilities for a single analyzed source repository. You can choose os, non-os, or all. For example: 

```
anchorectl source vuln 12e62d96-c2ad-4be0-9a4f-3e9bb170d31c
os
non-os
all
```

`anchorectl source vuln 12e62d96-c2ad-4be0-9a4f-3e9bb170d31c all`

8. Use anchorectl to delete any individual source repository SBOM artifact from Anchore Enterprise. For example:

`anchorectl source delete --id d60e8ee0-c5cd-4aa4-bbba-1e46b1bb5edc`
