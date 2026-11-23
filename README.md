# HR Gado app

Flutter mobile app. The `development` branch contains the integrated application. The backend URL is set in `env.json`; without a Dart define, the app uses the default development URL in `NetworkConfig`.

## Run on an Android phone

1. Install Flutter and Android Studio, then run `flutter doctor` and complete any Android setup it reports.
2. On the phone, enable Developer options and USB debugging, connect it by USB, and approve the computer's debugging prompt.
3. In this folder, run:

   ```powershell
   flutter pub get
   flutter devices
   flutter run --dart-define-from-file=env.json
   ```

   If more than one device appears, use `flutter run -d <device-id> --dart-define-from-file=env.json`.

To build an installable debug APK, run `flutter build apk --debug --dart-define-from-file=env.json`. The output is `build/app/outputs/flutter-apk/app-debug.apk`.

The API base URL in `env.json` includes `/api`. The app adds routes such as `/employee/login`.

## iOS release handoff

1. On macOS, install the Flutter version in `.fvmrc`, Xcode, and CocoaPods. Run `flutter doctor` and `flutter pub get`.
2. Confirm the production API URL in `env.json`. Run `pod install` from `ios/` to refresh the existing CocoaPods lockfile for the current Flutter plugins.
3. Open `ios/Runner.xcworkspace`. In the Runner target, select the Apple Developer team and set the bundle identifier to the one assigned to the app in App Store Connect. The project currently uses `com.example.hrApp` and targets iOS 15 or later.
4. Test login and attendance with location permissions on a physical iPhone. Push notifications currently run on Android only. Enabling them on iOS requires Firebase configuration for the final bundle identifier, APNs setup, and iOS support in the app's push service.
5. Choose a build number higher than any build already uploaded for this App Store version. From the project root, run `flutter build ipa --dart-define-from-file=env.json --build-number=<build-number>`, then upload the signed build to App Store Connect.
