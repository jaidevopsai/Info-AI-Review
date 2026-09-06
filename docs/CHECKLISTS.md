# Review Checklists

Use these as merge checklists. Mark an item only when the code or an automated check provides evidence.

## .NET API

- [ ] DI lifetimes are correct and container validation passes.
- [ ] No blocking async calls or unobserved fire-and-forget work.
- [ ] Cancellation and timeout flow reaches database and outbound calls.
- [ ] EF Core queries avoid N+1, use projection or `AsNoTracking()` where appropriate, and have bounded pagination.
- [ ] Migrations, indexes, transactions, and concurrency behavior are reviewed.
- [ ] DTOs, validation, status codes, versioning, and OpenAPI match the contract.
- [ ] Problem Details and global exception handling do not expose sensitive data.
- [ ] Authentication, authorization, tenant isolation, CORS, HTTPS, rate limiting, and secrets are covered.
- [ ] Unit, integration, authorization, validation, cancellation, conflict, and boundary tests are present.
- [ ] Build, analyzers, dependency scan, and coverage checks pass.

## React UI

- [ ] Components have clear responsibilities and stable list keys.
- [ ] Props, API data, events, and state are typed without unjustified `any`.
- [ ] Hooks obey dependency and cleanup rules; state updates are immutable.
- [ ] Loading, empty, error, retry, and cancellation states are usable.
- [ ] Forms validate client and server constraints and prevent duplicate submits.
- [ ] Semantic HTML, labels, focus behavior, keyboard access, alt text, and contrast are verified.
- [ ] User-controlled HTML, URLs, uploads, and storage values are safe.
- [ ] Behavioral, async, hook, form, and accessibility tests use user-facing queries.
- [ ] Bundle, image, and rendering impact is understood.
- [ ] Lint, typecheck, formatting, tests, and production build pass.

## Python E2E and Integration

- [ ] Tests are independent, descriptive, deterministic, and follow AAA structure.
- [ ] Fixture scope is intentional and cleanup runs after failures.
- [ ] Factories isolate data; no production database or shared mutable state is used.
- [ ] Mocks patch the lookup site and assert meaningful behavior.
- [ ] Async tests await all work and use timeouts without blocking sleeps.
- [ ] API status, schema, headers, auth, errors, pagination, and rate limits are checked.
- [ ] UI tests use page objects, stable selectors, explicit waits, lifecycle cleanup, and failure artifacts.
- [ ] Migrations and database isolation are tested.
- [ ] Null, boundary, Unicode, large payload, timeout, network failure, and race paths are covered.
- [ ] Authorization, injection, XSS, CSRF, upload, token, and rate-limit scenarios are covered.
- [ ] Lint, format, type checks, unit, integration, and E2E suites pass.

## PR Metadata

- [ ] Intent and affected stacks are clear.
- [ ] Linked issue, migration, rollout, and breaking changes are documented.
- [ ] CI checks are green and coverage movement is understood.
- [ ] Findings are reported with severity, location, impact, and fix.
