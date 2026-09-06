# Multi-Stack AI Code Review Framework

A repository-ready review framework for changes spanning .NET APIs, React UIs, and Python integration or end-to-end tests. It combines human review guidance, AI prompt templates, CI validation, and a local staged-file hook.

## Contents

- [Review framework](docs/REVIEW_FRAMEWORK.md): principles, stack-specific checks, cross-stack risks, and report format.
- [Checklists](docs/CHECKLISTS.md): merge-ready checklists for each stack and PR metadata.
- [Review policy](config/review-policy.yml): machine-readable stack routing and required finding fields.
- [AI prompts](prompts/): focused prompts for .NET, React, Python, and cross-stack reviews.
- [GitHub Actions](.github/workflows/multi-stack-review.yml): conditional build, lint, test, and summary jobs.
- [Framework validation](.github/workflows/framework-validation.yml): validates this framework's policy, files, and hook.
- [Contributing guide](CONTRIBUTING.md) and [PR template](.github/pull_request_template.md): the review-ready contribution workflow.
- [Pre-commit hook](scripts/pre-commit.sh): staged-file checks for local development.

## Quick Start

Read the framework and the checklist for the stack touched by your change. Use the matching prompt with an AI reviewer, then verify its findings against the code and tests.

To enable the local hook from Git Bash or a Unix-like shell:

```bash
git config core.hooksPath .githooks
mkdir -p .githooks
ln -sf "$(pwd)/scripts/pre-commit.sh" .githooks/pre-commit
```

On Windows, Git Bash supports the same commands. Alternatively, run `bash scripts/pre-commit.sh` manually before committing.

## CI Assumptions

The workflow detects stacks from repository manifests. The .NET job expects the default `dotnet restore`, build, and test commands; the React job expects a root `package.json`; and the Python job supports `requirements.txt`, `requirements-test.txt`, or a `pyproject.toml` package. Adjust the workflow when a repository uses multiple working directories or custom commands.

The workflow intentionally does not install optional analyzers or suppress failed checks. Add those tools to the application repository's declared dependencies so CI and local development use the same versions.

## Review Output

Findings should be ordered by severity and include an exact file and line, concrete impact, remediation, tests run, and remaining gaps. A review with no findings should say so explicitly.
