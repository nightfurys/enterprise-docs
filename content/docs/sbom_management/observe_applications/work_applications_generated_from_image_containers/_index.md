---
title: "Work with Applications Generated from Image Containers"
linkTitle: "Work with Applications Generated from Image Containers"
weight: 3
---

To work with image container data in Anchore Enterprise, you must first load the image container data into Enterprise. For more information, see [Scanning Repositories](https://docs.anchore.com/current/docs/using/cli_usage/repositories/). 

Once the data is made available to Anchore Enterprise, you can then analyze it. An example workflow might be as follows. 

1. Start Anchore Enterprise. You will default to the dashboard view. The Dashboard is your configurable landing page where insights into the collective status of your container image environment. The summary information is displayed through various widgets. Utilizing the Enterprise Reporting Service, the widgets are hydrated with metrics which are generated and updated on a cycle, the duration of which is determined by application configuration. See [Dashboard](https://docs.anchore.com/current/docs/using/ui_usage/dashboard/) for more information about what you can view.

2. Click **Applications** > **Container Images** to view a summary of the applications in your container images. The information is categorized by applications, with sub-categories of application versions available from image containers that you previously loaded. Notice the list of applications and application versions, as well as any artifacts in the applications.

![Container Image Application summary](container_images.png)

3. Click **SBOM Report Updated Application name** to download a report in JSON format for everything in an application. Or, click **SBOM Report** to download a report for everything in an artifact.

4. Click an artifact link under **Repository Name** to view the detailed information for the artifact.

![Container Image Artifact Link](container-image-artifact-link.png)

The Images analysis screen for an artifact shows you a summary of what is in that artifact.

![Container Images Analysis](container-image-analysis.png)

5. From the analysis screen, you can perform the following actions.

- Click **Policy Compliance** to view the policies and policy bundles set up for the artifact. You can see the policy rules that are set up as well. 
- Click **Vulnerabilities** to view the vulnerabilities associated with the artifact.
- Click **SBOM** to view the contents of the SBOM(s) associated with the artifact.
- Click **Image Metadata** to view the metadata information for the artifact.
- Click **Build Summary** to see the Manifest, Dockerfile, and Docker History of your artifact.
- Click **Action Workbench** to see the action plans and history for an image artifact.
- You have the option to click **SBOM Report** to download a report for everything in the artifact. 
- You also have the option to click **Compliance Report** to download a report that shows the compliance information in the artifact.

6. Click **Policies** to set up the rules for the analyzed container image.

See [Policies](https://docs.anchore.com/current/docs/using/ui_usage/policies/) for more information.
See [Policy Mappings](https://docs.anchore.com/current/docs/using/ui_usage/policies/mappings/) for more information.