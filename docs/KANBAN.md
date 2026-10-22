# Kanban backlog — flight-checkin

**Source of truth:** [PRD](PRD.md) (v0.1, 2026-10-22) and [README](../README.md).  
**Prepared:** 2026-10-22. **Repository state:** planning only; no implementation or pre-existing GitHub issues at this writing.  
**Scope:** single-user Python/Playwright CLI, Southwest → American → one-shot systemd. This file contains **proposed issue cards**, not created GitHub Issues.

## How to use this board

- **AFK**: a coding agent/developer can complete the card without live reservations or additional product choices **once its dependencies have cleared**. AFK tests use synthetic/local fixture pages; they do not assert airline compatibility.
- **HUMAN**: someone must make a permission/environment decision or run an authorized live acceptance test. Never fabricate real-site evidence or passenger data.
- **Dependencies** are *finish-to-start* gates. A card is **Ready** only when every referenced predecessor has acceptance evidence. M2 work can be explored in parallel, but M1 must pass before release is claimed; no scheduling installation before the two airline acceptance gates.
- **Done** means code/doc evidence, reproducible tests, and all acceptance checks passed. For HUMAN cards, record a dated sanitized decision and evidence; a documented **no-go** may close a discovery card but blocks dependent automation.
- Each card is intended as one small reviewable PR or human decision. If live discovery reveals multiple unknown screens, split that card rather than guessing selectors.
- **Board maintenance:** move card IDs between columns; preserve stable FC IDs and dependencies. Columns below are the initial planning snapshot, not automatically synchronized with GitHub Issues.
- Priority **P0** = release-critical; **P1** = required but not on immediate first-manual-flow critical path.

## Board snapshot

