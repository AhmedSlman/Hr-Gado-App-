# Active v2 update

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

