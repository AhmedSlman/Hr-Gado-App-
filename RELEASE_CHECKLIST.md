# 📋 قائمة التحقق قبل الرفع على المتاجر

## ✅ إعدادات عامة

### 1. تحديث معلومات التطبيق
- [ ] تحديث `version` في `pubspec.yaml` (مثال: `1.0.0+1`)
- [ ] تحديث `applicationId` في `android/app/build.gradle.kts` (تغيير `com.example.hr_app` إلى معرف فريد)
- [ ] تحديث `PRODUCT_BUNDLE_IDENTIFIER` في Xcode (تغيير `com.example.hrApp` إلى معرف فريد)
- [ ] تحديث اسم التطبيق في `AndroidManifest.xml` و `Info.plist`

### 2. الأيقونات والصور
- [ ] التأكد من وجود أيقونة التطبيق في `assets/images/gado.png`
- [ ] تشغيل `flutter pub run flutter_launcher_icons` لتوليد الأيقونات
- [ ] التحقق من وجود جميع أحجام الأيقونات المطلوبة

### 3. الأذونات
- [x] إضافة جميع الأذونات المطلوبة في `AndroidManifest.xml`
- [x] إضافة جميع الأذونات المطلوبة في `Info.plist` مع رسائل توضيحية

---

## 🤖 Android - Google Play Store

### 1. إعداد Signing
- [ ] إنشاء keystore:
  ```bash
  cd android/app
  keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
  ```
- [ ] نسخ `android/key.properties.template` إلى `android/key.properties`
- [ ] ملء معلومات `key.properties`:
  ```
  storePassword=your_keystore_password
  keyPassword=your_key_password
  keyAlias=upload
  storeFile=../app/upload-keystore.jks
  ```
- [ ] **مهم**: حفظ `key.properties` و `upload-keystore.jks` في مكان آمن (لن يتم رفعهما للـ repository)

### 2. Build Release
- [ ] تنظيف المشروع: `flutter clean`
- [ ] الحصول على dependencies: `flutter pub get`
- [ ] بناء APK للاختبار:
  ```bash
  flutter build apk --release
  ```
- [ ] بناء App Bundle للرفع:
  ```bash
  flutter build appbundle --release
  ```
- [ ] الملف الناتج: `build/app/outputs/bundle/release/app-release.aab`

### 3. التحقق من Build
- [ ] اختبار APK على أجهزة مختلفة
- [ ] التحقق من عمل جميع الميزات
- [ ] التحقق من الأذونات
- [ ] التحقق من حجم التطبيق

### 4. معلومات Google Play Console
- [ ] إنشاء حساب مطور (إذا لم يكن موجود)
- [ ] إعداد صفحة التطبيق:
  - اسم التطبيق
  - الوصف (قصير وطويل)
  - لقطات الشاشة (2-8 صور)
  - أيقونة (512x512)
  - فيديو (اختياري)
- [ ] تحديد فئة التطبيق
- [ ] تحديد المحتوى والتصنيف
- [ ] إعداد السعر والموزع

### 5. الرفع
- [ ] رفع `app-release.aab` إلى Google Play Console
- [ ] ملء معلومات Privacy Policy
- [ ] إعداد Content Rating
- [ ] إرسال للتقييم

---

## 🍎 iOS - App Store

### 1. إعداد Xcode
- [ ] فتح `ios/Runner.xcworkspace` في Xcode
- [ ] تحديد Team في Signing & Capabilities
- [ ] تحديث Bundle Identifier ليكون فريداً
- [ ] التحقق من إعدادات Deployment Target (iOS 13.0+)

### 2. إعداد Certificates & Profiles
- [ ] تسجيل الدخول إلى [Apple Developer Portal](https://developer.apple.com)
- [ ] إنشاء App ID
- [ ] إنشاء Distribution Certificate
- [ ] إنشاء App Store Distribution Profile
- [ ] تحميل Profile في Xcode

### 3. Build Archive
- [ ] تنظيف المشروع: `flutter clean`
- [ ] الحصول على dependencies: `flutter pub get`
- [ ] بناء iOS Release:
  ```bash
  flutter build ios --release
  ```
- [ ] فتح Xcode واختيار Product > Archive
- [ ] بعد اكتمال Archive، النقر على "Distribute App"
- [ ] اختيار "App Store Connect"
- [ ] اتباع الخطوات لرفع التطبيق

### 4. معلومات App Store Connect
- [ ] إنشاء حساب مطور (إذا لم يكن موجود)
- [ ] إنشاء App جديد في App Store Connect
- [ ] إعداد معلومات التطبيق:
  - اسم التطبيق
  - الوصف
  - الكلمات المفتاحية
  - لقطات الشاشة (لجميع أحجام الشاشات)
  - أيقونة (1024x1024)
  - فيديو (اختياري)
- [ ] إعداد Pricing and Availability
- [ ] إعداد App Privacy

### 5. الرفع
- [ ] رفع Build من Xcode
- [ ] انتظار معالجة Build في App Store Connect
- [ ] إرسال للتقييم

---

## 🔒 الأمان والخصوصية

### 1. إزالة معلومات التطوير
- [ ] إزالة `debugShowCheckedModeBanner: true` (إذا كان موجود)
- [ ] تعطيل logging في production
- [ ] إزالة API keys وsecrets من الكود
- [ ] استخدام environment variables

### 2. Privacy Policy
- [ ] إنشاء Privacy Policy
- [ ] ربطها في المتاجر
- [ ] التأكد من أنها تغطي جميع الأذونات المستخدمة

### 3. Terms of Service
- [ ] إنشاء Terms of Service (اختياري لكن موصى به)

---

## 📊 بعد الرفع

### Google Play
- [ ] مراقبة المراجعات والتقييمات
- [ ] الرد على التعليقات
- [ ] تحديثات دورية

### App Store
- [ ] مراقبة المراجعات
- [ ] الرد على التعليقات
- [ ] تحديثات دورية

---

## 🛠️ أوامر مفيدة

```bash
# تنظيف المشروع
flutter clean

# الحصول على dependencies
flutter pub get

# بناء Android APK
flutter build apk --release

# بناء Android App Bundle
flutter build appbundle --release

# بناء iOS
flutter build ios --release

# فحص الكود
flutter analyze

# تشغيل الاختبارات
flutter test

# توليد الأيقونات
flutter pub run flutter_launcher_icons
```

---

## ⚠️ ملاحظات مهمة

1. **لا ترفع `key.properties` أو `upload-keystore.jks` للـ repository**
2. **احفظ نسخة احتياطية من keystore في مكان آمن**
3. **تأكد من تحديث versionCode/versionName عند كل تحديث**
4. **اختبر التطبيق جيداً قبل الرفع**
5. **اقرأ إرشادات كل متجر بعناية**

---

## 📞 الدعم

إذا واجهت مشاكل:
- راجع [Flutter Documentation](https://flutter.dev/docs)
- راجع [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- راجع [App Store Connect Help](https://help.apple.com/app-store-connect/)


