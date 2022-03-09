---
title: "Source Repository Mapping"
linkTitle: "Source Repository Mapping"
weight: 2
---

The source repository policy mapping editor creates rules that define which policies and allowlists should be used to perform the policy evaluation of a source repository based on the host, and repository name. 

![alt text](source-policy-mapping-main-screen.png)

Using the policy editor organizations can set up multiple policies that will be used on different source repositories based on use case. For example the policy applied to a web facing service may have different security and operational best practices rules than a database backend service.

Mappings are set up based on the **Host** and **Repository** of a source repository. Each field supports wildcards.

### Create a Source Repository Mapping ###

1. From the Policy Bundles screen, cick **Mappings**.

![alt text](policy-bundle-mapping-tab-with-arrows.png)

2. Click **Add New Mapping**, then select **Source Repositories**. By selecting source repositories, you are saying you want the new policy rule to apply to a source repository.

![alt text](edit-policy-bundle-add-new-mapping.png)

3. From the Add New Source Repository Mapping screen, add a name for the mapping, choose the policy for which the mapping will apply, a host (such as github.com), and a repository.  You can optionally add an allowlist and set the position for the mapping. 

![alt text](add-new-source-mapping.png)

4. Click **OK** to create the new mapping.