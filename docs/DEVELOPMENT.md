# Development workflow and quality gates

Use this guide with [the PRD](PRD.md), [the Kanban backlog](KANBAN.md), and the repository [AGENTS.md](../AGENTS.md). The PRD defines product scope; the Kanban cards define slice dependencies and acceptance criteria.

## Pick a small, reviewable slice

1. Select a ready `FC-###` card and check its dependencies and acceptance criteria. Prefer end-to-end vertical slices over building a whole system layer.
2. Treat **AFK** as implementable with local, synthetic evidence; treat **HUMAN** as requiring the specified decision, permission, real-reservation validation, or host access. Do not invent or silently waive human evidence.
3. Keep the change focused. Update docs, tests, and backlog evidence when behavior or status changes.

## Branch isolation and pull requests

1. Create a fresh branch from the current `development` for each implementing agent's assigned task or reviewable vertical slice (for example, `task/FC-001-southwest-cli`). **Never implement or commit directly on `development` or `main`.** Use a new branch for the next task, even when the same agent continues working.
2. Concurrent implementing agents must use distinct branches and must not modify the same working tree. Prefer separate Git worktrees to isolate changes. Coordinate any overlapping files or dependencies rather than sharing a branch.
3. Complete the slice using TDD and local validation, then push the task branch and open a PR targeting `development` (not `main`). Include the Kanban card, concise scope, acceptance evidence, commands/results for relevant checks, and outstanding HUMAN gates. A PR is the review surface; **open it before independent review**.
4. Request review from a person or agent who did not implement the change. Incorporate feedback on the same task branch, rerun relevant tests, and request re-review when needed. Merge into `development` only after independent approval, resolved blockers, and passing required checks. If review is unavailable, leave the PR open and unmerged.
5. Verify the integrated result on `development` as described below. Do not reuse the previous task's branch for further implementation.

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

**Before each implementation merge:** Confirm the PR comes from a dedicated branch off `development`, targets `development`, and contains scope, related card(s), sanitized test evidence, and known blockers. Obtain a decision on the PR from a person or agent **other than the implementer**. Review scope and acceptance criteria, correctness, privacy/security, TDD evidence, and regressions. Resolve blocking findings, then require independent approval and passing relevant tests/available CI checks. If no independent reviewer is available, leave the PR unmerged.

**After each implementation merge:** Verify the actual integrated `development` branch with applicable integration and regression tests. Record the commit, checks, result, and unresolved issues without sensitive data. Fix or revert failures before continuing.

**Releasing to `main` (HUMAN only):** Agents may prepare a release PR from `development` into `main` and report validation evidence, but must **never push, merge, or approve release on behalf of a human**. Only a human may authorize and execute the final merge into `main`, after deciding whether release criteria are met. Do not automatically merge a release PR after reviews or CI pass. Verify the integrated `main` commit after the human merges and record the result.

**At each major milestone:** Request an independent integrated review for Southwest, American, scheduling, and first release. Evaluate the relevant Kanban acceptance criteria and PRD, document a pass/no-go decision and gaps, and do not declare completion while required evidence is missing. Independent agent review **does not substitute for HUMAN** acceptance of live check-ins, target-host installation, or release. A completed milestone on `development` is not permission for an agent to merge into `main`.

Use the [independent-review skill](../.agents/skills/independent-review/SKILL.md) when delegating a review. Log decisions in the PR or Kanban card. These instructions are process rules, not technical enforcement; enable branch protection and required CI checks when supported.
