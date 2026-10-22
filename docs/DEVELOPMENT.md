# Development workflow and quality gates

Use this guide with [the PRD](PRD.md), [the Kanban backlog](KANBAN.md), and the repository [AGENTS.md](../AGENTS.md). The PRD defines product scope; the Kanban cards define slice dependencies and acceptance criteria.

## Pick a small, reviewable slice

1. Select a ready `FC-###` card and check its dependencies and acceptance criteria. Prefer end-to-end vertical slices over building a whole system layer.
2. Treat **AFK** as implementable with local, synthetic evidence; treat **HUMAN** as requiring the specified decision, permission, real-reservation validation, or host access. Do not invent or silently waive human evidence.
3. Keep the change focused. Update docs, tests, and backlog evidence when behavior or status changes.

## Required test-driven development

For every behavior change or bug fix:

1. **Red:** Write a focused failing automated test and run it to observe the expected failure.
2. **Green:** Implement the smallest change that makes the test pass.
3. **Refactor:** Improve the code without changing behavior and rerun the relevant tests.

Use synthetic reservations, local fixtures, and simulated Playwright pages for automated tests. Cover input validation, successful and non-successful terminal states, manual-action stops, bounded retries, uncertain submissions, and sensitive-data redaction. Add a regression test before fixing a bug. Never require a live airline site or real passenger data for the ordinary automated suite.

Record the failing-test evidence, passing-test evidence, and commands used in the PR or Kanban card. If a check cannot run, state why and leave its result **unverified**. Documentation-only changes need review and link checks, not contrived behavioral tests.

## Safety checks for changes

- Use only official airline sites and interactions authorized by the reservation holder. Never bypass CAPTCHA, identity checks, or other protections, or initiate purchases or seat changes.
- Use restricted input files or private prompts. Never include reservation codes, names, dates of birth, boarding-pass contents, or other sensitive data in source control, arguments, logs, exceptions, screenshots, or traces.
- Check-in `success` requires an airline-confirmed final state; submitted forms and boarding-pass downloads do not prove success. Retry transient failures only within the PRD bounds, and reconcile uncertain submissions before resubmitting.
- Live-flow validation and target-host systemd installation are **HUMAN** gates, not routine automated tests.

## Review and merge lifecycle

**Before every merge:** Open a reviewable PR with scope, related card(s), sanitized test evidence, and known blockers. Obtain a decision from a person or agent **other than the implementer**. Review scope and acceptance criteria, correctness, privacy/security, TDD evidence, and regressions. Resolve blocking findings, then require independent approval and passing relevant tests/available CI checks. If no independent reviewer is available, leave the PR unmerged.

**After every merge:** Verify the actual integrated `main` branch with applicable integration and regression tests. Record the commit, checks, result, and unresolved issues without sensitive data. Fix or revert failures before continuing.

**At each major milestone:** Request an independent integrated review for Southwest, American, scheduling, and first release. Evaluate the relevant Kanban acceptance criteria and PRD, document a pass/no-go decision and gaps, and do not declare completion while required evidence is missing. Independent agent review **does not substitute for HUMAN** acceptance of live check-ins, target-host installation, or release.

Use the [independent-review skill](../.agents/skills/independent-review/SKILL.md) when delegating a review. Log decisions in the PR or Kanban card. These instructions are process rules, not technical enforcement; enable branch protection and required CI checks when supported.
