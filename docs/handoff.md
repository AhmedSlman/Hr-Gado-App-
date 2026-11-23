# Flutter handoff: active v2 endpoints

Reviewed on 8 October 2026, Cairo time, for commits from 1 October through the review date. Source range: `afffc3b` to `1b7d864` on refreshed `origin/main`, with route availability rechecked against the current working tree. Git records commit dates, not push dates.

This handoff covers all eight active v2 routes: home, employee reports, manager report review/editing, and salary summary. Other salary endpoints are excluded as requested and are currently commented out in the local route file. Paths below are relative to the backend host. All routes use employee-token authentication and successful response envelope: `key`, `msg`, `data`.

## Employee and manager usage

| Endpoint | Employees (`role = 0`) | Managers (`role = 1`) |
| --- | --- | --- |
| `GET /api/employee/v2/my-salary-summary` | Own salary summary; metrics depend on job type (driver, technician, sales, other). | Own manager salary summary; calendar-month pay, separate `total_allowances`, no report metrics. |
| `GET /api/employee/v2/reports` | Own confirmed reports for the selected month/year. | Own confirmed reports for the selected month/year; this does not list subordinates' reports. |
| `GET /api/employee/v2/reports/{id}` | Own report detail. | Own report detail. |
| `POST /api/employee/v2/daily-report` | Submit own daily report; awaits confirmation. | Submit own daily report; automatically confirmed. |
| `GET /api/employee/v2/employees-reports` | Not an employee UI action. | Today's unconfirmed reports from assigned employees. |
| `GET /api/employee/v2/employees-reports/{id}` | Not an employee UI action. | Assigned employee's report detail. |
| `PUT /api/employee/v2/daily-reports/{id}` | Not an employee UI action. | Edit an assigned employee's report. |
| `GET /api/employee/v2/home-screen` | Own home data and stored daily salary if available. | Own home data with manager daily salary even without a stored row. |

All eight routes currently use employee-token authentication without manager-only `role:1` middleware. Manager report controllers scope access through the authenticated account's assigned employees; expose those actions only in the manager UI. Backend should review the middleware consistency. The `/employee/` URL prefix also includes manager accounts. Login exposes role labels `Employee` / `Manager` and job type values `driver`, `technician`, `sales`, `other`.

For salary summary, manager behavior takes precedence over job type. A manager whose job is driver still receives the manager summary response. Own report responses follow the user's job type; manager review responses follow the report owner's job type.

## Endpoint migration

| Current endpoint | Updated endpoint | Flutter change |
| --- | --- | --- |
| `GET /api/employee/my-salary-summary` | `GET /api/employee/v2/my-salary-summary` | Support split driver metrics and the manager summary fields/types. |
| `GET /api/employee/reports` | `GET /api/employee/v2/reports` | Support installation and supply counts for drivers. |

The legacy report list keeps its single device count. The legacy salary summary keeps its field structure but inherits the shared payroll calculation fixes described below. The new v2 fields require switching these requests to their v2 paths.

## `GET /api/employee/v2/my-salary-summary`

### Request and validation

```http
GET /api/employee/v2/my-salary-summary
Authorization: Bearer <employee-token>
Accept: application/json
```

No request body or required query parameters. This action uses Laravel's plain `Request`, with **no new request validation rules**. `month`, `year`, `date`, and `status` do not select a period and are ignored by this action. It always calculates the current month. Authentication is required for employees and managers; the authenticated role/job determines the response variant.

### Response contract and changes

HTTP 200 with `key: "success"`, `msg`, and a `data` object:

| Field in `data` | Type | Behavior/change |
| --- | --- | --- |
| `salary_receipt_date` | string | Existing Arabic display date. |
| `daily_salary` | number for non-managers; decimal string for managers | Non-managers retain whole-number rounding; managers use calendar-month base allocation. |
| `base_salary` | number | Configured monthly base, rounded to a whole number. |
| `net_monthly_salary` | number | Monthly payable amount, rounded; shared payroll corrections can change its value. |
| `total_deductions` | number | Rounded total including applicable advances, installments and insurance. |
| `total_bonuses` | number | Rounded combined bonuses for non-managers; zero for managers. |
| `insurance_deduction` | number | Rounded insurance deduction, defaults to zero. |
| `total_allowances` | decimal string | New for managers only; omitted for non-managers. |
| `salary_history` | array | Embedded history items described below; managers include every calendar day. |

