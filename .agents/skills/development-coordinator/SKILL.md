---
name: development-coordinator
description: Assess flight-checkin development progress, identify dependency-ready Kanban tasks, and coordinate isolated implementation agents, independent reviews, and integration into development. Use when asked to plan, assign, or coordinate development work.
---

# Development coordinator

Coordinate small, testable vertical slices without becoming a second project-management platform. Follow repository `AGENTS.md`, `docs/DEVELOPMENT.md`, and the independent-review skill at `../independent-review/SKILL.md`. The PRD defines scope; no skill overrides a HUMAN gate.

## 1. Reconcile the actual state

1. Read `docs/PRD.md` and `docs/KANBAN.md`. Treat the Kanban board as a proposed snapshot, **not** proof that tasks, issues, or code are complete.
2. Inspect the latest `development` tree, relevant GitHub issues and open/merged PRs, task branches, checks, and recorded acceptance evidence. Identify in-progress ownership and merge/review blockers before assigning work. If available evidence conflicts, report uncertainty rather than guessing.
3. For each candidate `FC-###` card, evaluate its dependencies and acceptance criteria against **verified evidence**. Mark it ready only when its predecessors are accepted, it is not already assigned, and no HUMAN gate remains unmet.
4. Keep AFK implementation work separate from HUMAN decisions, authorized live-airline tests, host installation, and release approval. Present HUMAN blockers to the user; do not declare them cleared.

## 2. Choose work and prevent collisions

- Prioritize ready P0 tasks on the immediate critical path; prefer small end-to-end vertical slices. Select at most **two concurrent implementation tasks** by default, and fewer when file overlap, dependencies, or available capacity make parallel work unsafe.
- Never assign one task twice. Before dispatching, check for an existing owner, task branch, active worktree, or open PR. Do not infer that lack of a GitHub Issue means the Kanban card is unassigned.
- Avoid concurrent edits to the same files; serialize overlapping slices or explicitly coordinate ownership. Keep each task on its own branch created from the current `development`, preferably in a separate Git worktree. No implementing agent commits directly to `development` or `main`.

## 3. Delegate only when delegation exists

- Determine whether this runtime actually provides task/subagent creation and progress-inspection capabilities. If available, hand off work using those tools and record the resulting agent/task identifier.
- If not available, **do not pretend to start agents or work in the background**. Produce ready-to-use assignments and report that dispatch is pending. Do not promise autonomous follow-up.
- Include in every assignment: `FC-###` and objective, verified prerequisites, exact acceptance criteria, branch name and `development` base, owned file boundaries, TDD expectations, privacy/safety constraints, expected PR target (`development`), evidence to return, and any HUMAN blockers. Require hook installation and **passing local pre-commit and pre-push preflight before any commit or push**; GitHub API-based agents must run equivalent checks on an isolated local staged tree **before** remote writes, or stop.
- A task is `assigned` only when a real agent accepts or a human explicitly takes ownership. Keep status claims tied to actual GitHub/agent evidence; never invent agents, commits, tests, or task results.

## 4. Review, integrate, and verify

1. Implementers follow red → green → refactor, use synthetic fixtures, and open a PR **into `development` before independent review**.
2. Arrange an independent reviewer who did not implement the change; direct them to `../independent-review/SKILL.md`. If no such reviewer is available, leave the PR unmerged and mark review blocked.
3. Merge to `development` only after recorded independent approval, resolved blocking findings, and passing required checks. If authorized tooling cannot verify a gate or perform an action, report the blocker instead of declaring completion.
4. Verify the integrated `development` commit after merging. Record sanitized test/CI results, update the Kanban card/issue with evidence, and recalculate newly ready tasks.
5. For milestones, request independent integrated acceptance against the PRD and Kanban; preserve HUMAN validation/approval gates.

**Never push, merge, or approve a release into `main`.** Agents may prepare a `development` → `main` release PR, but only a human can approve and execute that merge. No coordinator delegation overrides that rule.

## 5. Report a concise coordination snapshot

Report **Ready**, **Assigned/In progress**, **In review**, **Blocked (including HUMAN)**, and **Done/verified**, with card IDs, owners or pending ownership, PR links, dependencies, next action, and any missing evidence. Distinguish planned assignments from actually launched agents. Do not expose booking codes, passenger data, boarding passes, or secret-bearing diagnostics.
