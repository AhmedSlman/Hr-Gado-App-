# Active v2 update

## Manager report form fix — 20 October 2026

Manager editing now selects the driver's installation/supply/overtime fields,
the technician's devices/meters fields, the sales sold/bought/commercial fields,
or the other employee's overtime field. All variants require report text.
Nested or flat `job_type` takes precedence over the job label; older responses
without a type or job label fall back to their non-null report metrics.
Unrelated API metrics are hidden, missing fields start at zero, and only changed
values are submitted.

Validation: all 10 focused report tests passed; analysis of the three changed
Dart files passed with no issues. Project-wide analysis reports 340 existing
warnings/style notices. Authenticated manager editing has not been device-tested.

Release APK built and signature verified: version 1.0.0+7, application ID
`com.gadohr.app`, 62,272,966 bytes. Uses the existing Android Debug signing
fallback; store distribution requires release signing.

Artifact: `build/app/outputs/flutter-apk/app-release.apk`

SHA-256: `4E449D743B1D1BC19ECA36031987D493CECCEA5D6FF3C8801DEB9308E46C9A08`

Implemented locally on `development` using `handoff.md`.

All eight v2 endpoints are integrated: salary summary, own report list/detail, daily report submission, manager review list/detail/editing, and home. Confirmation retains the specified legacy endpoint.

Drivers enter separate installation and supply counts. All device counts and meters use numeric text fields with no UI maximum; overtime remains the 0–11 list. Manager edits preserve omitted fields and submit only changed numeric JSON values. Review fields reflect the report owner. Home salary is optional and server amounts are displayed without local payroll calculation.

Validation: 24 focused tests passed; analyzer has zero errors and 12 existing warnings. Authenticated backend checks remain unverified. The unrelated counter-template test remains a known baseline failure.

## Build reproduction

```powershell
New-Item -ItemType Directory -Force -Path build/java-tmp | Out-Null
$env:JAVA_TOOL_OPTIONS = '-Djdk.net.unixdomain.tmpdir=C:/Users/Interface/Hr-Gado-App-/build/java-tmp'
flutter build apk --release --no-pub --dart-define-from-file=env.json
```

The Java option works around Windows short-path temporary socket failures on this machine.

The project has no release keystore configured, so release-mode builds use the existing debug-key fallback. This APK can be used for device testing; store publishing requires the app owner's release signing configuration.

## Verified release result

Built 8 October 2026: version 1.0.0+6, application ID com.gadohr.app, size 62191050 bytes. APK signature verification passed with the Android Debug certificate.

SHA-256: 76C3ACA04578F50F46FDCD341E36F61916B302EFFA3C160B3A4E4648E3D02267