Each `salary_history` item has `date` (Arabic display string), `salary_text` (display string), `has_report` (boolean), `metrics`, and optional `report_id` (integer, omitted when null).

| Employee job/role | `metrics` fields | Change |
| --- | --- | --- |
| Driver, non-manager | `installation_devices`, `supply_devices`, `overtime_hours` | Replaces legacy `devices` with two counts. |
| Technician, non-manager | `devices`, `meters` | Unchanged. |
| Sales, non-manager | `sold_devices`, `bought_devices`, `commercial_devices` | Unchanged. |
| Other, non-manager | `overtime_hours` | Unchanged. |
| Manager | Empty array `[]` | No report metrics; `has_report` is false and `report_id` is omitted. |

Summary metrics default to zero when unavailable. Populated decimal metrics may follow database numeric-string serialization; Flutter should accept numbers or numeric strings. The manager response takes precedence over job-specific metrics.

### Driver employee success response

Illustrative values; the embedded history is shortened.

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

### Manager success response

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

### Payroll changes affecting this endpoint

These changes also affect the existing `GET /api/employee/my-salary-summary`, even though its field names remain unchanged:

- Manual deductions are included once. The monthly summary no longer subtracts them a second time. They also apply on holidays, Fridays and approved leave; net pay can be negative.
- Approved late-arrival minutes accumulate separately from approved early-departure minutes. Only attendance penalties are capped at the daily base.
- Long-term advances apply only within their scheduled repayment months, with the final installment absorbing the cent remainder.
- Confirmed driver reports with split device counts use installation and supply prices separately. Legacy unsplit reports retain the original device-price calculation.
- Report saves/confirmation and attendance-request saves recalculate existing payroll rows. Refresh the summary after relevant changes.
- Manager pay follows the calendar-month policy above. The v2 summary includes all calendar days even without stored salary rows.

For non-managers, `total_bonuses` and `net_monthly_salary` still include confirmed report incentives and overtime through the stored payroll totals. This summary does not introduce separate overtime or allowance fields for non-managers. For managers, `total_bonuses` is zero and `total_allowances` is separate.

### Error responses

An absent/invalid employee token returns HTTP 401 using the existing envelope:

```json
{"key":"unauthenticated","msg":"<localized authentication message>","data":[]}
```

There is no endpoint-specific HTTP 400 query-validation response for salary summary because no query rules are defined. Backend exceptions use the current global handler: HTTP 500, `key: "exception"`, `msg`, and `data: []` when debug is disabled. Handle this as an error rather than an empty successful salary.

## `GET /api/employee/v2/reports`

### Request and validation

```http
GET /api/employee/v2/reports?month=10&year=2026
Authorization: Bearer <employee-token>
Accept: application/json
```

No request body. Query validation is inherited from `ReportFilterRequest` and is **unchanged from the legacy employee report list**:

| Query field | Required? | Exact validation rule | Default/meaning |
| --- | --- | --- | --- |
| `month` | No | `sometimes\|integer\|between:1,12` | Current month if omitted. |
| `year` | No | `sometimes\|integer\|min:2020\|max:2030` | Current year if omitted. |
| `status` | No | `sometimes\|in:confirmed,unconfirmed,all` | Validated only; the controller always returns confirmed reports. |

Omit unused filters; these rules do not allow null or empty values when supplied. The new `installation_devices` and `supply_devices` are **response fields for this GET**, not query parameters or required request fields.

### Response contract and changes

HTTP 200 with `key: "success"`, `msg`, and `data` as an array. All items include `id` (integer) and `date` (Arabic display string). Remaining fields depend on the authenticated employee's job:

| Job | Additional item fields | Change |
| --- | --- | --- |
| Driver | `installation_devices`, `supply_devices`, `overtime_hours` | Removes `num_of_devices`, adds the two counts. |
| Technician | `num_of_devices`, `num_of_meters` | Unchanged. |
| Sales | `sold_devices`, `bought_devices`, `commercial_devices` | Unchanged. |
| Other | `overtime_hours` | Unchanged. |