| Ready · AFK | Human decision / validation | Blocked by prerequisites | In progress | In review | Done |
| --- | --- | --- | --- | --- | --- |
| [FC-001](#fc-001-run-a-private-input-southwest-manual-cli-against-a-simulated-page) | [FC-004](#fc-004-validate-southwest-page-behavior-and-permission)<br>[FC-012](#fc-012-validate-americans-live-lookup-and-follow-up-screens)<br>[FC-019](#fc-019-choose-and-verify-the-linux-hosts-systemd-operating-mode) | [FC-002](#fc-002-load-a-restricted-reservation-file-for-a-manual-run)<br>[FC-003](#fc-003-make-outcome-codes-and-operational-logs-safe-end-to-end)<br>[FC-005](#fc-005-submit-the-real-southwest-entry-form-using-observed-fields)<br>[FC-006](#fc-006-verify-southwest-check-in-rather-than-form-submission)<br>[FC-007](#fc-007-stop-southwest-safely-at-human-only-decisions)<br>[FC-008](#fc-008-save-an-offered-southwest-boarding-pass-without-changing-check-in-status)<br>[FC-009](#fc-009-retry-transient-southwest-errors-inside-a-strict-time-budget)<br>[FC-010](#fc-010-reconcile-uncertain-submissions-before-any-retry)<br>[FC-011](#fc-011-accept-or-block-the-southwest-manual-flow-with-a-real-reservation)<br>[FC-013](#fc-013-look-up-an-american-reservation-from-the-same-cli)<br>[FC-014](#fc-014-prompt-for-american-date-of-birth-only-when-the-site-requires-it)<br>[FC-015](#fc-015-finish-the-american-check-in-path-with-verified-result-and-optional-pass)<br>[FC-016](#fc-016-accept-or-block-american-using-an-authorized-live-reservation)<br>[FC-017](#fc-017-preview-t-minus-24-hours-schedule-in-the-cli)<br>[FC-018](#fc-018-install-a-one-shot-systemd-check-in-using-a-private-input-file)<br>[FC-020](#fc-020-validate-one-shot-scheduling-on-the-target-host)<br>[FC-021](#fc-021-add-ci-safety-regression-and-operator-documentation)<br>[FC-022](#fc-022-approve-first-release-against-the-prd-checklist) | — | — | — |

## Delivery slices

| Card | Slice | Milestone | Priority | Execution | Depends on |
| --- | --- | --- | --- | --- | --- |
| [FC-001](#fc-001-run-a-private-input-southwest-manual-cli-against-a-simulated-page) | Run a private-input Southwest manual CLI against a simulated page | M1 | P0 | AFK | None |
| [FC-002](#fc-002-load-a-restricted-reservation-file-for-a-manual-run) | Load a restricted reservation file for a manual run | M1 | P0 | AFK | FC-001 |
| [FC-003](#fc-003-make-outcome-codes-and-operational-logs-safe-end-to-end) | Make outcome codes and operational logs safe end to end | M1 | P0 | AFK | FC-001 |
| [FC-004](#fc-004-validate-southwest-page-behavior-and-permission) | Validate Southwest page behavior and permission | M1 | P0 | HUMAN | None |
| [FC-005](#fc-005-submit-the-real-southwest-entry-form-using-observed-fields) | Submit the real Southwest entry form using observed fields | M1 | P0 | AFK | FC-001, FC-004 |
| [FC-006](#fc-006-verify-southwest-check-in-rather-than-form-submission) | Verify Southwest check-in rather than form submission | M1 | P0 | AFK | FC-003, FC-005 |
| [FC-007](#fc-007-stop-southwest-safely-at-human-only-decisions) | Stop Southwest safely at human-only decisions | M1 | P0 | AFK | FC-006 |
| [FC-008](#fc-008-save-an-offered-southwest-boarding-pass-without-changing-check-in-status) | Save an offered Southwest boarding pass without changing check-in status | M1 | P1 | AFK | FC-002, FC-006 |
| [FC-009](#fc-009-retry-transient-southwest-errors-inside-a-strict-time-budget) | Retry transient Southwest errors inside a strict time budget | M1 | P1 | AFK | FC-003, FC-006 |
| [FC-010](#fc-010-reconcile-uncertain-submissions-before-any-retry) | Reconcile uncertain submissions before any retry | M1 | P0 | AFK | FC-007, FC-009 |
| [FC-011](#fc-011-accept-or-block-the-southwest-manual-flow-with-a-real-reservation) | Accept or block the Southwest manual flow with a real reservation | M1 | P0 | HUMAN | FC-004, FC-007, FC-008, FC-010 |
| [FC-012](#fc-012-validate-americans-live-lookup-and-follow-up-screens) | Validate American's live lookup and follow-up screens | M2 | P0 | HUMAN | None |
| [FC-013](#fc-013-look-up-an-american-reservation-from-the-same-cli) | Look up an American reservation from the same CLI | M2 | P0 | AFK | FC-001, FC-003, FC-012 |
| [FC-014](#fc-014-prompt-for-american-date-of-birth-only-when-the-site-requires-it) | Prompt for American date of birth only when the site requires it | M2 | P0 | AFK | FC-013 |
| [FC-015](#fc-015-finish-the-american-check-in-path-with-verified-result-and-optional-pass) | Finish the American check-in path with verified result and optional pass | M2 | P0 | AFK | FC-007, FC-008, FC-010, FC-014 |
| [FC-016](#fc-016-accept-or-block-american-using-an-authorized-live-reservation) | Accept or block American using an authorized live reservation | M2 | P0 | HUMAN | FC-012, FC-015 |
| [FC-017](#fc-017-preview-t-minus-24-hours-schedule-in-the-cli) | Preview T-minus-24-hours schedule in the CLI | M3 | P0 | AFK | FC-001 |
| [FC-018](#fc-018-install-a-one-shot-systemd-check-in-using-a-private-input-file) | Install a one-shot systemd check-in using a private input file | M3 | P0 | AFK | FC-002, FC-003, FC-011, FC-016, FC-017, FC-019 |
| [FC-019](#fc-019-choose-and-verify-the-linux-hosts-systemd-operating-mode) | Choose and verify the Linux host's systemd operating mode | M3 | P0 | HUMAN | None |
| [FC-020](#fc-020-validate-one-shot-scheduling-on-the-target-host) | Validate one-shot scheduling on the target host | M3 | P0 | HUMAN | FC-011, FC-016, FC-018, FC-019 |
| [FC-021](#fc-021-add-ci-safety-regression-and-operator-documentation) | Add CI safety regression and operator documentation | Release | P1 | AFK | FC-008, FC-015, FC-018 |
| [FC-022](#fc-022-approve-first-release-against-the-prd-checklist) | Approve first release against the PRD checklist | Release | P0 | HUMAN | FC-011, FC-016, FC-020, FC-021 |

## Issue cards

### FC-001 Run a private-input Southwest manual CLI against a simulated page

**Milestone:** M1 · **Priority:** P0 · **Mode:** AFK · **Depends on:** None  
**Traceability:** US-01, US-02, US-05, US-06; FR-01, FR-03, FR-06

**Vertical slice:** Introduce `checkin.py`, minimal Python/Playwright test setup, `airlines/southwest.yaml` and `airlines/southwest.py`. Prompt for confirmation number, first name and last name without echoing secrets or accepting them as positional flags. Run one reservation through a local simulated airline form; return an explicit non-success outcome when the final state is unknown.

**Acceptance / tests:**
- [ ] `python checkin.py southwest` starts a synthetic manual flow and exits deterministically, with no scheduler needed.
- [ ] Southwest YAML contains only a public entry URL and verified-or-pending field metadata; no personal data or guessed production selectors.
- [ ] A mocked-browser test exercises prompt → adapter → page → outcome; form submission or lookup alone never yields `success`.

### FC-002 Load a restricted reservation file for a manual run

**Milestone:** M1 · **Priority:** P0 · **Mode:** AFK · **Depends on:** FC-001  
**Traceability:** US-01, US-05; FR-01, FR-06

**Vertical slice:** Add `--reservation-file PATH` for a local private JSON file (an implementation choice, not airline YAML). Validate required fields per selected airline and refuse unsafe permissions; never place values in arguments, logs or tracked examples.

**Acceptance / tests:**
- [ ] A `0600` synthetic reservation file drives a complete simulated manual CLI run.
- [ ] Group/world-readable files, missing inputs and malformed content fail safely with sanitized errors.
- [ ] Tests check accepted/rejected file modes, no echo and no secrets in process arguments.

### FC-003 Make outcome codes and operational logs safe end to end

**Milestone:** M1 · **Priority:** P0 · **Mode:** AFK · **Depends on:** FC-001  
**Traceability:** US-06, US-10; FR-04, FR-06

**Vertical slice:** Standardize terminal `success`, `failure`, `manual_action_required` mapping and stable exit codes (document chosen codes). Emit airline, stage, timestamp, result and safe error category to stderr/journal, never raw website content, exception strings or personal inputs.

**Acceptance / tests:**
- [ ] Synthetic success, failure and human-blocker runs each produce one terminal state and the documented exit code.
- [ ] A test injects booking fields into exception/page text and asserts they never reach output or traceback.
- [ ] CLI exit information is usable by shell scripts and later systemd execution.

### FC-004 Validate Southwest page behavior and permission

**Milestone:** M1 · **Priority:** P0 · **Mode:** HUMAN · **Depends on:** None  
**Traceability:** US-02, US-06, US-09; FR-01, FR-03; risk 1–2

**Vertical slice:** A person inspects the official Southwest check-in page and current automation permission, preferably in an explicitly authorized browser session. Record current labels/roles, required fields, next-screen choices, success cues and blockers without booking data.

**Acceptance / tests:**
- [ ] Document a date-stamped, sanitized observation usable to implement selectors and confirmation assertions.
- [ ] Record whether headless automated use is permitted and practical; if not, document a manual-only stop decision.
- [ ] No live confirmation number, name, boarding pass or screenshot containing PII enters git.

### FC-005 Submit the real Southwest entry form using observed fields

**Milestone:** M1 · **Priority:** P0 · **Mode:** AFK · **Depends on:** FC-001, FC-004  
**Traceability:** US-02; FR-01, FR-03, FR-06

**Vertical slice:** Replace simulated entry selectors with evidence-backed role/label locators in the Southwest adapter, loading field metadata from YAML. Limit actions to opening the official site, filling the three verified lookup fields and activating the ordinary check-in entry action.

**Acceptance / tests:**
- [ ] A local Playwright fixture with the observed labels proves correct form entry from CLI inputs.
- [ ] A missing/renamed field yields safe failure or manual intervention, not arbitrary element clicks.
- [ ] No inferred seat changes, purchases or follow-up steps are implemented.

### FC-006 Verify Southwest check-in rather than form submission

**Milestone:** M1 · **Priority:** P0 · **Mode:** AFK · **Depends on:** FC-003, FC-005  
**Traceability:** US-02, US-06; FR-03, FR-04

**Vertical slice:** Implement only observed post-lookup progression and explicit final confirmation detection in the Southwest adapter. Separate looked-up, submitted, confirmed, rejected and inconclusive states.

**Acceptance / tests:**
- [ ] Fixture with a true observed confirmation produces `success`; lookup-only and click-only pages do not.
- [ ] Known negative outcome returns `failure`; ambiguous or unsupported continuation never returns `success`.
- [ ] Integration tests exercise CLI → browser pages → final status and sanitized evidence.

### FC-007 Stop Southwest safely at human-only decisions

**Milestone:** M1 · **Priority:** P0 · **Mode:** AFK · **Depends on:** FC-006  
**Traceability:** US-09; FR-03, FR-05

**Vertical slice:** Add fail-closed detection for CAPTCHA, identity/document verification, payment, unsupported seat selection and unfamiliar required actions. Shared result categories may be reused by American, but keep navigation in airline adapters.

**Acceptance / tests:**
- [ ] Simulated CAPTCHA, ID, payment and seat-choice screens each stop with `manual_action_required`.
- [ ] Negative browser assertions prove the adapter never buys, upgrades, changes seats or bypasses a challenge.
- [ ] An unrecognized page transition cannot silently advance to success.

### FC-008 Save an offered Southwest boarding pass without changing check-in status

**Milestone:** M1 · **Priority:** P1 · **Mode:** AFK · **Depends on:** FC-002, FC-006  
**Traceability:** US-07; FR-04, FR-06

**Vertical slice:** When a directly downloadable airline file is actually offered, use Playwright download handling to persist its original bytes into a restricted local directory/file. Save no screenshots as substitutes, and make pass availability distinct from confirmed check-in.

**Acceptance / tests:**
- [ ] A fixture-provided download is saved byte-for-byte with restrictive permissions and no name/code leakage in logs.
- [ ] A confirmed check-in without a direct download remains `success` with pass marked unavailable.
- [ ] Failed/unsafe download paths do not expose an incomplete or world-readable file.

### FC-009 Retry transient Southwest errors inside a strict time budget

**Milestone:** M1 · **Priority:** P1 · **Mode:** AFK · **Depends on:** FC-003, FC-006  
**Traceability:** US-08; FR-05

**Vertical slice:** On safe transient navigation/network errors only, retry at 30-second intervals for no longer than 10 elapsed minutes. Inject a clock/sleep interface for deterministic tests; do not re-submit uncertain check-ins.

**Acceptance / tests:**
- [ ] Synthetic transient errors recover or terminate at the 10-minute budget, with deterministic attempts/timestamps.
- [ ] Eligibility errors, manual blockers and post-submit uncertainty do not enter blind retry loops.
- [ ] CLI status and sanitized log show eventual verified result or failure.

### FC-010 Reconcile uncertain submissions before any retry

**Milestone:** M1 · **Priority:** P0 · **Mode:** AFK · **Depends on:** FC-007, FC-009  
**Traceability:** US-06, US-08, US-09; FR-04, FR-05

**Vertical slice:** Track whether the browser might have submitted check-in. After a timeout or lost response, re-open an airline-supported status/lookup path and inspect confirmation before any repeat action. If trustworthy status cannot be established, stop safely.

**Acceptance / tests:**
- [ ] In a fixture where the first submit succeeds but response is lost, only one submission occurs and the final status is verified.
- [ ] In an inconclusive fixture, no second transaction is sent and no `success` is claimed.
- [ ] Tests explicitly count submissions and cover manual blockers during reconciliation.

### FC-011 Accept or block the Southwest manual flow with a real reservation

**Milestone:** M1 · **Priority:** P0 · **Mode:** HUMAN · **Depends on:** FC-004, FC-007, FC-008, FC-010  
**Traceability:** M1 acceptance; testing §8

**Vertical slice:** A person supplies an eligible reservation, authorizes the live run and inspects the airline's actual final state. Confirm permitted operation; if a pass is not offered, record it as unavailable, not failed check-in.

**Acceptance / tests:**
- [ ] Record date, sanitized sequence, actual final state, pass availability and any block/no-go decision.
- [ ] Check runtime output and local files for privacy problems; keep reservation values and pass files out of git.
- [ ] Only mark M1 accepted if the permitted real session confirms behavior or the recorded human-blocker behavior matches requirements.

### FC-012 Validate American's live lookup and follow-up screens

**Milestone:** M2 · **Priority:** P0 · **Mode:** HUMAN · **Depends on:** None  
**Traceability:** US-03, US-06, US-09; FR-01, FR-03; risk 1, 2, 4

**Vertical slice:** Review permission and the official American reservation lookup in a permitted browser. Observe whether last name and confirmation code suffice, when date of birth appears, how multi-part/hyphenated surnames are handled, subsequent check-in choices and final success evidence.

**Acceptance / tests:**
- [ ] Produce dated, sanitized labels/roles, page-state notes and a permission/feasibility go/no-go.
- [ ] Distinguish universally required fields from conditional prompts; do not assume first name or ticket number is required.
- [ ] No real reservation identifiers or sensitive screenshots are committed.

### FC-013 Look up an American reservation from the same CLI

**Milestone:** M2 · **Priority:** P0 · **Mode:** AFK · **Depends on:** FC-001, FC-003, FC-012  
**Traceability:** US-01, US-03, US-05; FR-01, FR-03, FR-06

**Vertical slice:** Introduce `airlines/american.yaml` and a small American adapter. Route `checkin.py american` through last name and the confirmation-code path using observed locators; a lookup is not a completed check-in.

**Acceptance / tests:**
- [ ] Local Playwright entry fixture receives last name and confirmation code, without requesting first name or date of birth up front.
- [ ] Unrecognized/changed fields fail safely and use the same sanitized outcome contract.
- [ ] Tests cover both interactive and restricted-file input where applicable.

### FC-014 Prompt for American date of birth only when the site requires it

**Milestone:** M2 · **Priority:** P0 · **Mode:** AFK · **Depends on:** FC-013  
**Traceability:** US-03, US-01; FR-01, FR-06

**Vertical slice:** Inspect observed American page state after lookup, request DOB via a non-echoing input only when explicitly required, and apply only documented surname normalization (no silent generic edits). For scheduled files, use a DOB only if the site requests it; fail safely when absent.

**Acceptance / tests:**
- [ ] Fixture with no DOB gate never requests/uses it; DOB-required fixture requests it securely or stops safely if unavailable.
- [ ] Surname examples cover spaces and hyphens without altering unrelated fields.
- [ ] DOB never appears in logs, process arguments, configuration YAML or fixture snapshots.

### FC-015 Finish the American check-in path with verified result and optional pass

**Milestone:** M2 · **Priority:** P0 · **Mode:** AFK · **Depends on:** FC-007, FC-008, FC-010, FC-014  
**Traceability:** US-03, US-06, US-07, US-08, US-09; FR-03–05

**Vertical slice:** Implement evidence-backed American passenger/check-in continuation, final success detector, human-only stop conditions and directly offered pass download. Reuse outcome, privacy and retry guards without building a generic page-workflow engine.

**Acceptance / tests:**
- [ ] Mocked multi-screen American check-in confirms success only from an observed final airline state.
- [ ] Payment, document/identity, CAPTCHA, seat choice and inconclusive submission all stop safely without a purchase or repeat submit.
- [ ] Optional direct pass retains original bytes and its absence does not negate confirmed check-in.

### FC-016 Accept or block American using an authorized live reservation

**Milestone:** M2 · **Priority:** P0 · **Mode:** HUMAN · **Depends on:** FC-012, FC-015  
**Traceability:** M2 acceptance; testing §8

**Vertical slice:** With explicit permission and a user-controlled eligible reservation, test American lookup, conditional DOB and completion/blocked outcome in a live browser. Sanitize the evidence and record deviations for follow-up changes.

**Acceptance / tests:**
- [ ] Confirm actual required inputs, relevant follow-up decisions and an airline-provided final state or correct human-blocker outcome.
- [ ] Note whether direct pass download is available, without treating absence as check-in failure.
- [ ] Do not claim M2 passed from local fixtures or public form inspection alone.

### FC-017 Preview T-minus-24-hours schedule in the CLI

**Milestone:** M3 · **Priority:** P0 · **Mode:** AFK · **Depends on:** FC-001  
**Traceability:** US-04; FR-02

**Vertical slice:** Add `checkin.py schedule --dry-run` that takes a departure timestamp with explicit UTC offset or unambiguous IANA zone information, calculates the absolute target 24 hours earlier and displays only nonsensitive scheduling data, without creating units or opening airline pages.

**Acceptance / tests:**
- [ ] Tests cover offset, UTC and DST transition instants, including nonexistent/ambiguous local times.
- [ ] Missing/ambiguous zone and past trigger fail with actionable safe errors.
- [ ] The preview reports the correct absolute instant independent of server timezone.

### FC-018 Install a one-shot systemd check-in using a private input file

**Milestone:** M3 · **Priority:** P0 · **Mode:** AFK · **Depends on:** FC-002, FC-003, FC-011, FC-016, FC-017, FC-019  
**Traceability:** US-04, US-05, US-10; FR-02, FR-06

**Vertical slice:** Implement `checkin.py schedule` using the approved host systemd mode and T-24h instant. Pass only a private reservation-file path to a one-time service/timer; run the same CLI, exit status, retries and journal-safe logging as manual mode. No recurring polling daemon.

**Acceptance / tests:**
- [ ] Synthetic installation/inspection tests verify units or transient timer fire at intended absolute time, invoke once and never expose secrets in `ExecStart` or unit metadata.
- [ ] A mocked systemd runner tests creation error, past time, service exit mapping and removal/cleanup behavior.
- [ ] Document commands to install, inspect, troubleshoot and remove a scheduled run.

### FC-019 Choose and verify the Linux host's systemd operating mode

**Milestone:** M3 · **Priority:** P0 · **Mode:** HUMAN · **Depends on:** None  
**Traceability:** US-04; FR-02, FR-06; architecture §6

**Vertical slice:** A human checks the actual Linux host and decides user timer with lingering versus system service, service account rights, Chromium/Playwright availability, private input location, SSH logout persistence and writable output location. No credentials are committed.

**Acceptance / tests:**
- [ ] Record chosen service scope, lifecycle expectations, available privileges and permitted local file paths.
- [ ] Prove a harmless one-shot job can run after SSH disconnect; document environment blockers.
- [ ] If no reliable supported systemd mode exists, block automated scheduling rather than invent a workaround.

### FC-020 Validate one-shot scheduling on the target host

**Milestone:** M3 · **Priority:** P0 · **Mode:** HUMAN · **Depends on:** FC-011, FC-016, FC-018, FC-019  
**Traceability:** M3 acceptance; FR-02; testing §8

**Vertical slice:** A human first validates a harmless synthetic timer with journal visibility and one-run semantics, then authorizes a real eligible T-24h attempt where feasible. Verify time-zone interpretation, failure reporting, secret handling and that no repeated jobs occur.

**Acceptance / tests:**
- [ ] Capture sanitized timer fire-time evidence, observed single invocation and `journalctl` result on the representative Linux host.
- [ ] Show no secret reservation values in unit/journal/process listing and no unintended repeated check-in.
- [ ] Do not claim a T-24h live acceptance test was completed unless an eligible authorized reservation was actually tested.

### FC-021 Add CI safety regression and operator documentation

**Milestone:** Release · **Priority:** P1 · **Mode:** AFK · **Depends on:** FC-008, FC-015, FC-018  
**Traceability:** Quality §7; tests §8; exclusions §10

**Vertical slice:** Add automated synthetic tests for all active CLI/adapter/scheduler paths and privacy regressions. Update README with setup, manual/scheduled commands, safe reservation-file handling, logs, expected results, and explicit unsupported operations; keep `docs/PRD.md` authoritative.

**Acceptance / tests:**
- [ ] CI executes unit/browser-fixture/systemd-render tests without network or live booking data.
- [ ] Tests fail if secrets leak into logs, exceptions, simulated screenshots/fixtures, command arguments, YAML or generated units.
- [ ] README documents how to obtain manual help for unsupported airline steps and does not promise unattended success.

### FC-022 Approve first release against the PRD checklist

**Milestone:** Release · **Priority:** P0 · **Mode:** HUMAN · **Depends on:** FC-011, FC-016, FC-020, FC-021  
**Traceability:** Release acceptance §8; exclusions §10

**Vertical slice:** Review authorized live evidence, CI results, privacy constraints, retries, explicit exclusions and operational documentation. Decide release, restricted/manual-only release or no-go; record unresolved website assumptions.

**Acceptance / tests:**
- [ ] Every release checklist item in PRD §8 has linked evidence or is explicitly marked unresolved.
- [ ] Human signs off on airline automation permission, any security blockers and allowed unattended scope.
- [ ] No false claims that mock tests or public entry forms demonstrate real check-in success.

## Dependency and release gates

1. **First executable slice:** FC-001. It must be runnable on a synthetic site and report an honest outcome, even before any real website is validated.
2. **Early human gates:** FC-004 (Southwest UI/permission), FC-012 (American UI/permission), FC-019 (Linux/systemd feasibility). Run in parallel with AFK slices; they must not be silently treated as approved.
3. **Southwest release gate:** FC-011. Do not claim real manual check-in support based only on Playwright fixtures.
4. **American release gate:** FC-016. Conditional DOB and follow-up screens require actual evidence.
5. **Scheduling gate:** FC-018 waits for FC-011, FC-016 and FC-019; FC-020 proves target-host behavior. Scheduling is a one-time attempt target, **not** a guarantee of check-in.
6. **Release decision:** FC-022. A blocked airline or permission decision cannot be papered over by green CI.

**Suggested AFK execution order (respecting gates):** FC-001 → FC-002 / FC-003 / FC-017 → FC-005 → FC-006 → FC-007 / FC-008 / FC-009 → FC-010 → FC-013 → FC-014 → FC-015 → FC-018 → FC-021. Parallelize independent branches where practical. HUMAN FC-004, FC-012 and FC-019 can begin immediately.

## Non-goals (do not add backlog cards for v1)

No database, generalized YAML workflow engine, paid transactions or seat changes, CAPTCHA/identity bypass, notifications/dashboard, account vault, reservation sync/rebooking, recurring polling, automatic delayed boarding-pass retrieval, or airlines other than Southwest and American. Follow the PRD when requirements conflict with assumptions.

## Evidence and privacy protocol

- Use synthetic values and local controlled pages in automated tests; never commit actual booking codes, passenger names, DOB, boarding passes or sensitive screenshots.
- Human reviewers should attach or reference only **sanitized** observations (date, page state, semantic locator, result, constraints) and mark uncertainty. Keep live artifacts private outside the repository.
- If a site's permission/anti-bot rules forbid automated interaction, record **no-go** and return/manualize that workflow. Do not attempt circumvention.
- For every AFK card, a reviewer should be able to run its test commands and see the new behavior through CLI → adapter/browser fixture → state/result/storage where applicable, rather than only seeing a new isolated library.
