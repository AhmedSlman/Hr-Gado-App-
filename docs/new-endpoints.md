# Flutter API updates: salary summary and employee reports

Reviewed on 8 October 2026, Cairo time, for commits from 1 October through the review date. Source range: `afffc3b` to `1b7d864` on refreshed `origin/main`. Git records commit dates, not push dates.

This handoff covers only the two reads used by the application: salary summary and the employee report list. Paths below are relative to the backend host. Both use the existing employee authentication and successful response envelope: `key`, `msg`, `data`.

## Endpoint migration

| Current endpoint | Updated endpoint | Flutter change |
| --- | --- | --- |
| `GET /api/employee/my-salary-summary` | `GET /api/employee/v2/my-salary-summary` | Support split driver metrics and the manager summary fields/types. |
| `GET /api/employee/reports` | `GET /api/employee/v2/reports` | Support installation and supply counts for drivers. |

The legacy report list keeps its single device count. The legacy salary summary keeps its field structure but inherits the shared payroll calculation fixes described below. The new v2 fields require switching these requests to their v2 paths.

## Salary summary: drivers

Change: for drivers, each `data.salary_history[].metrics` object replaces `devices` with `installation_devices` and `supply_devices`. Summary totals retain their existing meaning.

```json
{
  "key": "success",
  "msg": "تم بنجاح",
  "data": {
    "salary_receipt_date": "25 أكتوبر",
    "daily_salary": 400,
    "base_salary": 12000,
    "net_monthly_salary": 575,
    "total_deductions": 0,
    "total_bonuses": 175,
    "insurance_deduction": 0,
    "salary_history": [
      {
        "report_id": 501,
        "date": "الخميس 1 أكتوبر",
        "salary_text": "575 حافز (175)",
        "metrics": {
          "overtime_hours": 2,
          "installation_devices": 3,
          "supply_devices": 1
        },
        "has_report": true
      }
    ]
  }
}
```

For legacy driver reports, v2 uses the old device count as `installation_devices` and defaults `supply_devices` to zero. Non-driver metrics remain unchanged. In particular, technicians still use `metrics.devices` and `metrics.meters`.

Summary amounts (`daily_salary`, `base_salary`, `net_monthly_salary`, `total_deductions`, `total_bonuses`, `insurance_deduction`) retain the existing whole-number rounding for non-managers. `salary_text` is display text, not a numeric field. `report_id` is optional and omitted when absent. The embedded `salary_history` belongs to this summary response.

## Salary summary: managers

Managers receive their configured monthly base across all calendar days, independently of attendance, absence, overtime and report metrics. Allowances and manual deductions affect pay; advances, installments and insurance affect monthly payable salary. The base is divided by the number of days in the month, with remaining cents distributed across the first days.

For managers, `net_monthly_salary` includes the full monthly base and allowances, less manual deductions, advances, installments, and insurance. `total_bonuses` is zero; `total_allowances` is new. `daily_salary` is a two-decimal string because some calendar months need a cent distributed between days. The response includes one salary-history item per calendar day; one is shown below for brevity.

```json
{
  "key": "success",
  "msg": "تم بنجاح",
  "data": {
    "salary_receipt_date": "25 أكتوبر",
    "daily_salary": "387.10",
    "base_salary": 12000,
    "net_monthly_salary": 11300,
    "total_deductions": 720,
    "total_bonuses": 0,
    "total_allowances": "20.00",
    "insurance_deduction": 110,
    "salary_history": [
      {
        "date": "الخميس 1 أكتوبر",
        "salary_text": "397.1",
        "metrics": [],
        "has_report": false
      }
    ]
  }
}
```

This example includes a 600.00 normal advance, a 10.00 manual deduction, a 20.00 allowance, and 110.00 insurance. The displayed history array is shortened; the actual response includes all 31 days.
The manager summary covers the full current month, including future calendar days. `daily_salary` is the first day's base rate, so some later days can differ by one cent. `daily_salary` and `total_allowances` are two-decimal strings; the other top-level amounts retain whole-number rounding. Each embedded history entry has empty `metrics`, `has_report: false`, and no `report_id`.

