# flight-checkin

A small Python CLI utility that uses Playwright to open an airline's website, fill out the online check-in form, and attempt check-in **24 hours before scheduled departure**.

> **Status: Planned, not implemented.** The airline entry-form details below were reviewed on October 22, 2026. Airline sites can change. The forms were inspected using publicly accessible page content, **not** by submitting a real reservation or completing check-in.

## Supported websites and entry fields

### Southwest Airlines

**Entry URL:** https://www.southwest.com/air/check-in/

The public check-in form explicitly marks these three fields **required**:

| Field displayed | CLI data | Notes |
| --- | --- | --- |
| Confirmation # | `confirmation_number` | Reservation confirmation number |
| First Name | `first_name` | Passenger's first name as booked |
| Last Name | `last_name` | Passenger's last name as booked |

**Entry action:** `Check in`.

**Source:** [Southwest check-in form](https://www.southwest.com/air/check-in/index.html?validate=true).

### American Airlines

**Entry URL:** https://www.aa.com/reservation/flightCheckInViewReservationsAccess.do

This URL leads to American's **Find your trip** / reservation lookup flow. Publicly available page content shows:

| Field or option displayed | CLI data | Notes |
| --- | --- | --- |
| Last name | `last_name` | American instructs passengers to omit special characters such as hyphens; spaces in multiple last names are allowed |
| Confirmation code | `confirmation_number` | Main lookup method for this app; American describes a six-letter record locator |
| Date of birth (for your security) | `date_of_birth` | Security field shown on the page. Whether it is required for every reservation **has not been verified**; prompt for it only if needed |
| Ticket number | Not used in initial version | Alternative lookup identifier shown on the page; not required when using the confirmation-code path |

**Entry action:** `Find your trip`, followed by check-in steps on subsequent pages. **First name is not shown as an entry field** on the publicly accessible initial lookup content.

The direct American Airlines URL can return a JavaScript/session error to noninteractive page readers. These labels are corroborated by [American's current Find your trip page](https://www.aa.com/manage-reservation/viewres/ui/app/). Exact visible input state, required-field validation, page selectors, and subsequent check-in steps must be tested in a real browser.

**Sources:** [American check-in URL](https://www.aa.com/reservation/flightCheckInViewReservationsAccess.do) and [American reservation lookup](https://www.aa.com/manage-reservation/viewres/ui/app/).

### Shared input versus website fields

The CLI needs **airline**, **confirmation number**, **last name**, and **scheduled departure date/time with a time zone**.

- For **Southwest**, also require `first_name`.
- For **American**, collect `date_of_birth` only when its lookup/security step actually requires it; do not assume it is universally mandatory.
- **Departure date/time and time zone are scheduler inputs**, not fields verified on either airline's initial web form.
- Additional prompts after reservation lookup (such as passenger selection or document checks) have **not** been verified. Handle only those actually encountered; never assume an unattended check-in always succeeds.

## Should each airline have its own YAML file?

**Yes: use one small YAML configuration file per airline**, with the website URL, input-field definitions, and human-readable labels. This keeps airline differences explicit and avoids a large generic configuration system.

Proposed lightweight layout (not created yet):

```text
flight-checkin/
  README.md
  checkin.py                 # Small shared CLI and scheduling entry point
  airlines/
    southwest.yaml           # Southwest URL and entry-form field mapping
    american.yaml            # American URL and entry-form field mapping
    southwest.py             # Southwest-specific Playwright steps
    american.py              # American-specific Playwright steps
```

The YAML files should describe **what** inputs are needed, not contain live passenger details, confirmation numbers, passwords, or birth dates. Store only verified field labels and selectors; **do not invent CSS selectors** in advance. Playwright logic, page transitions, error recognition, and success verification belong in the small airline-specific Python modules. Prefer robust semantic locators (labels, accessible roles) over brittle positional selectors.

Avoid a YAML-only workflow engine: the two sites have different multi-step behavior, and trying to encode that behavior in configuration would make this small application unnecessarily complex.

## Minimal behavior

1. Supply the airline and reservation details through the CLI.
2. For a scheduled job, supply the **scheduled departure timestamp with an explicit time zone**. Schedule a one-time **systemd timer** for exactly 24 hours before departure. Allow a direct manual run for development/testing.
3. Launch headless Chromium with Playwright and navigate to the corresponding official airline check-in page.
4. Fill the **verified initial entry fields** described above, then follow the site's ordinary check-in flow.
5. Check the airline's final response to determine whether check-in actually succeeded. If a boarding pass is directly available for download, save it locally.
6. Log `success`, `failure`, or `manual_action_required` without exposing booking codes or personal information, then exit.

Airports **DFW**, **DAL** (Dallas Love Field), and **SMF** are the initial airports of interest, **not a hard restriction**. Time zones must be applied correctly to scheduling. For connecting or round-trip reservations, use the airline's actual itinerary eligibility rather than assuming every segment is checked in separately.

The script targets a headless Linux server accessed through SSH. The timer attempts to start at the 24-hour mark; successful check-in at that exact instant is not guaranteed because of scheduling delays, network conditions, and airline availability.

## Failures and safety

- Retry *temporary, safe-to-retry* problems every **30 seconds for up to 10 minutes**. Before retrying a submission with an unknown outcome, check whether it already succeeded.
- On a CAPTCHA, identity/document verification, unexpected required payment, or other human-only step, stop and log `manual_action_required`. Do not bypass airline security controls or make purchases.
- Keep existing seats unchanged. Do not buy seats or upgrades. If the site requires an unsupported seat decision, report manual intervention.
- Check-ins must use permitted website interactions; browser automation feasibility and applicable airline restrictions need validation.
- No notifications; read local logs or `journalctl`.
- Treat confirmation numbers, names, and dates of birth as sensitive. Never commit actual reservations, and avoid putting them in command-line arguments or logs where other local users could inspect them. Prefer restricted input files or interactive input for secrets in the initial version.

## First milestone

Build and test **one manual check-in run for Southwest** using its three clearly required entry fields, then add the American reservation lookup flow, including its potential date-of-birth prompt. Once both are validated with real browser sessions and permitted interactions, wire up the one-time systemd timer.

**Not in this initial version:** SQLite, elaborate credential vaults, automatic reservation refresh, rebooking management, detailed seat optimization, dashboards, or notification services.
