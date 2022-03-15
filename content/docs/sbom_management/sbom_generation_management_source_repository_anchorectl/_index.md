---
title: "SBOM Generation and Management from Source Repository - AnchoreCTL
"
linkTitle: "SBOM Management from Source Repository - AnchoreCTL
"
weight: 3
---

Use anchorectl to generate a SBOM and import a source repository artifact from a file location on disk. You can also get information about the source repository, investigate vulnerability packages by requesting vulnerabilities for a single analyzed source repository, or get any policy evaluations.
The workflow would generally be as follows.

1. Generate an SBOM. The format is similar to the following:
`anchorectl sbom create <path> -o json > <resulting filename>.json`
For example:

```
$ anchorectl sbom create dir:/path/to/your/source/code -o json > my_sbom.json
```

2. Import the SBOM from a source with metadata. This would normally occur as part of a CI/CD pipeline, and the various metadata would be programmatically added via environment variables. The response from anchorectl includes the new ID of the Source in Anchore Enterprise. For example:

```
$ anchorectl source import --sbomFile=./my_sbom.json --repoHost github.com --repoName my-project --revision 123456 --branch test --changeAuthor user@domain.com --workflowName default --executionTime 2002-10-02T15:00:00Z
UUID                                  HOST        REPOSITORY NAME  REVISION  ANALYSIS STATUS  SOURCE STATUS  VCS TYPE  BRANCH NAME  CHANGE AUTHOR      WORKFLOW NAME  WORKFLOW EXECUTION TIME
c6bd3b3e-a0e6-4b96-b298-4173a126e242  github.com  my-project       123456    analyzed         active         git       test         user@domain.com    default        02 Oct 02 15:00 UTC
```

3. List the source repositories that you have sent to Anchore Enterprise. This command will allow the operator to list all available source repositories within the system and their current status.
```
$ anchorectl source list
UUID                                  ACCOUNT ID  HOST        REPOSITORY NAME  REVISION  ANALYSIS STATUS  SOURCE STATUS  CREATED AT            LAST UPDATED
e5f3d6f5-9b3c-4709-85a5-56a578330426  admin       gitlab.com  enterprise       123444    analyzed         active         2022-03-04T19:21:50Z  2022-03-04T19:21:50Z
c6bd3b3e-a0e6-4b96-b298-4173a126e242  admin       github.com  my-project       123456    analyzed         active         2022-03-10T15:42:38Z  2022-03-10T15:42:38Z
```

4. Fetch the uploaded SBOM for a source repository from Anchore Enterprise.
The <id> for this command is taken from the UUID(s) of the listed source repositories.
```
$ anchorectl source get-sbom c6bd3b3e-a0e6-4b96-b298-4173a126e242 --filename sbom_archive.json.gz
$ gunzip sbom_archive.json.gz
```

5. Get detailed information about a source. For example:

```
$ anchorectl source info 12e62d96-c2ad-4be0-9a4f-3e9bb170d31c
UUID                                  HOST        REPOSITORY NAME  REVISION  ANALYSIS STATUS  SOURCE STATUS  VCS TYPE  BRANCH NAME  CHANGE AUTHOR    WORKFLOW NAME  WORKFLOW EXECUTION TIME
c6bd3b3e-a0e6-4b96-b298-4173a126e242  github.com  my-project       123456    analyzed         active         git       test         user@domain.com  default        02 Oct 02 15:00 UTC
```

6. Use anchorectl to investigate vulnerability packages by requesting vulnerabilities for a single analyzed source repository. You can choose os, non-os, or all. For example: 

```
$ anchorectl source vuln c6bd3b3e-a0e6-4b96-b298-4173a126e242
os
non-os
all
```

```
$ anchorectl source vuln c6bd3b3e-a0e6-4b96-b298-4173a126e242 all
VULNERABILITY ID  PACKAGE       SEVERITY  FIX   CVE REFS        VULNERABILITY URL                                TYPE    FEED GROUP  PACKAGE PATH
CVE-2020-27534    docker-4.3.1  Medium    None  CVE-2020-27534  https://nvd.nist.gov/vuln/detail/CVE-2020-27534  python  nvd         requirements-test.txt
...
```

7. Use anchorectl to compute a policy evaluation for a source. For example:

```
$ anchorectl source check c6bd3b3e-a0e6-4b96-b298-4173a126e242
SOURCE ID                             ACCOUNT ID  HOST        REPOSITORY NAME  POLICY ID                             STATUS  CREATED AT            LAST UPDATED
c6bd3b3e-a0e6-4b96-b298-4173a126e242  vpillai     github.com  my-project       2c53a13c-1765-11e8-82ef-23527761d060  fail    2022-03-10T16:23:24Z  2022-03-10T16:23:24Z
```
*(Use -o json option to get more detailed output)*

8. Use anchorectl to delete any individual source repository artifacts from Anchore Enterprise. For example:

```
$ anchorectl source delete c6bd3b3e-a0e6-4b96-b298-4173a126e242
```