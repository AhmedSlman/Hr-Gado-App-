# Active v2 migration — completed

Contract: `handoff.md` (all eight active routes).

- Migrated salary summary, own report list/detail, daily report creation, manager report list/detail/editing, and home to v2.
- Confirmation retains `/employee/confirm-report/{id}` as specified.
- Driver creation/editing uses separate installation and supply counts. All device and meter inputs are numeric text fields; overtime remains a list.
- Writes send numeric JSON values. Manager editing sends only changed fields, preserving omitted and historical nullable values.
- Own reports are available to both roles and follow job type. Salary manager behavior takes role precedence. Manager review metrics follow the report owner; review actions are restricted to manager UI.
- Report actions use the visible cubit, reload detail/list after changes, and notify active salary consumers.
- Home respects optional salary data and server amounts. Errors offer retry.

Validation: 24 focused tests passed; analyzer has zero errors and 12 existing warnings. Authenticated live backend verification remains pending because test credentials were not supplied. The unrelated counter-template test remains a known baseline failure.

Release build details are recorded in `release-notes.md`.
