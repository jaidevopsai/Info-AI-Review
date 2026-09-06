# Contributing

## Before Opening a PR

1. Keep the change focused and describe the user or engineering outcome.
2. Select the stack checklist in [docs/CHECKLISTS.md](docs/CHECKLISTS.md).
3. Run the relevant local checks and record the exact commands in the PR.
4. Add tests for changed behavior, especially errors, authorization, boundaries, and cleanup.
5. Update documentation, configuration, prompts, or policy when behavior changes.

## Review Process

Reviewers should read the PR intent and changed files first, then follow the controlling code path. Report actionable findings in severity order:

```text
[High] path/to/file:line - concise title
Impact: concrete consequence
Fix: specific remediation
```

Use the [review framework](docs/REVIEW_FRAMEWORK.md) for stack-specific checks. Do not block a PR for style preferences that are not connected to correctness, security, performance, accessibility, or maintainability.

## Local Checks

Enable the staged-file hook from Git Bash:

```bash
git config core.hooksPath .githooks
mkdir -p .githooks
ln -sf "$(pwd)/scripts/pre-commit.sh" .githooks/pre-commit
```

Run the hook directly when needed:

```bash
bash scripts/pre-commit.sh
```

## Commit and PR Expectations

- Use a concise imperative commit subject.
- Keep generated files and unrelated formatting changes out of the PR.
- Link related issues and call out breaking changes, migrations, rollout steps, and known test gaps.
- Do not commit credentials, tokens, production data, or sensitive logs.
