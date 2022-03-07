---
title: "SBOM Drift"
linkTitle: "SBOM Drift"
weight: 5
---

SBOM drift is understanding how SBOMs change over time, and is a key part of managing your SBOMs. The nature of changes themselves may give early warning into unexpected behavior or intrusion into the build system that a review without context from previous builds would not easily be able to identify.

To do this, you set triggers for policy violations on changes in the SBOM between images with the same tag so that it can detect drift over time between builds of your images. 

The triggers are:
- image_diff_packages_added
- image_diff_packages_removed
- image_diff_packages_modified

The "image_tag_drift" gate compares the SBOMs from the image being evaluated as input, and the SBOM of the image that precedes the input image with the requested tag provided for policy evaluation. The triggers in this gate evaluate the result to determine if packages were added, removed, or modified.


### Trigger: image_diff_packages_added
This trigger warns if a package was added to the SBOM.
Parameters
Optional parameter: “package_type”
Example
Raise a warning if packages were added.

```
  {
   "action": "WARN",
   "gate": "image_tag_diff_gate",
   "trigger": "image_diff_packages_added",
   "params": [],
   "id": "1ba3461f-b9db-4a6c-ac88-329d38e08df5"
  }
```

### Trigger: image_diff_packages_removed
This trigger warns if a package was deleted from the SBOM.
Parameters
Optional parameter: “package_type”
Example
Raise a warning if packages were deleted.

```
  {
   "action": "WARN",
   "gate": "image_tag_diff_gate",
   "trigger": "image_diff_packages_removed",
   "params": [],
   "id": "de05d77b-1f93-4df4-a65d-57d9042b1f3a"
  }
```

### Trigger: image_diff_packages_modified
This trigger warns if a package was changed in the SBOM.
Parameters
Optional parameter: “package_type”
Example
Raise a warning if packages were changed.

```
  {
   "action": "WARN",
   "gate": "image_tag_diff_gate",
   "trigger": "image_diff_packages_modified",
   "params": [],
   "id": "1168b0ac-df6c-4715-8077-2cb3e016cf63"
  }
```