Device counts are integer counts when populated; hours/meters are numeric values. The legacy report model does not cast these metric attributes, so historical nullable fields can remain null and decimal values can follow database serialization. Flutter should accept numeric strings where needed. V2 driver count fallback ensures zero when no count is available.

### Driver employee success response

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
### Selection and compatibility behavior

- Optional `month`: integer 1–12; optional `year`: integer 2020–2030. Both default to the current month/year.
- Only the authenticated employee's confirmed reports are returned, newest date first. `status` accepts `confirmed`, `unconfirmed`, or `all` for validation, but does not change the confirmed-only selection.
- `data` is an array without pagination metadata. An empty list is `[]`.
- Driver items replace `num_of_devices` with `installation_devices` and `supply_devices`; `overtime_hours` remains. Old unsplit reports fall back to their legacy count as installations and zero supplies.
- Other jobs retain their fields: sales has `sold_devices`, `bought_devices`, `commercial_devices`; technician has `num_of_devices`, `num_of_meters`; other has `overtime_hours`.
- The list includes `id` and an Arabic display `date`, but no report `content`, employee object, or job-type discriminator. Use the authenticated employee's known job type to select the model/UI.
- Invalid report filters return HTTP 400 with `key: failure`, the first validation error in `msg`, and `data: []`. Employee authentication failures return HTTP 401.

### Error and empty responses

Invalid month example (`month=13`), HTTP 400:

```json
{"key":"failure","msg":"الشهر يجب أن يكون بين 1 و 12","data":[]}
```

No matching confirmed reports, HTTP 200:

```json
{"key":"success","msg":"تم بنجاح","data":[]}
```

An absent/invalid token returns the same HTTP 401 envelope documented for salary summary. Unexpected exceptions use HTTP 500 with `key: "exception"` under the current global handler.

## `GET /api/employee/v2/reports/{id}`

Audience: employees and managers viewing **their own** report.

### Request and validation

```http
GET /api/employee/v2/reports/501
Authorization: Bearer <employee-token>
Accept: application/json
```

No body or query validation rules. `{id}` identifies a report owned by the authenticated account. There is no current-month or confirmation restriction on this detail lookup. An inaccessible/missing ID reaches the global exception handler (currently HTTP 500, `key: exception`, rather than 404).

### Response and changes

HTTP 200. `data` contains `id`, Arabic display `date`, string `content`, and job-specific fields from the report-list table. Drivers replace `num_of_devices` with both split counts. Other job fields are unchanged. No employee object or confirmation flag is included.

```json
{"key":"success","msg":"تم بنجاح","data":{"id":501,"date":"الخميس, 1 أكتوبر","content":"تم تركيب ثلاثة أجهزة وتوريد جهاز واحد","overtime_hours":2,"installation_devices":3,"supply_devices":1}}
```

## `POST /api/employee/v2/daily-report`

Audience: employees and managers submitting **their own** report for today. Employees' reports are unconfirmed; managers' own reports are automatically confirmed.

### Request and validation

```http
POST /api/employee/v2/daily-report
Authorization: Bearer <employee-token>
Accept: application/json
Content-Type: application/json
```

Driver request example:

```json
{"content":"تم تركيب ثلاثة أجهزة وتوريد جهاز واحد","installation_devices":3,"supply_devices":1,"overtime_hours":2}
```

| Job | Field | Exact rule |
| --- | --- | --- |
| All | `content` | `required\|string` |
| Driver | `installation_devices`, `supply_devices` | Each `required\|integer\|min:0` |
| Driver / Other | `overtime_hours` | `required\|numeric\|min:0` |
| Sales | `sold_devices`, `bought_devices`, `commercial_devices` | Each `required\|integer\|min:0` |
| Technician | `num_of_devices` | `required\|integer\|min:0` |
| Technician | `num_of_meters` | `required\|numeric\|min:0` |

The driver request replaces legacy `num_of_devices` with two required counts. Other jobs retain their request rules. Submit zero explicitly when there is no activity. The server assigns today's date and authenticated employee ID; neither is a client-selectable field. Unvalidated fields are not passed to report creation.

