# Product Requirements Document: flight-checkin

**Status:** Proposed / not implemented  
**Version:** 0.1  
**Last updated:** 2026-10-22  
**Document authority:** This is the canonical product requirements document, migrated from the initial README on October 22, 2026. Website field observations are preliminary and require live-browser validation.

## 1. Product summary

`flight-checkin` is a small, single-user Python command-line application for a headless Linux server accessed over SSH. Given an airline, reservation details, and a scheduled departure timestamp, it should open the airline's official website with Playwright, complete the normal check-in flow when possible, and report a verified outcome.

The product should **attempt check-in 24 hours before departure**, not promise success at that instant. Airline eligibility, website behavior, scheduling delay, and network availability remain outside its control.

**Initial airlines:** Southwest Airlines and American Airlines.  
**Initial airports of interest:** DFW, DAL, and SMF, without restricting other airports.  
**Project state:** Planning only. The repository does not yet contain an implemented application.

## 2. Problem and desired outcome

### Problem

Airline check-in often becomes available shortly before departure and requires opening an airline website and submitting booking information. The user wants a small utility that performs these routine steps automatically when the site permits them, without building a reservation-management platform.

### Desired outcome

For a reservation supplied by the user, the utility:

1. Attempts the normal airline website check-in at the configured, departure-relative time, or immediately in manual mode.
2. Uses only the reservation inputs necessary for that airline's observed flow.
3. Confirms success from an airline-provided final state; it must not equate a submitted form with successful check-in.
4. Saves a boarding pass locally when the airline directly offers a downloadable file.
5. Exits with an unambiguous result of `success`, `failure`, or `manual_action_required`, recording useful diagnostics without exposing sensitive booking data.

### Success criteria for the first release

- A permitted, end-to-end Southwest check-in can be completed and its final result verified during a real-browser validation.
- American's reservation lookup can be completed with its actual required inputs; any additional security step is requested only when observed.
- A one-time systemd timer can start the run for the correct instant 24 hours before scheduled departure, accounting for the stated time zone.
- Expected network and website failures follow bounded, safe retries; human-only or unsafe steps do not proceed automatically.
- No booking codes, passenger names, dates of birth, or boarding-pass contents appear in routine logs.

These are **acceptance targets**, not assertions of currently working functionality or guaranteed airline support.

## 3. Users and operating context

**Primary user:** An individual who controls the reservations and operates a Python CLI on a Linux machine over SSH.

**Operating constraints:**

- Linux server with headless Playwright Chromium; no persistent GUI is required.
- One reservation handled per invocation. A reservation may contain connections or multiple legs, which are governed by the airline's eligibility rules rather than a guessed per-leg check-in schedule.
- Initial interaction is via CLI and local files. Status is read through local logs or `journalctl`.
- Airline sites and their rules may change without notice; automation must rely on real browser evidence and permitted interactions.

## 4. User stories and acceptance criteria

| ID | User story | Acceptance criteria |
| --- | --- | --- |
| US-01 | As a traveler, I want to supply a reservation without exposing personal details to shell history or process listings. | Airline, confirmation number, and last name are accepted via interactive or restricted-file input; sensitive fields are not required in CLI arguments or echoed to logs. |
| US-02 | As a Southwest traveler, I want the app to find my booking. | The Southwest flow collects confirmation number, first name, and last name, then activates the site's `Check in` action. |
| US-03 | As an American traveler, I want the app to look up my booking with only needed information. | The initial flow uses last name and confirmation code; date of birth is requested only if the actual site requires it. First name and ticket number are not presumed necessary. |
| US-04 | As a traveler, I want check-in attempted as soon as the normal 24-hour window opens. | Given an explicit departure date/time and time zone, a one-time systemd timer is set for the corresponding instant 24 hours earlier. |
| US-05 | As a developer, I want to run check-in manually. | A direct CLI mode runs without creating a timer and reports the same outcome states. |
| US-06 | As a traveler, I want trustworthy status. | `success` is emitted only after checking a site-confirmed final state; otherwise the app reports `failure` or `manual_action_required`. |
| US-07 | As a traveler, I want a boarding pass when easily available. | If the completed flow exposes a direct downloadable boarding pass, the original downloaded file is saved in a private local location; lack of a downloadable pass is reported without misrepresenting check-in state. |
| US-08 | As a traveler, I want short-lived technical failures handled automatically. | Safe transient failures are retried every 30 seconds for no more than 10 minutes; an uncertain prior submission is checked before another submission. |
| US-09 | As a traveler, I want the script to stop rather than make unexpected choices. | CAPTCHA, identity/document checks, unsupported seat decisions, and payment requests end in `manual_action_required`; no purchase, security bypass, or seat change is attempted. |
| US-10 | As an operator, I want enough operational evidence to diagnose a run. | Logs include airline, non-sensitive timestamps, stage, result, and sanitized error category, with no booking or passenger secrets. |

