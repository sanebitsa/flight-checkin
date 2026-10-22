# flight-checkin

A planned, small Python CLI utility that uses headless Playwright to open an airline's official website, enter reservation information, and **attempt check-in 24 hours before scheduled departure**.

> **Status: Planned, not implemented.** Airline form observations were reviewed on October 22, 2026 from publicly accessible page content. They have **not** been validated through a real reservation or completed check-in.

## Product requirements

See **[docs/PRD.md](docs/PRD.md)** for the product's desired outcome, user stories, airline input requirements, functional behavior, architecture, privacy and safety constraints, test expectations, milestones, and explicit exclusions.

## Initial scope

- **Airlines:** Southwest and American Airlines.
- **Runtime:** Python, Playwright headless Chromium, and a Linux host accessed over SSH.
- **Scheduling:** One-time systemd timer for departure minus 24 hours, with a manual CLI run option.
- **Behavior:** Use verified website fields, follow the airline's ordinary check-in flow, confirm the final result, and save a boarding pass if the site directly offers a download.
- **Result:** `success`, `failure`, or `manual_action_required`; sensitive reservation data must not appear in logs.
- **Design:** One small YAML file and one Python Playwright adapter per airline. No generic workflow engine or reservation-management platform.

## Implementation order

1. Validate and build one **manual Southwest** check-in flow.
2. Add **American's** reservation lookup and check-in steps, including a date-of-birth prompt only when actually required.
3. Add one-time **systemd scheduling** after both airline flows are validated in permitted real-browser sessions.

**First-release limits:** No database, notification system, automatic rebooking, seat purchasing/optimization, security bypass, or broad multi-airline framework. See the PRD for the full scope boundary.
