# flight-checkin

A small Python CLI utility that opens an airline's website and attempts to check in a reservation automatically **24 hours before scheduled departure**.

> **Status: Planned.** The automation is not implemented or verified yet.

## Scope

**Keep it simple:** use [Playwright](https://playwright.dev/python/) to automate the same check-in form a passenger would use on the airline website. Support:

- **Airlines:** Southwest Airlines and American Airlines.
- **Input:** airline, confirmation number, passenger last name, and scheduled departure time (with time zone).
- **Timing:** launch at departure minus 24 hours, using a one-time Linux **systemd timer**. Also allow manually running the command for testing or retrying.
- **Action:** open the airline's official check-in page, fill the form, follow the normal check-in steps, and submit when eligible.
- **Output:** log whether check-in was confirmed, failed, or requires a person to finish it. Save a boarding pass locally if it is directly available as part of a successful check-in.
- **Runtime:** Python on a headless Linux server, managed over SSH.

DFW, DAL (Dallas Love Field), and SMF are the initial airports of interest, **not restrictions on where a flight can depart or arrive**. The departure time must include the correct time zone. For connections or round trips, process each scheduled check-in journey independently; follow the airline's actual eligibility rules.

## How it should work

1. The user supplies the airline, confirmation number, last name, and departure date/time.
2. A simple systemd timer starts the Python script at the calculated check-in time. The script can also be started manually.
3. Playwright opens the airline check-in page in headless Chromium.
4. The script fills in the reservation details and uses the airline's normal check-in workflow.
5. It verifies the website's response before reporting success. If available, it saves a directly downloadable boarding pass.
6. It logs the outcome locally and exits.

The app should make a best-effort attempt at the opening of the 24-hour window. Exact execution and success at that instant cannot be guaranteed due to OS scheduling, network latency, and airline availability.

## Failures and limits

- Optionally retry **temporary** errors every 30 seconds for up to 10 minutes, but verify the reservation's state before repeating any submission whose outcome is unknown.
- If check-in requires a CAPTCHA, identity/document verification, account login, payment, or other human-only action, stop and log `manual_action_required`. **Never bypass security checks or make purchases.**
- Do not change existing seat assignments or purchase seats/upgrades. If the flow cannot proceed without a seat decision, record that manual action is needed.
- The two airline sites may have different steps and can change at any time. Build a small, separate Playwright flow for each carrier. Use browser automation only where allowed.
- Confirmation number plus last name might not be sufficient for every reservation. Fully unattended check-in is a goal, not a guarantee.
- No notifications: inspect local logs or `journalctl` for results.

## Minimal implementation

- Python and Playwright for browser navigation and form entry.
- A small CLI to accept reservation details and trigger a check-in run.
- One-time systemd timer/unit for scheduled execution; no constantly running service.
- Local configuration only if needed for a scheduled run. Restrict permissions and never commit real passenger data or booking codes.
- Plain local logs without confirmation numbers or sensitive passenger details.

**Not part of the initial app:** SQLite, encrypted credential vaults, backups, automatic reservation refresh, complex itinerary management, rebooking, seat optimization, passenger-age logic, ongoing boarding-pass polling, dashboards, email, SMS, or push notifications. These should not be built unless a concrete need arises.

## First milestone

Create and test **one manually triggered check-in flow for one airline** using a testable/eligible reservation, then add the second airline. Once the website interactions work reliably, add the simple systemd timer so the same command runs at the 24-hour mark.

Actual airline check-in behavior and permission to automate it must be validated before treating the app as dependable.
