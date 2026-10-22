# Agent instructions

## Start here
- Read `README.md` for the project overview, `docs/PRD.md` for requirements and exclusions, and `docs/KANBAN.md` for dependency-ordered work and **AFK/HUMAN** gates.
- Follow `docs/DEVELOPMENT.md` for TDD, review, and merge procedures.
- When coordinating multiple tasks or agents, follow `.agents/skills/development-coordinator/SKILL.md`.

## Build a small, safe CLI
- Implement small, testable **vertical slices**: Southwest manual check-in first, then American Airlines, then one-time systemd scheduling.
- Prefer simple Python, headless Playwright, `checkin.py`, and one `airlines/<name>.yaml` plus `airlines/<name>.py` per airline. Do not add platforms or features excluded by the PRD.
- Use verified airline pages and semantic locators; never invent selectors or success indicators. Use only authorized actions on official sites, and never bypass security challenges or make purchases.
- Keep confirmation codes, passenger details, and boarding passes out of commits, CLI arguments, logs, traces, and screenshots. Use private prompts or restricted files.
- Mark check-in `success` only on airline confirmation. Keep boarding-pass availability separate, and stop safely for uncertain submissions or human-only steps.

## Branch and PR requirements
- Each implementing agent must create a dedicated task/vertical-slice branch from `development`, never directly from `main`. Never implement or commit directly on `development` or `main`. Concurrent agents must not share a branch or working tree; prefer separate Git worktrees.
- After local validation, open a PR **into `development`** before requesting independent review. Merge into `development` only after independent approval and required checks; follow `docs/DEVELOPMENT.md`.
- **`main` is human-controlled:** agents must never push or merge into `main`. Only a human may approve and perform the final merge from `development` into `main`.

## Non-negotiable quality gates
- **TDD:** For every behavior change or bug fix, demonstrate red → green → refactor with synthetic fixtures, then run relevant tests. Never claim unrun or live-site tests passed.
- **Before merging:** Obtain approval from an independent reviewer, resolve blockers, and pass relevant tests/checks. Never self-approve or merge without review.
- **After merging:** Verify the integrated `development` branch and record results; fix or revert regressions. For human-authorized releases, verify `main` after the human merges.
- **At major milestones:** Obtain independent acceptance review against the PRD and Kanban criteria. Preserve separate **HUMAN** gates for live reservations, target-host setup, and release approval.

For reusable pre-merge, post-merge, and milestone review steps, see `.agents/skills/independent-review/SKILL.md`.
