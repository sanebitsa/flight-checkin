---
name: independent-review
description: Independently review a flight-checkin implementation PR into development, verify integrated changes, or assess milestones and human-controlled releases against the PRD, tests, and safety gates. Use for pre-merge, post-merge, and milestone reviews.
---

# Independent review

You must be separate from the change's implementer. If you authored the change, **do not approve it**; report that independent review is needed.

1. **Identify the gate:** pre-merge PR, post-merge integration, or milestone (Southwest, American, scheduling, first release).
2. **Check isolation and review order:** for an implementation PR, confirm its dedicated task branch was created from `development`, the PR targets `development`, concurrent implementers did not share a branch, and the reviewer did not implement the change. Do not review as a substitute for opening a PR. A release PR from `development` to `main` is a separate HUMAN-only merge gate.
3. **Read the evidence:** inspect `docs/PRD.md`, `docs/KANBAN.md`, `docs/DEVELOPMENT.md`, the relevant diff or integrated commit, affected tests, and available CI output. Do not treat a backlog card as proof of implementation.
4. **Inspect risk and behavior:** verify scope, acceptance criteria, input/secret handling, redaction, authorized airline interactions, human stops, confirmation-based `success`, independent boarding-pass status, and retry/reconciliation safety when relevant.
5. **Verify test and secret-scanning discipline:** inspect red → green → refactor evidence for behavior changes and require sanitized evidence of successful **pre-commit** staged-secret/quality checks and **pre-push** history checks (or verified equivalent preflight before GitHub API writes); run relevant safe synthetic tests when feasible. Check `secret-scan` results and any relevant `python-ci` results on the PR head, and inspect the diff for credentials, private data, generated sessions, and log/trace leaks. Secret findings or missing required scan evidence block approval unless a false positive has been independently verified and documented without disclosing sensitive content. For documentation-only changes, check consistency and links. Do not run real airline flows or target-host operations without the appropriate HUMAN gate. Mark unavailable checks as unverified.
6. **Decide and record:**
   - **Pre-merge:** report findings by severity with file/line and impact; say **Approve**, **Request changes**, or **Blocked**. Approval requires resolved blockers and satisfactory test/check evidence.
   - **Post-merge:** verify the integrated `development` commit after implementation merges; report checks, pass/fail results, and whether fixes or a revert are needed. If a human has merged a release into `main`, verify that integrated commit as a separate check.
   - **Milestone:** assess each relevant acceptance criterion, required HUMAN validation, evidence, and remaining gaps; report **Pass** or **No-go**.

Never merge, push, or authorize a merge into `main`; only a human performs that action. Provide a concise sanitized review summary and record its decision in the PR or Kanban card. Do not claim to have enforced GitHub protection rules, run checks, or obtained human approval unless verified.
