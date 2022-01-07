---
title: "Concepts"
weight: 2
---

### How does Anchore Enterprise work?

Anchore takes a data-driven approach to analysis and policy enforcement. The system has the following discrete phases for each image analyzed:

1. **Fetch** the image content and extract it, but never execute it.
1. **Analyze** the image by running a set of Anchore analyzers over the image content to extract and classify as much metadata as possible.
1. **Save** the resulting analysis in the database for future use and audit.
1. **Evaluate** policies against the analysis result, including vulnerability matches on the artifacts discovered in the image.
1. **Update** to the latest external data used for policy evaluation and vulnerability matches (we call this external data sync a feed sync), and automatically update image analysis results against any new data found upstream.
1. **Notify** users of changes to policy evaluations and vulnerability matches.

Repeat step 5 and 6 on intervals to ensure you have the latest external data and updated image evaluations.

![alt text](HowItWorks.png)

The primary interface is a RESTful API that provides mechanisms to request analysis, policy evaluation, and monitoring of images in registries as well as query for image contents and analysis results. Anchore Enterprise also provides a command-line interface (CLI), and its own container.

There following modes provide different ways to use Anchore within the API:

- Interactive Mode - Use the APIs to explicitly request an image analysis, or get a policy evaluation and content reports. The system only performs operations when specifically requested by a user.
- Watch Mode - Use the APIs to configure Anchore Enterprise to poll specific registries and repositories/tags to watch for new images, and then automatically pull and evaluate them. The API sends notifications when a state changes for a tag's vulnerability or policy evaluation.

Anchore can be easily integrated into most environments and processes using these two modes of operation.

### Next Steps

Now let's get familiar with [Images]({{< ref "/docs/overview/concepts/images" >}}) in Anchore.
