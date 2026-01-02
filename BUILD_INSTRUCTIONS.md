# 📱 إرشادات بناء التطبيق للإنتاج

## 🤖 Android - بناء App Bundle

### المتطلبات
- Flutter SDK مثبت
- Java JDK 11 أو أحدث
- Android SDK

### الخطوات

#### 1. إعداد Signing Key

```bash
cd android/app
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**ملاحظات مهمة:**
- احفظ كلمة المرور في مكان آمن
- احفظ Keystore في مكان آمن
- **لا ترفع Keystore للـ repository**

#### 2. إعداد key.properties

```bash
cd android
cp key.properties.template key.properties
```

ثم املأ `key.properties`:
```properties
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=upload
storeFile=../app/upload-keystore.jks
```

#### 3. بناء App Bundle

```bash
# تنظيف المشروع
flutter clean

# الحصول على dependencies
flutter pub get

# بناء App Bundle
flutter build appbundle --release
```

الملف الناتج: `build/app/outputs/bundle/release/app-release.aab`

#### 4. بناء APK (للاختبار)

```bash
flutter build apk --release
```

الملف الناتج: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🍎 iOS - بناء للتوزيع

### المتطلبات
- Mac مع Xcode مثبت
- Apple Developer Account ($99/سنة)
- CocoaPods

### الخطوات

#### 1. تحديث Pods

```bash
cd ios
pod install
cd ..
```

#### 2. فتح Xcode

```bash
open ios/Runner.xcworkspace
```

#### 3. إعداد Signing في Xcode

1. افتح Runner في Xcode
2. اذهب إلى "Signing & Capabilities"
3. اختر Team الخاص بك
4. تأكد من أن Bundle Identifier فريد

#### 4. بناء Archive

**في Xcode:**
1. اختر "Any iOS Device" أو "Generic iOS Device"
2. Product > Clean Build Folder (Shift+Cmd+K)
3. Product > Archive
4. انتظر حتى يكتمل Archive

#### 5. توزيع التطبيق

بعد اكتمال Archive:
1. انقر على "Distribute App"
2. اختر "App Store Connect"
3. اتبع الخطوات
4. ارفع التطبيق

**أو من Terminal:**

```bash
# تنظيف المشروع
flutter clean

# الحصول على dependencies
flutter pub get

# بناء iOS
flutter build ios --release

# ثم افتح Xcode واختر Product > Archive
```

---

## 🔧 إعدادات إضافية

### تحديث Version

في `pubspec.yaml`:
```yaml
version: 1.0.0+1
#       ^     ^
#       |     |
#       |     +-- build number (versionCode)
#       +-- version name (versionName)
```

عند كل تحديث:
- غيّر `versionName` (1.0.0 → 1.0.1)
- زد `versionCode` (1 → 2)

### توليد الأيقونات

```bash
flutter pub run flutter_launcher_icons
```

### فحص الكود

```bash
flutter analyze
```

### تشغيل الاختبارات

```bash
flutter test
```

---

## 📊 حجم التطبيق

### تقليل الحجم (Android)

تم تفعيل ProGuard/R8 في `build.gradle.kts`:
- `isMinifyEnabled = true`
- `isShrinkResources = true`

### فحص الحجم

```bash
# Android
flutter build appbundle --release --analyze-size

# iOS
flutter build ios --release --analyze-size
```

---

## ⚠️ ملاحظات مهمة

1. **لا ترفع `key.properties` أو `upload-keystore.jks`**
2. **احفظ نسخة احتياطية من Keystore**
3. **اختبر التطبيق قبل الرفع**
4. **تأكد من تحديث version عند كل build**
5. **تحقق من الأذونات في كل منصة**

---

## 🐛 حل المشاكل الشائعة

### Android: "Execution failed for task ':app:signReleaseBundle'"
- تأكد من وجود `key.properties`
- تأكد من صحة معلومات Keystore
- تأكد من وجود `upload-keystore.jks`

### iOS: "No signing certificate found"
- تأكد من تسجيل الدخول إلى Xcode
- تأكد من اختيار Team
- أنشئ Certificate في Apple Developer Portal

### Build فشل بسبب dependencies
```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
```

---

## 📞 الدعم

- [Flutter Documentation](https://flutter.dev/docs)
- [Android Build Guide](https://flutter.dev/docs/deployment/android)
- [iOS Build Guide](https://flutter.dev/docs/deployment/ios)


