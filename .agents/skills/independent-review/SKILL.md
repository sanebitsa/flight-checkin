---
name: independent-review
description: Independently review a flight-checkin PR before merge, verify a merged change on main, or assess a major milestone against the PRD, tests, and safety gates. Use when asked for a pre-merge, post-merge, or milestone review.
---

# Independent review

You must be separate from the change's implementer. If you authored the change, **do not approve it**; report that independent review is needed.

1. **Identify the gate:** pre-merge PR, post-merge integration, or milestone (Southwest, American, scheduling, first release).
2. **Check isolation and review order:** for a pre-merge review, confirm the change is on a dedicated task branch, the PR targets `main`, concurrent implementers did not share a branch, and the reviewer did not implement the change. Do not review as a substitute for opening a PR.
3. **Read the evidence:** inspect `docs/PRD.md`, `docs/KANBAN.md`, `docs/DEVELOPMENT.md`, the relevant diff or integrated commit, affected tests, and available CI output. Do not treat a backlog card as proof of implementation.
4. **Inspect risk and behavior:** verify scope, acceptance criteria, input/secret handling, redaction, authorized airline interactions, human stops, confirmation-based `success`, independent boarding-pass status, and retry/reconciliation safety when relevant.
5. **Verify test discipline:** inspect red → green → refactor evidence for behavior changes; run relevant safe synthetic tests when feasible. For documentation-only changes, check consistency and links. Do not run real airline flows or target-host operations without the appropriate HUMAN gate. Mark unavailable checks as unverified.
6. **Decide and record:**
   - **Pre-merge:** report findings by severity with file/line and impact; say **Approve**, **Request changes**, or **Blocked**. Approval requires resolved blockers and satisfactory test/check evidence.
   - **Post-merge:** verify the integrated `main` commit; report checks, pass/fail results, and whether fixes or a revert are needed.
   - **Milestone:** assess each relevant acceptance criterion, required HUMAN validation, evidence, and remaining gaps; report **Pass** or **No-go**.

Provide a concise sanitized review summary and record its decision in the PR or Kanban card. Do not claim to have enforced GitHub protection rules, run checks, or obtained human approval unless verified.
