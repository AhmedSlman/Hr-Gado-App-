# 🚀 تعليمات بناء ورفع التطبيق على Google Play

## ✅ حالة الإعداد الحالية

### 🔐 Keystore
- ✅ **Keystore File**: `android/app/upload-keystore.jks`
- ✅ **Key Properties**: `android/key.properties`
- ✅ **Key Alias**: `upload`
- ✅ **Validity**: 10000 days (~27 years)

### 📱 Application Info
- **Package Name**: `com.gadohr.app`
- **Application ID**: `com.gadohr.app`
- **Version**: `1.0.0+1` (من `pubspec.yaml`)

---

## 🔨 خطوات البناء

### 1. تحديث Version (عند كل تحديث جديد)

قم بتحديث `version` في `pubspec.yaml`:
```yaml
version: 1.0.0+2  # قم بزيادة الرقم الأخير (versionCode)
```

**ملاحظة**: 
- الرقم الأول (`1.0.0`) هو `versionName` (يظهر للمستخدم)
- الرقم الثاني (`+2`) هو `versionCode` (يستخدمه Google Play)

### 2. بناء App Bundle (موصى به)

```bash
flutter build appbundle --release
```

**الملف الناتج**: `build/app/outputs/bundle/release/app-release.aab`

### 3. أو بناء APK (للاختبار)

```bash
flutter build apk --release
```

**الملف الناتج**: `build/app/outputs/flutter-apk/app-release.apk`

---

## 📤 رفع على Google Play Console

### 1. تسجيل الدخول
- اذهب إلى: https://play.google.com/console
- سجل دخول بحساب المطور

### 2. إنشاء تطبيق جديد (أول مرة فقط)
- اضغط على "إنشاء تطبيق" (Create app)
- املأ:
  - **اسم التطبيق**: Gado HR
  - **اللغة الافتراضية**: العربية
  - **نوع التطبيق**: تطبيق (App)
  - **مجاني أم مدفوع**: اختر حسب الحاجة

### 3. رفع App Bundle
1. اذهب إلى "الإنتاج" (Production) → "إنشاء إصدار جديد" (Create new release)
2. ارفع ملف `.aab` من: `build/app/outputs/bundle/release/app-release.aab`
3. املأ "ملاحظات الإصدار" (Release notes)
4. راجع المعلومات
5. اضغط "مراجعة" (Review) ثم "ابدأ النشر" (Start rollout)

---

## 📋 معلومات مطلوبة في Play Console

### معلومات أساسية
- ✅ **اسم التطبيق**: Gado HR
- ✅ **Package Name**: `com.gadohr.app`
- ⚠️ **لقطات شاشة**: 2 على الأقل (مطلوب)
- ⚠️ **أيقونة التطبيق**: 512x512 px (مطلوب)
- ⚠️ **صورة مميزة**: 1024x500 px (اختياري لكن موصى به)
- ⚠️ **وصف التطبيق**: (مطلوب)
- ⚠️ **سياسة الخصوصية**: URL (مطلوب)
- ⚠️ **التصنيف**: (مطلوب)
- ⚠️ **معلومات المحتوى**: (مطلوب)

---

## ⚠️ تحذيرات مهمة

### 🔒 الأمان
1. **لا ترفع Keystore للـ repository أبداً**
   - الملف موجود في `.gitignore` ✅
   
2. **احفظ نسخة احتياطية من Keystore**
   - بدون Keystore لن تتمكن من تحديث التطبيق!
   - احفظه في مكان آمن (Google Drive مشفر، USB، إلخ)

3. **احفظ كلمات المرور**
   - Keystore Password: `gadohr2024`
   - Key Password: `gadohr2024`
   - Key Alias: `upload`

### 📝 ملاحظات
- عند كل تحديث، قم بزيادة `versionCode` في `pubspec.yaml`
- تأكد من اختبار التطبيق قبل الرفع
- راجع ProGuard rules إذا واجهت مشاكل في التشغيل

---

## 🐛 حل المشاكل

### مشكلة: "Keystore file not found"
- تأكد من وجود `upload-keystore.jks` في `android/app/`
- تأكد من وجود `key.properties` في `android/`
- تأكد من صحة المسار في `key.properties`

### مشكلة: "Signing config error"
- تأكد من صحة كلمات المرور في `key.properties`
- تأكد من صحة `keyAlias`

### مشكلة: "Version code already used"
- قم بزيادة `versionCode` في `pubspec.yaml`
- أعد بناء التطبيق

---

## ✅ Checklist قبل الرفع

- [ ] ✅ Keystore موجود وآمن
- [ ] ✅ `key.properties` موجود ومملوء
- [ ] ✅ `versionCode` محدث في `pubspec.yaml`
- [ ] ✅ تم اختبار التطبيق
- [ ] ✅ تم بناء App Bundle بنجاح
- [ ] ✅ تم إعداد معلومات التطبيق في Play Console
- [ ] ✅ تم إعداد لقطات الشاشة
- [ ] ✅ تم إعداد الأيقونة والصور
- [ ] ✅ تم إعداد سياسة الخصوصية

---

**✅ التطبيق جاهز للرفع!**
