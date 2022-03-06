# Enterprise Documentation

This is the repository for the Anchore Enterprise Documentation site.

## Filing Bugs/Issues:

Bugs should be filed in Anchore's internal JIRA in the "Anchore Enterprise" project with "compenent" field set to "Documentation".
JIRA: https://anchore.atlassian.net/jira/software/c/projects/ENTERPRISE/boards/22

## Contributing

See [Contributing](CONTRIBUTING.rst) for the DCO and sign-off information. In short, sign all
commits with 'Signed-off-by X' with `git commit -s`.

### Installing local tools for development

1. Install [hugo-extended](https://github.com/gohugoio/hugo/releases/), this is necessary because the docsy theme uses some scss functionality only in the extended version.

1. Install 'postcss-cli' and 'autoprefixer' using npm:
`npm install`

1. Clone the forked repo locally, with submodules to ensure the theme is available:
 `git clone --recurse-submodules https://github.com/<your_repo>`

  If you cloned already, then update the submodules with:
  `git submodule update --init --recursive`

1. Run hugo for local debugging/dev:
`cd enterprise-docs ; ./run_local_server.sh`

### Making changes and submitting updatess

1. Create a branch and make change, but do **NOT** use a semver (a.b.c format) branch name. Please use the JIRA issue number you are resolving (e.g. ENTERPRISE-123) or a short text (fix_readme_spacing).

1. Commit and push your branch

1. Open PR to github.com/anchore/enterprise-docs for merge to master




