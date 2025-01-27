# helm-pre-commit

This repository provides a pre-commit hook to enforce consistent version bumping of your Helm charts.
It checks if any of your templates have been changed, and if so, whether your `Chart.yaml` has received a version
upgrade. It fails if that is not the case.

## Installation

Add this section to your `.pre-commit-config.yaml` file:

```yaml
repos:
  - repo: https://github.com/twaslowski/helm-versioning-pre-commit
    rev: v0.0.4
    hooks:
      - id: helm-version-bump
```

Alternatively, run the following curl command from your CLI while in the git project root:

```shell
curl -O https://raw.githubusercontent.com/twaslowski/helm-versioning-pre-commit/refs/heads/main/sample/.pre-commit-config.yaml
pre-commit install
pre-commit run --all-files

# optionally exclude the configuration file from your git repository
echo ".pre-commit-config.yaml" >> .gitignore
```

## Configuration

As of `v0.0.4`, your charts are assumed to reside in `charts/<CHART_NAME>`. If you would like more configuration
options, feel free to reach out or to create a PR, since this script is extremely straightforward.
