# Firebase and manager history update

Android Firebase project: `gado-hr`; package: `com.gadohr.app`.
`lib/firebase_options.dart` was derived from the supplied Android JSON. No Firebase
project or app was created remotely, and no server credential is bundled.

## Implemented

- Firebase initialization before app startup, bounded startup waiting, background
  entry point, foreground local notifications, and the `hr_notifications` channel.
- Persistent random installation UUID; authenticated token registration and token
  refresh; shared-topic subscription; bounded retries and connectivity recovery.
  Subscription retries reuse a successful backend registration.
- Serialized registration/removal, session generations, recipient checks, and
  bounded separate banner/tap deduplication caches. Logout removes this installation,
  unsubscribes, deletes its Firebase token, and clears displayed local notifications.
  Logout also sends `device_id` to the existing logout endpoint. A 401 expires the
  employee session rather than repeatedly registering it.
- Firebase and local taps use one dispatcher. Initial taps wait for authenticated
  Home. Leave/advance manager requests open existing details; attendance requests
  use the existing manager request list because no attendance-details route exists.
  Announcements display a dialog and never mark a broadcast ID as read.
- Unread inbox refresh on Home, resume and foreground messages; title/payload
  parsing, mark-read, mark-all-read, single/all deletion. Late inbox responses from
  an earlier session are discarded.
- Account menu entries **سجل تقارير الموظفين** and **سجل الحضور والتقارير**.
  Both offer team/employee filters, the Cairo rolling 30-day window, date ranges,
  pull-to-refresh, explicit load-more, response pagination metadata, and expandable
  report previews. Today's pending report workflow stays separate.
  Both history screens open the existing report-details route using `report.id`.
  Confirmed and unconfirmed reports can be edited using the existing job-specific
  V2 PUT request. Only unconfirmed reports show approval; it uses the existing
  bodyless POST endpoint. Returning reloads history with the selected filters.
  Days without reports have no report actions; attendance stays read-only.
- Daily rows distinguish missing attendance from missing reports; missing attendance
  is never labelled absence. Overnight timestamps remain backend wall times.
  Report metrics use directory job information when available; if unavailable,
  populated metrics are shown without guessing the employee's job.
- On this phone, an existing unreadable secure-storage session blocked the native
  launch screen. Authentication restoration now falls back to login when its token
  cannot be read, without wiping app storage or local records.

## Verification and remaining external setup

Focused automated tests cover manager pagination, changed-filter races, fractional
metrics, missing attendance, overnight checkout, validation, role guards, push
routing/recipient checks, UUID persistence and stale inbox responses.

Validation: all 59 Flutter tests passed. The Android debug build was installed and
launched on RMX3842 (`dedec678`). Home restored the existing manager session;
the saved push topic/owner confirms successful backend registration, and the daily
history screen loaded its empty state. This does not establish actual push delivery.

The manager screens now use the app's blue palette, summary cards, date-grouped
records, a searchable employee sheet, quick Today/Yesterday/7-day/30-day filters,
an Arabic calendar, and contextual empty/error/retry states. Attendance times are
visible without expanding a report. Next-day checkout dates are labelled explicitly;
relevant zero metrics remain visible when the employee job is known. Large text
uses stacked filters and attendance fields. Ten additional UI/date tests cover
these interactions and calendar arithmetic across daylight-saving boundaries.
Six additional tests exercise both history-to-details editing and approval flows,
confirmed-report approval visibility, missing-report actions, and exact write paths
and bodies. These tests use mocked writes and do not approve production reports.

The backend handoff says history endpoints and push changes require deployment.
Deploy those changes and run the dedicated `firebase` queue worker before expecting
private pushes. Use the same Firebase project on the server.

Real delivery still needs an authenticated phone and a backend-triggered private
notification plus a dashboard announcement. Verify foreground, background and
terminated taps, permission denial, token refresh, offline logout and two accounts.
An installed APK or an FCM acceptance is not evidence of delivery.

Only Android Firebase configuration was supplied. iOS push is not enabled: register
the actual iOS bundle ID, obtain its Firebase configuration, extend
`DefaultFirebaseOptions` and the notification platform setup, enable the Xcode Push
Notifications/Remote notifications capabilities, upload APNs credentials, and wait
for an APNs token before requesting FCM registration. Test on an Apple device.