## 5. Functional requirements

### FR-01: Reservation inputs

**Shared required input:** airline, confirmation number, last name, and, for scheduled execution, departure date/time with an explicit time zone.

**Airline-specific input requirements:**

| Airline | Initial URL | Initial form fields | Entry action | Verification caveat |
| --- | --- | --- | --- | --- |
| Southwest | https://www.southwest.com/air/check-in/ | `confirmation_number`, `first_name`, `last_name` | `Check in` | All three fields were marked required in the publicly viewed entry form. |
| American | https://www.aa.com/reservation/flightCheckInViewReservationsAccess.do | `last_name`, `confirmation_number`; conditionally `date_of_birth` | `Find your trip`, followed by later check-in pages | The entry URL may require a live JavaScript session. Whether date of birth is universally required is **unverified**. |

For American, the preferred lookup identifier is the six-letter confirmation code, not the alternative ticket-number path. American's public instructions permit spaces within multiple last names and advise omitting special characters such as hyphens. Apply any airline-specific normalization carefully and test it against valid input examples; do not silently alter unrelated fields.

Departure time and time zone are **scheduler data**, not verified fields in either website's initial entry form. Follow-up steps such as passenger selection or document verification are not yet characterized, so they must be discovered and tested, not assumed.

**References used for the original field observations:**

