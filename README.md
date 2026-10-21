# flight-checkin

A Python command-line project to automatically check passengers in for Southwest Airlines and American Airlines when online check-in opens.

> **Project status: Planning.** The behavior below is a specification, not functionality already implemented or tested.

## Goal

Start a check-in attempt **24 hours before each flight's scheduled departure time**. Compute this from the departure airport's local time zone, including daylight-saving changes.

The app should complete check-in without routine manual interaction when supported by the airline. It must never claim success until check-in has actually been confirmed. Exact launch timing and successful check-in cannot be guaranteed because of operating-system scheduling, network delays, airline rules, and website availability.

## Requirements

| Area | Planned behavior |
| --- | --- |
| Airlines | Southwest Airlines and American Airlines |
| Departure airports (initial scope) | Dallas Fort Worth (DFW), Dallas Love Field (DAL), Sacramento International (SMF) |
| Interface | Python command-line interface (CLI) |
| Reservation entry | Manual; no email integration |
| Passengers | Individual travelers and multiple travelers sharing a reservation |
| Check-in trigger | Scheduled departure minus 24 hours |
| Scheduling | Linux cron or systemd; short-lived scheduled jobs rather than a continuously running service |
| Check-in | Fully automated when airline workflows permit |
| Failure handling | Retry transient, safe-to-retry errors every 30 seconds for up to 10 minutes |
| Results | Track check-in outcome separately for every passenger, including partial successes |
| Boarding passes | Download available boarding passes locally after successful check-in, with a separate file for each passenger |
| Notifications | None; record outcomes in local logs only |

## Initial airport support

The initial project scope covers flights **departing** from the following airports. All three are targets for development, not confirmed working integrations.

| Airport | IATA airport code | IANA time zone |
| --- | --- | --- |
| Dallas Fort Worth International Airport | `DFW` | `America/Chicago` |
| Dallas Love Field | `DAL` | `America/Chicago` |
| Sacramento International Airport | `SMF` | `America/Los_Angeles` |

**Dallas Love Field code clarification:** The airport code is `DAL`, not `LUV`. `LUV` is associated with Southwest Airlines as its stock ticker and is also a distinct IATA airport code elsewhere. Reservation data and scheduling should use `DAL` for Dallas Love Field.

- The initial version should validate departure airport codes against this list and provide a clear error for unsupported airports.
- The scheduled check-in trigger must use the selected **departure airport's** time zone, regardless of the time zone on the Linux host.
- Handle daylight-saving transitions with named IANA time zones rather than fixed UTC offsets.
- Airports beyond these three can be added later without changing the core check-in scheduling logic.

## Intended workflow

1. **Enter flight details manually** using the CLI. Include the airline, reservation confirmation, passenger details, scheduled departure, and a supported departure airport (`DFW`, `DAL`, or `SMF`).
2. **Calculate check-in time** from scheduled departure minus 24 hours, converting correctly between the departure airport's local time and the Linux host's time.
3. **Schedule a job** using cron or a systemd timer to start at the check-in time.
4. **Attempt check-in** using the appropriate airline-specific workflow. Handle multiple passengers on the same reservation and track each passenger's status.
5. **Retry temporary failures** every 30 seconds for up to 10 minutes after the initial scheduled attempt. Stop immediately after verified success. When a previous submission may have succeeded, verify the state before submitting again.
6. **Save boarding passes** for successfully checked-in passengers when the airline makes them available for retrieval.
7. **Log outcomes locally** with timestamps, passenger-level status, and any errors. Exit after completing the attempt or exhausting eligible retries.

## Failure handling

- Differentiate confirmed success, failed check-in, and manual intervention required.
- Retry only transient problems, such as connection failures or temporary airline-service outages.
- Do not blindly resubmit if the outcome of a previous attempt is unknown.
- Treat CAPTCHA, identity verification, and other required human actions as **manual intervention required**. Do not bypass security mechanisms.
- Preserve each passenger's status when a shared reservation is only partially checked in.
- Once the 10-minute retry window expires, record the final outcome and stop retrying.
- Because notifications are excluded, users must review logs for unsuccessful or incomplete attempts.

## Security and local files

- Treat traveler details, confirmation numbers, and boarding passes as sensitive information.
- Do not log booking credentials, complete confirmation numbers, personal identifiers, tokens, or boarding-pass contents.
- Use appropriately restricted local file permissions for reservations and boarding passes.
- Exclude credentials, reservation records, logs, and downloaded boarding passes from version control.
- Define secure storage, data retention, and cleanup policies before using real reservations.

## Proposed components

- **CLI:** Add, inspect, and manage reservations.
- **Reservation storage:** Persist flight and passenger details securely.
- **Scheduler integration:** Register, update, and remove cron or systemd jobs.
- **Airline adapters:** Isolate Southwest and American check-in behavior.
- **Check-in coordinator:** Manage attempts, passenger outcomes, safe retries, and completion checks.
- **Boarding-pass storage:** Save available passes in configurable local directories.
- **Logging:** Record operational events and error details without exposing sensitive data.

## Planned milestones

- [ ] Design secure reservation storage and CLI commands.
- [ ] Implement departure-airport validation for `DFW`, `DAL`, and `SMF`.
- [ ] Implement time-zone-aware check-in scheduling for `America/Chicago` and `America/Los_Angeles`.
- [ ] Integrate Linux cron or systemd.
- [ ] Research and implement supported airline-specific check-in flows.
- [ ] Implement per-passenger result tracking and bounded 30-second retries.
- [ ] Save available boarding passes locally.
- [ ] Add privacy-conscious local logging.
- [ ] Test scheduling, retry boundaries, partial failures, and manual-intervention cases.
- [ ] Document installation, configuration, and operation.

## Open decisions

- Precise CLI syntax and reservation storage format.
- Whether to standardize on cron, systemd, or support both.
- Airline-specific access methods and any authentication or verification requirements.
- Boarding-pass file formats and directory structure.
- Handling modified departure times, cancellations, connecting flights, and rescheduled check-in jobs.

**Scope note:** Fully unattended check-in and boarding-pass retrieval depend on the airlines' current supported workflows and must be validated individually. No ability to bypass airline security, authorization, or verification is assumed.
