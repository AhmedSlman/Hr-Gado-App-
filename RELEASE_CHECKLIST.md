# ✅ قائمة التحقق من جاهزية التطبيق للرفع على Google Play

## 🔐 Keystore Configuration

### ✅ تم إعداد Keystore بنجاح

- **Keystore File**: `android/app/upload-keystore.jks` ✅
- **Key Properties**: `android/key.properties` ✅
- **Key Alias**: `upload`
- **Validity**: 10000 days (~27 years)

### ⚠️ معلومات Keystore (احفظها في مكان آمن!)

```
storePassword: gadohr2024
keyPassword: gadohr2024
keyAlias: upload
```

**⚠️ مهم جداً**: بدون Keystore لن تتمكن من تحديث التطبيق على Google Play!

---

## 📱 Application Configuration

### ✅ Application ID
- **Package Name**: `com.gadohr.app`
- **Namespace**: `com.gadohr.app`

### ✅ Version Information
- **Version Name**: `1.0.0` (من `pubspec.yaml`)
- **Version Code**: `1` (من `pubspec.yaml`)

**ملاحظة**: عند كل تحديث، قم بزيادة `versionCode` في `pubspec.yaml`

---

## 🔨 Build Configuration

### ✅ Signing Config
- ✅ تم إعداد `signingConfigs` في `build.gradle.kts`
- ✅ يتم تحميل المعلومات من `key.properties`
- ✅ Release build يستخدم keystore تلقائياً

### ✅ ProGuard/R8
- ✅ `isMinifyEnabled = true`
- ✅ `isShrinkResources = true`
- ✅ ProGuard rules موجودة في `proguard-rules.pro`

---

## 📋 خطوات البناء والرفع

### 1. تحديث Version (عند كل تحديث)
```yaml
# في pubspec.yaml
version: 1.0.0+1  # قم بزيادة الرقم الأخير (versionCode)
```

### 2. بناء APK/AAB للإنتاج

#### بناء App Bundle (موصى به لـ Google Play):
```bash
flutter build appbundle --release
```

#### أو بناء APK:
```bash
flutter build apk --release
```

### 3. موقع الملفات المبنية

- **App Bundle**: `build/app/outputs/bundle/release/app-release.aab`
- **APK**: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🚀 رفع على Google Play Console

### 1. تسجيل الدخول إلى Google Play Console
- اذهب إلى: https://play.google.com/console
- سجل دخول بحساب المطور

### 2. إنشاء تطبيق جديد (إذا كان أول مرة)
- اضغط على "إنشاء تطبيق"
- املأ المعلومات الأساسية:
  - **اسم التطبيق**: Gado HR
  - **اللغة الافتراضية**: العربية
  - **نوع التطبيق**: تطبيق
  - **مجاني أم مدفوع**: اختر حسب الحاجة

### 3. رفع App Bundle
- اذهب إلى "الإنتاج" → "إنشاء إصدار جديد"
- ارفع ملف `.aab` من `build/app/outputs/bundle/release/`
- املأ ملاحظات الإصدار
- راجع المعلومات وارفع

### 4. معلومات التطبيق المطلوبة
- **لقطات شاشة** (2 على الأقل)
- **أيقونة التطبيق** (512x512)
- **صورة مميزة** (1024x500)
- **وصف التطبيق**
- **سياسة الخصوصية** (URL)
- **التصنيف**
- **معلومات المحتوى**

---

## ✅ Checklist قبل الرفع

- [ ] ✅ Keystore موجود وآمن
- [ ] ✅ `key.properties` موجود ومملوء
- [ ] ✅ `versionCode` محدث في `pubspec.yaml`
- [ ] ✅ تم اختبار التطبيق على أجهزة مختلفة
- [ ] ✅ تم اختبار جميع الميزات
- [ ] ✅ تم بناء App Bundle بنجاح
- [ ] ✅ تم مراجعة ProGuard rules
- [ ] ✅ تم إعداد معلومات التطبيق في Play Console
- [ ] ✅ تم إعداد لقطات الشاشة
- [ ] ✅ تم إعداد الأيقونة والصور المطلوبة
- [ ] ✅ تم إعداد سياسة الخصوصية

---

## 🔒 الأمان

### ✅ ملفات محمية في .gitignore
- ✅ `android/key.properties`
- ✅ `android/app/upload-keystore.jks`
- ✅ `*.jks`
- ✅ `*.keystore`

### ⚠️ تحذيرات مهمة
1. **لا ترفع Keystore للـ repository أبداً**
2. **احفظ نسخة احتياطية من Keystore في مكان آمن**
3. **احفظ كلمات المرور في مكان آمن**
4. **بدون Keystore لن تتمكن من تحديث التطبيق**

---

## 📞 الدعم

إذا واجهت أي مشاكل:
1. تأكد من أن `key.properties` موجود ومملوء بشكل صحيح
2. تأكد من أن `upload-keystore.jks` موجود في `android/app/`
3. تأكد من أن المسارات صحيحة
4. جرب حذف مجلد `build/` وإعادة البناء

---

**✅ التطبيق جاهز للرفع على Google Play!**
