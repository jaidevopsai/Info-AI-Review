# Multi-Stack AI Code Review Framework

A practical review framework for repositories that combine .NET APIs, React applications, and Python integration or end-to-end tests. Use the universal checks for every change, then apply only the stack-specific sections relevant to the diff.

## Review Workflow

1. Read the PR intent, linked issue, migration notes, and breaking changes.
2. Detect affected stacks from changed files and project manifests.
3. Review the smallest controlling code path first, then its tests and integration points.
4. Prioritize correctness, security, data loss, contract breaks, and flakiness over style.
5. Verify CI results, coverage movement, and new or changed tests.
6. Report findings with severity, file and line, impact, and a concrete fix.

## Severity

- **Blocker**: exploitable security issue, data loss, broken build, or a guaranteed production failure.
- **High**: likely correctness, contract, authorization, data isolation, or severe reliability issue.
- **Medium**: meaningful maintainability, performance, accessibility, or test reliability risk.
- **Low**: localized improvement with limited behavioral impact.

## Universal Checks

- The change matches the stated PR intent and does not include accidental files or deletions.
- Public contracts, migrations, configuration, and deployment behavior are documented.
- New behavior has focused tests, including failure and boundary paths.
- Errors preserve useful context without exposing secrets, tokens, stack traces, or personal data.
- External calls have timeouts, cancellation, retry policy where appropriate, and observable failures.
- Tests are deterministic, isolated, and safe to run in CI.
- Dependencies are pinned or constrained and vulnerability checks are enabled.

## .NET API Review

### Architecture and Dependency Injection

- Dependencies are injected through abstractions where substitution is useful; no service locator or hidden `new` dependencies.
- Singleton, scoped, and transient lifetimes match the state and thread-safety of each service.
- No scoped service is captured by a singleton; registrations are covered by a container smoke test.
- Controllers stay thin; domain and application rules do not depend on HTTP concerns.

### Async and Concurrency

- No `.Result`, `.Wait()`, or synchronous I/O in request paths.
- Async methods return `Task` or `ValueTask`; `async void` is limited to event handlers.
- `CancellationToken` is accepted and forwarded through request, database, and outbound calls.
- Timeouts and cancellation are tested; fire-and-forget work is queued and observable.
- `ConfigureAwait(false)` is considered for reusable library code, not applied mechanically to ASP.NET Core request code.

### Data Access and API Contracts

- EF Core queries avoid N+1 behavior and use projection for response DTOs where practical.
- Read-only queries use `AsNoTracking()`; pagination has bounded page size and stable ordering.
- Migrations, indexes, transactions, and optimistic concurrency behavior are reviewed.
- Entities are not exposed as public contracts; validation and nullability are explicit.
- Status codes, Problem Details responses, versioning, OpenAPI, and content negotiation are consistent.

### Errors and Security

- Global exception handling emits RFC 7807 Problem Details with correlation information, not stack traces.
- Input validation, authorization policies, tenant or user isolation, and file limits are enforced server-side.
- JWT issuer, audience, signature, expiry, and refresh behavior are validated.
- CORS is allow-listed, HTTPS is enforced, rate limiting is appropriate, and secrets are externalized.
- SQL uses parameters or LINQ; raw SQL is reviewed for injection and authorization bypasses.

### .NET Test Expectations

- Unit tests cover business rules and failure paths; integration tests exercise EF Core and middleware boundaries.
- Async tests await all operations and do not rely on sleeps or timing races.
- External services are replaced at the boundary, while at least one contract or integration path remains real.
- Tests cover validation, authorization roles, empty and large results, cancellation, conflicts, and database cleanup.

## React UI Review

### Components and Types

- Components have a clear responsibility and use composition for reusable behavior.
- Props and API responses are typed; `any` is avoided or justified at a boundary.
- Lists use stable domain keys, not array indexes when order or identity can change.
- Semantic HTML is preferred over clickable `div` elements; interactive controls expose names and states.

### Hooks and State

- Hooks obey the Rules of Hooks and effect dependencies describe the values actually read.
- Effects have cleanup for subscriptions, timers, and requests; async work is not passed directly as the effect callback.
- State is updated immutably, and derived values are not duplicated as writable state.
- Context values and selectors do not cause avoidable whole-tree rerenders; memoization is evidence-based.

### Async, Forms, and Accessibility

- Loading, empty, success, retry, and error states are explicit and usable.
- Requests handle cancellation, stale responses, timeout behavior, and retry state.
- Forms validate on the client for usability and on the server for correctness; submit controls prevent duplicate requests.
- Keyboard navigation, focus management, labels, error associations, alt text, and contrast meet WCAG 2.1 AA expectations.
- User-controlled HTML, URLs, file uploads, and storage values are validated and sanitized.

### React Test Expectations

- Tests query by accessible role, label, or text and verify user-visible behavior.
- Custom hooks, async transitions, error states, forms, keyboard flows, and accessibility regressions are covered.
- Mock providers match production contracts; tests clean up timers, handlers, and DOM state.
- Route and component code splitting, image handling, and bundle changes are checked when relevant.

## Python E2E and Integration Review

### Structure and Fixtures

- Tests follow Arrange, Act, Assert and have descriptive, behavior-oriented names.
- Tests are independent and parametrized for meaningful variations rather than duplicated.
- Fixtures use the narrowest safe scope; mutable session state and implicit ordering are avoided.
- Data factories are deterministic, idempotent, and clean up after failure.

### Mocking and Async

- Patch where a dependency is looked up, not where it was originally defined.
- External services are mocked in unit tests; integration tests intentionally verify the boundary.
- Mocks assert meaningful calls without over-specifying implementation details.
- Async tests use the configured event-loop plugin, await all coroutines, and avoid blocking sleeps.

### API, Browser, and Database Tests

- API tests validate status, schema, headers, auth, errors, pagination, rate limits, and normalized timestamps.
- Browser tests use page objects, stable semantic selectors, explicit waits, failure screenshots, and CI headless mode.
- Browser and driver lifecycle is closed on failure; cross-browser and popup or modal behavior is covered where relevant.
- Database tests use an isolated database, production-shaped schema, migrations, transactions or cleanup, and no production credentials.

### Edge Cases and Security

- Cover null, empty, boundary, Unicode, large payload, timeout, network failure, concurrency, and cleanup paths.
- Test role isolation, admin boundaries, injection payloads, XSS, CSRF, file restrictions, token expiry, and rate limiting.
- Assertion failures include useful context; exceptions are specific and never silently swallowed.
- Performance checks have a baseline and tolerance rather than fragile exact timing assertions.

## Cross-Stack Review

- API schemas, generated clients, UI assumptions, and E2E assertions agree on names, nullability, status codes, pagination, and errors.
- Authentication and authorization behavior is consistent from browser to API to database.
- A changed endpoint has an integration or contract test and an affected UI or E2E path where applicable.
- Performance impact is considered across queries, payload size, rendering, bundle size, and test runtime.

## Review Output

Use this compact structure:

```text
Summary: <what changed and overall risk>

[High] path/to/file:line - <finding>
Impact: <what can break or be exploited>
Fix: <specific remediation>

Tests: <checks run and any gaps>
```
