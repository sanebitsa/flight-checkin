# Agent Instructions

## Project and sources of truth

Build a **small Python CLI** that uses headless Playwright on a Linux server to attempt airline website check-in. Start with Southwest, then American Airlines; add a one-time systemd timer only after the manual flows work.

- Read `README.md` for orientation and `docs/PRD.md` for authoritative requirements and exclusions.
- Use `docs/KANBAN.md` for small, dependency-ordered tasks. Its cards are a proposed backlog, not evidence that code or GitHub issues exist.

## Implementation boundaries

- Keep the design simple: `checkin.py` for the CLI, one small `airlines/<name>.yaml` for public field/URL metadata, and one `airlines/<name>.py` for each Playwright flow.
- Work in small **vertical slices** that produce testable behavior. Respect Kanban dependencies and distinguish agent-executable (**AFK**) work from tasks requiring human decisions (**HUMAN**).
- Do not introduce a database, generic workflow engine, notification system, seat optimization, payment handling, or other out-of-scope features without explicit approval.
- Prefer readable Python and Playwright semantic locators. Never invent production selectors, follow-up pages, or success signals from unverified website assumptions.

## Safety and correctness

- Use only official airline sites and authorized interactions. Never bypass CAPTCHA, identity checks, or other protections, or make purchases or seat changes.
- Treat confirmation codes, passenger details, birth dates, and boarding passes as sensitive. Keep them out of source control, command-line arguments, logs, exception output, screenshots, and traces. Use private prompts or permission-restricted files.
- Report `success` only after the airline confirms completed check-in. Otherwise report `failure` or `manual_action_required`; boarding-pass availability is a separate result.
- Retry only safe transient errors within the PRD's limits. Reconcile uncertain submissions before attempting them again.
- Real-reservation testing, live airline-flow validation, and target-host systemd installation require the appropriate **HUMAN** gate. Never fabricate validation results.

## Test-driven development (required)

- Follow **red → green → refactor** for every behavior change or bug fix: write a focused, failing automated test first; run it to confirm the expected failure; implement the minimum code to pass; then refactor while keeping tests green.
- Use synthetic reservations, local fixtures, and simulated Playwright pages for repeatable tests. Never depend on live airline websites or real passenger data to run the automated suite.
- Cover inputs, terminal outcomes, safety stops, retry boundaries, and log redaction. Add regression tests for bugs before fixing them.
- Run the relevant tests after each change and before declaring a slice complete. If a test cannot run, document why and do not claim it passed.
- Keep changes focused, update documentation when behavior changes, and report the red/green test evidence, what changed, and any remaining human-validation blockers.

## Independent review and quality gates (required)

- **Before every merge:** Request a review from a person or agent who did not implement the change. The author must not approve their own work. Review PRD alignment, correctness, security/privacy, and TDD and regression-test evidence.
- Do not merge until the independent reviewer approves, blocking findings are resolved, and relevant tests and available CI checks pass. If an independent reviewer is unavailable, leave the change unmerged and flag the blocker.
- **After every merge:** Verify the integrated `main` branch with relevant integration and regression tests. Investigate and fix or revert failures before proceeding; record results without sensitive data.
- **At each major milestone** (Southwest, American, scheduling, and first release): Have an independent reviewer assess the integrated work against `docs/PRD.md` and the milestone acceptance criteria in `docs/KANBAN.md`. Record the decision, evidence, and remaining gaps; do not mark the milestone complete with unmet acceptance criteria.
- Keep existing **HUMAN** gates for authorized live-airline validation, target-host systemd setup, and release approval. Independent agent review does not replace required human decisions.
- Record review approvals and post-merge verification in the PR or backlog. Where supported, use GitHub branch protection and CI checks to enforce pre-merge gates; `AGENTS.md` alone is not enforcement.