### Response and changes

The response stays a success message with no report object, HTTP 200:

```json
{"key":"success","msg":"تم تقديم التقرير اليومي بنجاح.","data":[]}
```

Missing driver installation count, HTTP 400:

```json
{"key":"failure","msg":"عدد أجهزة التركيب مطلوب","data":[]}
```

Already submitted today, HTTP 400:

```json
{"key":"failure","msg":"لقد قمت بتقديم التقرير اليومي بالفعل.","data":[]}
```

New split reports also store the sum in legacy `num_of_devices`. Refresh report/summary data after successful writes.

## `GET /api/employee/v2/employees-reports`

Audience: **managers reviewing assigned employees**, distinct from the manager's own `reports` list.

### Request and validation

```http
GET /api/employee/v2/employees-reports
Authorization: Bearer <manager-employee-token>
Accept: application/json
```

No body. Optional query rules are `month: sometimes|integer|between:1,12`, `year: sometimes|integer|min:2020|max:2030`, `status: sometimes|in:confirmed,unconfirmed,all`. These inherited rules validate inputs, but **none changes the selection**: only today's unconfirmed reports for assigned employees are returned, newest creation first. Omit these filters in this UI. Invalid values return HTTP 400, first message, `key: failure`, `data: []`.

### Response and changes

HTTP 200, `data` array without pagination. Each item contains `id`, Arabic display `date`, `employee_id`, `name`, and the report owner's job-specific metrics. Driver items replace `num_of_devices` with split counts. No `content` or employee object is included. Empty results return `data: []`.

```json
{"key":"success","msg":"تم بنجاح","data":[{"id":501,"date":"الخميس, 1 أكتوبر","employee_id":38,"name":"Ahmed Mohamed Marey","overtime_hours":2,"installation_devices":3,"supply_devices":1}]}
```

## `GET /api/employee/v2/employees-reports/{id}`

Audience: **managers viewing an assigned employee's report**.

### Request and validation

```http
GET /api/employee/v2/employees-reports/501
Authorization: Bearer <manager-employee-token>
Accept: application/json
```

No body or query validation. The controller requires the report owner to be an assigned employee; detail lookup has no current-date/confirmation restriction. Missing or inaccessible reports currently produce HTTP 500 `key: exception` through the global handler.

### Response and changes

HTTP 200. `data` contains `id`, Arabic display `date`, `content`, report-owner job metrics, and `employee: {id, name, image, job}`. `job` is the display title, not a job-type enum. Driver metrics use the two counts; other jobs retain list-table fields. No confirmation flag is included.

```json
{"key":"success","msg":"تم بنجاح","data":{"id":501,"date":"الخميس, 1 أكتوبر","content":"تم تركيب ثلاثة أجهزة وتوريد جهاز واحد","overtime_hours":2,"installation_devices":3,"supply_devices":1,"employee":{"id":38,"name":"Ahmed Mohamed Marey","image":"https://example.com/defaults/profile.webp","job":"سائق"}}}
```

## `PUT /api/employee/v2/daily-reports/{id}`

Audience: **managers editing an assigned employee's report**. Validation follows the report owner's job, not the manager's job.

### Request and validation

```http
PUT /api/employee/v2/daily-reports/501
Authorization: Bearer <manager-employee-token>
Accept: application/json
Content-Type: application/json
```

Partial driver edit:

```json
{"installation_devices":4,"supply_devices":2,"overtime_hours":1.5,"content":"تم تحديث التقرير"}
```

| Job | Field | Exact rule |
| --- | --- | --- |
| All | `content` | `sometimes\|string` |
| Driver | `installation_devices`, `supply_devices` | Each `sometimes\|integer\|min:0` |
| Driver / Other | `overtime_hours` | `sometimes\|numeric\|min:0` |
| Sales | `sold_devices`, `bought_devices`, `commercial_devices` | Each `sometimes\|integer\|min:0` |
| Technician | `num_of_devices` | `sometimes\|integer\|min:0` |
| Technician | `num_of_meters` | `sometimes\|numeric\|min:0` |

