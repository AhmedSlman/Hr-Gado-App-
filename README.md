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

The API base URL in `env.json` includes `/api`; the app adds routes such as `/employee/login`. Change the URL there if the backend uses a different API prefix. iOS builds require macOS and Xcode.