The summary accepts no month/year/date selection in its controller; it calculates the current month. Legacy manager summary still reports `daily_salary` using `salary / 30`; use the v2 summary for the updated manager presentation.

## Payroll changes affecting salary summary values

These changes also affect the existing `GET /api/employee/my-salary-summary`, even though its field names remain unchanged:

- Manual deductions are included once. The monthly summary no longer subtracts them a second time. They also apply on holidays, Fridays and approved leave; net pay can be negative.
- Approved late-arrival minutes accumulate separately from approved early-departure minutes. Only attendance penalties are capped at the daily base.
- Long-term advances apply only within their scheduled repayment months, with the final installment absorbing the cent remainder.
- Confirmed driver reports with split device counts use installation and supply prices separately. Legacy unsplit reports retain the original device-price calculation.
- Report saves/confirmation and attendance-request saves recalculate existing payroll rows. Refresh the summary after relevant changes.
- Manager pay follows the calendar-month policy above. The v2 summary includes all calendar days even without stored salary rows.

For non-managers, `total_bonuses` and `net_monthly_salary` still include confirmed report incentives and overtime through the stored payroll totals. This summary does not introduce separate overtime or allowance fields for non-managers. For managers, `total_bonuses` is zero and `total_allowances` is separate.

## Employee report list

Change: each driver item in the report list returns the two device counts instead of `num_of_devices`.

```json
{
  "key": "success",
  "msg": "تم بنجاح",
  "data": [
    {
      "id": 501,
      "date": "الخميس, 1 أكتوبر",
      "overtime_hours": 2,
      "installation_devices": 3,
      "supply_devices": 1
    }
  ]
}
```
### Filters and response behavior

- Optional `month`: integer 1–12; optional `year`: integer 2020–2030. Both default to the current month/year.
- Only the authenticated employee's confirmed reports are returned, newest date first. `status` accepts `confirmed`, `unconfirmed`, or `all` for validation, but does not change the confirmed-only selection.
- `data` is an array without pagination metadata. An empty list is `[]`.
- Driver items replace `num_of_devices` with `installation_devices` and `supply_devices`; `overtime_hours` remains. Old unsplit reports fall back to their legacy count as installations and zero supplies.
- Other jobs retain their fields: sales has `sold_devices`, `bought_devices`, `commercial_devices`; technician has `num_of_devices`, `num_of_meters`; other has `overtime_hours`.
- The list includes `id` and an Arabic display `date`, but no report `content`, employee object, or job-type discriminator. Use the authenticated employee's known job type to select the model/UI.
- Invalid report filters return HTTP 400 with `key: failure`, the first validation error in `msg`, and `data: []`. Employee authentication failures return HTTP 401.

## Flutter implementation checks

1. Switch these two requests to their v2 paths together.
2. Update driver report list and summary metrics to use both device counts; keep technician device fields.
3. Parse summary money fields from JSON numbers or numeric strings. Manager `daily_salary` and `total_allowances` are strings; non-manager `daily_salary` is numeric.
4. Treat `salary_text` and report dates as display strings. Keep `report_id` optional and allow empty metrics/history/report lists.
5. Verify old/new driver reports, non-driver report fields, manager full-month summaries, filter errors, and changed deduction/installment totals against the deployed backend.

Relevant commits: `821745b` (shared payroll corrections), `cc5a160` (v2 split driver reports and summary), and `440c06e` (v2 manager salary summary policy). No further field changes to these two reads were found in the later 7–8 October commits.

Verification is based on routes, controllers, requests, resources, models and shared services. Live HTTP behavior, deployed migrations and payroll reconciliation remain unverified. See `PAYROLL_ROLLOUT.md` for backend rollout requirements. `/docs` is Git-ignored, so this document is available locally.