All fields are optional; supplied values must satisfy the rule and cannot be null. Driver `num_of_devices` is replaced by split fields. `date`, `employee_id`, and `is_confirmed` are not editable through this action. The controller scopes the report to assigned employees; no current-date/confirmation restriction is applied.

### Response and changes

HTTP 200, unchanged message-only response:

```json
{"key":"success","msg":"تم تعديل التقرير بنجاح","data":[]}
```

Invalid values return HTTP 400 `key: failure` with the first validation message. Missing/inaccessible IDs reach the global HTTP 500 exception path; the inherited validator can also fail while loading a nonexistent report. Do not treat this as successful editing.

Omitted fields preserve stored values. On a partial split edit of an old report, the old total initializes installation count and supply initializes to zero before applying the change. The sum remains available to legacy readers. **Legacy edits using `num_of_devices` clear the split columns**, so use v2 for split report edits.

Confirmation remains `POST /api/employee/confirm-report/{id}` (legacy manager route). There is no v2 confirmation route. Editing does not confirm a report. Confirmed report edits/confirmation can recalculate existing salary rows; refresh salary summary afterward.

## `GET /api/employee/v2/home-screen`

Audience: **employees and managers viewing their own home screen**.

### Request and validation

```http
GET /api/employee/v2/home-screen
Authorization: Bearer <employee-token>
Accept: application/json
```

No body, required query parameters, or new validation rules. Query dates do not select a different day. The action loads today's home data.

### Response and changes

HTTP 200, `data` object with existing fields: Arabic `today`, boolean `is_checked_in` / `is_checked_out`, `shift`, `today_meetings`, `articles`, and optional `daily_salary`.

- Employees retain legacy home behavior: `daily_salary` is included only when a stored daily row is available.
- Managers receive today's manager salary even without attendance or a stored row. Its base follows calendar-month allocation; bonus contains allowances only, deduction contains manual deductions, and net includes both. All four home money fields retain whole-number rounding.
- `shift` includes `from`, `to`, `hours`, `last_time_before_deduction`, `attendance_time`, `departure_time`. Meetings contain `id`, `title`, `time`, `link`. Articles contain `id`, `title`, `content`, `about_employee`, and conditional `employee: {name, image, job_title}`.

Manager example with no attendance, a 12,000 monthly salary, and no adjustments; lists are empty in this example:

```json
{"key":"success","msg":"تم بنجاح","data":{"today":"الخميس 08 أكتوبر","is_checked_in":false,"is_checked_out":false,"shift":{"from":"09:00 ص","to":"05:00 م","hours":8,"last_time_before_deduction":"09:30 ص","attendance_time":"","departure_time":""},"today_meetings":[],"articles":[],"daily_salary":{"base_daily_salary":387,"bonus":0,"deduction":0,"net_amount":387}}}
```

For an employee without a daily row, the same home structure omits `daily_salary` entirely. The home resource assumes a shift is assigned; missing shift data can reach the global exception handler. Authentication failures use HTTP 401; unexpected exceptions use HTTP 500 `key: exception`.

## Flutter implementation checks

1. Migrate the eight documented actions to their v2 paths, keeping report confirmation on its existing legacy route.
2. Update driver report creation, editing, lists, details and summary metrics to use both device counts; keep technician device fields. Manager review fields follow the report owner's job.
3. Parse summary money fields from JSON numbers or numeric strings. Manager `daily_salary` and `total_allowances` are strings; non-manager `daily_salary` is numeric.
4. Treat `salary_text` and report dates as display strings. Keep `report_id` optional and allow empty metrics/history/report lists.
5. Verify old/new driver reports, creation, partial editing, confirmation, own versus assigned-employee access, non-driver fields, manager home data, manager full-month summaries, filter errors, and changed deduction/installment totals against the deployed backend.

Relevant commits: `821745b` (shared payroll corrections), `cc5a160` (v2 split driver report reads/writes and summary), and `440c06e` (v2 home and manager salary summary policy). No further mobile response field changes were found in the later 7–8 October commits.

Verification is based on routes, controllers, requests, resources, models and shared services. Live HTTP behavior, deployed migrations and payroll reconciliation remain unverified. See `PAYROLL_ROLLOUT.md` for backend rollout requirements. `/docs` is Git-ignored, so this document is available locally.