- [Southwest check-in form](https://www.southwest.com/air/check-in/index.html?validate=true)
- [American check-in entry URL](https://www.aa.com/reservation/flightCheckInViewReservationsAccess.do)
- [American Find your trip](https://www.aa.com/manage-reservation/viewres/ui/app/)

The above observations were reviewed on October 22, 2026 using publicly accessible page content, not a submitted real reservation.

### FR-02: Scheduling

- Accept a scheduled departure timestamp with sufficient time-zone information to identify the absolute instant.
- Compute the trigger at **departure minus 24 hours** and create a **one-time systemd timer** and corresponding invocation.
- Reject missing or ambiguous time-zone information and unusable past trigger times with a clear error.
- Preserve the intended absolute instant across local-machine time zones and daylight-saving transitions.
- Provide a direct manual execution path, suitable for development, testing, or user-initiated check-in.
- Treat the scheduled time as an **attempt target**. Do not promise invocation or confirmed check-in at the precise second.

### FR-03: Browser workflow

- Launch headless Chromium through Playwright on the Linux host.
- Navigate to the airline's official check-in/lookup page.
- Populate only fields required by the actual page state, preferring Playwright semantic locators (accessible roles, labels) over positional selectors.
- Execute airline-specific page transitions and verify the final airline response.
- Support only interactions permitted by the airline and stop on blockers that need human action.
- Do not invent or freeze selectors based solely on static README observations. Validate selectors in an actual browser before implementing them.

### FR-04: Result and boarding pass

- Produce one terminal outcome per run: `success`, `failure`, or `manual_action_required`.
- `success` requires positive confirmation from the airline that check-in completed; a completed lookup, clicked button, or downloaded file alone is not sufficient evidence.
- If a directly downloadable boarding pass is presented, save the airline-provided file locally without altering its contents. Treat it as sensitive personal data.
- Boarding-pass availability is separate from check-in success. Do not mark an otherwise verified check-in as failed merely because the site did not expose a direct download.
- Provide sanitized diagnostics for unsupported or inconclusive outcomes. Do not claim success when the final state cannot be established.

### FR-05: Retry and stop conditions

- Retry temporary **safe-to-retry** network or website problems at 30-second intervals for **at most 10 minutes**.
- Before repeating a submission that may already have been processed, re-evaluate the airline's check-in state. Never blindly submit an uncertain transaction again.
- Stop and return `manual_action_required` when encountering a CAPTCHA, identity/document verification, unexpected required payment, human-only decision, or unsupported seat choice.
- Leave existing seat assignments untouched; do not purchase seats, upgrades, or other products.
- Return a sanitized `failure` when a bounded retry window ends or an unrecoverable technical/eligibility error is conclusively identified.

### FR-06: Configuration and logging

- Maintain **one small YAML file per airline** for the entry URL, verified field definitions, and human-readable labels. Verified selectors may be included when needed.
- Keep conditional steps, page transitions, success detection, and error handling in airline-specific Python modules, **not** a YAML workflow engine.
- Keep live passenger data and secrets out of airline YAML files and version control.
- Read booking information from interactive input or a local file with appropriately restrictive permissions.
- Log only non-sensitive operational data to local logs or the systemd journal. No notifications are required.

## 6. Proposed architecture

This is a deliberately small, non-distributed application.

```text
SSH user
   |
   +--> checkin.py (CLI: input validation, manual/scheduled mode)
             |
             +--> one-time systemd timer -> checkin.py at T-24h
             |
             +--> airlines/<airline>.yaml (URL, verified entry fields)
             |
             +--> airlines/<airline>.py (Playwright flow and result parsing)
                         |
                         +--> headless Chromium -> official airline website
             |
             +--> local sanitized logs / journalctl
             +--> restricted local boarding-pass files (when offered)
```

**Proposed repository layout (not yet implemented):**

```text
flight-checkin/
  README.md
  docs/
    PRD.md
  checkin.py
  airlines/
    southwest.yaml
    american.yaml
    southwest.py
    american.py
```

**Component responsibilities:**

| Component | Responsibility | Explicit boundary |
| --- | --- | --- |
| `checkin.py` | CLI entry point, input validation, timing orchestration, dispatch, outcome reporting | No hard-coded airline page navigation |
| Per-airline YAML | Official entry URL, field metadata, verified selectors/labels | No PII, credentials, or generalized workflow scripts |
| Per-airline Python adapter | Page navigation, conditional prompts, confirmations, download detection, classified errors | No scheduling or unrelated airlines' logic |
| Playwright/Chromium | Browser interaction in headless Linux | No CAPTCHA evasion or unsupported purchases |
| systemd | One-time scheduled start, exit-state visibility | No continuously running polling service |
| Local files/journal | Inputs, optional downloads, sanitized operational record | No database, dashboard, or notification backend |

**Design principle:** Make differences between the two airline websites visible in small adapters rather than creating a generic automation framework.

## 7. Quality, privacy, and safety requirements

- **Least disclosure:** Do not write confirmation numbers, dates of birth, passenger names, or boarding-pass contents to logs, traceback text, screenshots, test fixtures in version control, or shell arguments.
- **File permissions:** Use restrictive permissions for files containing booking data or boarding passes; do not store personal reservation details in tracked YAML configurations.
- **Faithful state reporting:** Distinguish site-confirmed check-in from form submission, reservation lookup, and file download. Unknown state must not become success.
- **No unexpected transactions:** Never make purchases or alter selected seats, and never circumvent airline access/security controls.
- **Operational simplicity:** No long-running service beyond the scheduled systemd invocation; no central account service or persistence platform.
- **Airline constraints:** Confirm website compatibility and allowed automation before relying on unattended operation. Airline page changes should fail safely.

## 8. Testing expectations

Testing must establish behavior **without claiming that publicly visible forms prove an end-to-end check-in works**.

| Test level | Required coverage |
| --- | --- |
| Unit | Airline field requirements, optional American date-of-birth logic, input validation and sanitization, time-zone conversion including DST edge cases, T-24h calculation, retry count/window, error-to-outcome mapping |
| Browser-flow integration | Mocked or controlled pages exercising label/role locators, multi-step transitions, positive and negative confirmation, unexpected field, CAPTCHA, payment request, seat prompt, and optional boarding-pass download |
| Scheduler integration | Generate and inspect the one-shot systemd configuration; verify fire time, command/input file permissions, one-run behavior, and journal visibility on a representative Linux host |
| Failure and safety | Timeouts, transient network errors, changed selectors, unconfirmed submissions, duplicate-submission avoidance, retry exhaustion, manual-action blockers, and absence of purchases/seat changes |
| Privacy regression | Assert booking secrets are absent from logs, exception output, fixture repositories, generated configurations, and command-line invocation |
| Real-site acceptance (authorized) | With user-controlled eligible reservations and permitted interactions: first complete a manual Southwest run, then validate American's lookup and conditional steps; only afterward test the one-time scheduled attempt |

**Test data rules:** Use synthetic values and simulated sites for automated CI. Do not store live confirmation numbers, names, dates of birth, or boarding passes in the repository. Real-site tests require explicit eligible reservations and human observation of actual completion states.

**Release acceptance checklist:**

- [ ] Southwest manual flow reaches a site-confirmed completion or correctly reports a blocker.
- [ ] American lookup uses its current required fields and requests date of birth only if the live page requires it.
- [ ] Scheduled invocation is validated at the departure-relative instant using explicit time-zone data.
- [ ] Final status distinguishes verified success, failure, and manual intervention.
- [ ] Safe, bounded retries and uncertain-submission reconciliation are demonstrated.
- [ ] Optional boarding-pass download retains the original offered file.
- [ ] Logs and tracked files contain no real booking/personal data.
- [ ] No purchase, seat change, CAPTCHA bypass, or unsupported human-only step occurs.

## 9. Delivery sequence

1. **Milestone 1: Southwest manual check-in.** Implement the CLI, restricted reservation input, Southwest YAML and Playwright adapter, terminal outcome handling, and sanitized logging. Validate against a permitted live browser session.
2. **Milestone 2: American lookup and check-in.** Add American YAML and adapter; validate the six-letter confirmation-code path, name rules, conditional date-of-birth prompt, and later check-in screens.
3. **Milestone 3: Departure-relative scheduling.** Integrate the one-time systemd timer, time-zone-safe T-24h calculation, bounded retries, and scheduled-run validation.

Do not promote milestone completion solely on the basis of static website inspection or mocked-browser tests.

## 10. Explicit exclusions for the initial version

- SQLite or any other application database.
- Elaborate credential vaults, cloud secret stores, or account-management systems.
- Automatic reservation refresh, itinerary synchronization, or rebooking management.
- Seat optimization, seat purchases, upgrades, or other paid airline transactions.
- Dashboards, web/mobile UIs, and notification services (email, SMS, push).
- A generalized YAML-only workflow engine or airline plugin platform.
- CAPTCHA solving, identity-document automation, security bypass, or guarantees of completely unattended completion.
- Automatic post-check-in boarding-pass recovery or recurring status polling.
- Broad airline support beyond Southwest and American in the first release.

## 11. Risks and assumptions to validate

1. **Airline UI volatility:** Public entry forms may differ from the pages rendered for a real session; selectors, exact validation rules, and subsequent steps are not yet verified.
2. **Automation permission/feasibility:** Website policies or anti-bot systems may limit headless interactions; the product must respect these restrictions and surface manual action.
3. **Scheduling and eligibility:** Airlines may use flight-specific eligibility rules. A timer started at T-24h does not imply the reservation can be checked in at that instant.
4. **American date-of-birth requirement:** Observed on the lookup page but not proven mandatory for every reservation.
5. **Connecting and return legs:** Follow the airline's actual eligible itinerary selection; do not infer one check-in operation per segment.
6. **Boarding-pass format:** Save only a file the website directly provides. Availability and file type are not guaranteed by the current observations.

**Decision rule:** Where observed behavior contradicts this proposal, record the evidence and adjust the relevant airline adapter and requirements. Do not silently infer new required fields or claim the website has been fully validated.
