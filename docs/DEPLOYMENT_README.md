# 🚀 إرشادات رفع التطبيق على المتاجر

## 📋 نظرة عامة

تم إعداد المشروع للرفع على:
- ✅ **Google Play Store** (Android)
- ✅ **App Store** (iOS)

---

## ⚠️ خطوات مهمة قبل البدء

### 1. تحديث Application ID / Bundle ID

**Android:**
- افتح `android/app/build.gradle.kts`
- غيّر `applicationId = "com.example.hr_app"` إلى معرف فريد
- مثال: `com.gadohr.app` أو `com.yourcompany.gadohr`

**iOS:**
- افتح Xcode: `open ios/Runner.xcworkspace`
- اذهب إلى Runner > Signing & Capabilities
- غيّر Bundle Identifier إلى نفس المعرف المستخدم في Android

### 2. تحديث Version

في `pubspec.yaml`:
```yaml
version: 1.0.0+1
```

- `1.0.0` = version name (يظهر للمستخدم)
- `1` = build number (يجب زيادته مع كل تحديث)

---

## 🤖 Android - Google Play Store

### الخطوة 1: إنشاء Keystore

```bash
cd android/app
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**احفظ:**
- كلمة مرور Keystore
- كلمة مرور Key
- ملف `upload-keystore.jks`

### الخطوة 2: إعداد key.properties

```bash
cd android
cp key.properties.template key.properties
```

افتح `android/key.properties` واملأ:
```properties
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=upload
storeFile=../app/upload-keystore.jks
```

### الخطوة 3: بناء App Bundle

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

الملف: `build/app/outputs/bundle/release/app-release.aab`

### الخطوة 4: الرفع على Google Play

1. افتح [Google Play Console](https://play.google.com/console)
2. أنشئ تطبيق جديد
3. ارفع `app-release.aab`
4. املأ معلومات التطبيق
5. أرسل للتقييم

**📖 راجع:** `RELEASE_CHECKLIST.md` للتفاصيل الكاملة

---

## 🍎 iOS - App Store

### الخطوة 1: إعداد Xcode

```bash
open ios/Runner.xcworkspace
```

### الخطوة 2: تحديث Pods

```bash
cd ios
pod install
cd ..
```

### الخطوة 3: إعداد Signing

1. في Xcode: Runner > Signing & Capabilities
2. اختر Team
3. تأكد من Bundle Identifier

### الخطوة 4: بناء Archive

```bash
flutter clean
flutter pub get
flutter build ios --release
```

ثم في Xcode:
1. Product > Clean Build Folder (Shift+Cmd+K)
2. اختر "Any iOS Device"
3. Product > Archive
4. Distribute App > App Store Connect

### الخطوة 5: الرفع على App Store

1. افتح [App Store Connect](https://appstoreconnect.apple.com)
2. أنشئ تطبيق جديد
3. ارفع Build
4. املأ معلومات التطبيق
5. أرسل للتقييم

**📖 راجع:** `RELEASE_CHECKLIST.md` للتفاصيل الكاملة

---

## 📝 ملفات تم إعدادها

### ✅ Android
- `build.gradle.kts` - إعدادات Signing و ProGuard
- `proguard-rules.pro` - قواعد ProGuard
- `key.properties.template` - قالب ملف Signing
- `AndroidManifest.xml` - جميع الأذونات المطلوبة

### ✅ iOS
- `Info.plist` - جميع الأذونات مع رسائل توضيحية

### ✅ عام
- `.gitignore` - تم تحديثه لحماية ملفات Signing
- `RELEASE_CHECKLIST.md` - قائمة تحقق شاملة
- `BUILD_INSTRUCTIONS.md` - إرشادات البناء التفصيلية

---

## 🔒 الأمان

### ✅ تم إعداد:
- Logging معطل في production (`kDebugMode`)
- ProGuard/R8 مفعل لتقليل الحجم
- Code Shrinking مفعل
- `usesCleartextTraffic=false` للأمان

### ⚠️ يجب عليك:
- **لا ترفع `key.properties` أو `upload-keystore.jks`**
- احفظ Keystore في مكان آمن
- استخدم environment variables للـ API keys

---

## 📊 الأذونات المضافة

### Android
- ✅ Internet
- ✅ Location (Fine, Coarse, Background)
- ✅ Camera
- ✅ Storage (Read/Write)
- ✅ Media Images

### iOS
- ✅ Location (When In Use, Always)
- ✅ Camera
- ✅ Photo Library (Read/Write)

---

## 🛠️ أوامر مفيدة

```bash
# تنظيف
flutter clean

# Dependencies
flutter pub get

# فحص الكود
flutter analyze

# بناء Android
flutter build appbundle --release
flutter build apk --release

# بناء iOS
flutter build ios --release

# توليد الأيقونات
flutter pub run flutter_launcher_icons
```

---

## 📚 ملفات المراجعة

1. **RELEASE_CHECKLIST.md** - قائمة تحقق قبل الرفع
2. **BUILD_INSTRUCTIONS.md** - إرشادات البناء التفصيلية
3. **DEPLOYMENT_README.md** - هذا الملف (نظرة عامة)

---

## ⚠️ ملاحظات مهمة

1. **غيّر Application ID** قبل البناء
2. **احفظ Keystore** في مكان آمن
3. **اختبر التطبيق** قبل الرفع
4. **زِد build number** عند كل تحديث
5. **اقرأ إرشادات كل متجر** بعناية

---

## 🎉 جاهز للرفع!

بعد إكمال الخطوات أعلاه، التطبيق جاهز للرفع على المتاجر.

**حظاً موفقاً! 🚀**


