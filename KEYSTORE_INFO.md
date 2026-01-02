# 🔐 معلومات Keystore

## ✅ تم إنشاء Keystore بنجاح!

### معلومات Keystore:
- **الملف**: `android/app/upload-keystore.jks`
- **Alias**: `upload`
- **كلمة مرور Keystore**: `gadohr2024`
- **كلمة مرور Key**: `gadohr2024`
- **صالح لمدة**: 10000 يوم (~27 سنة)

### ⚠️ مهم جداً:

1. **احفظ Keystore في مكان آمن**
   - الملف: `android/app/upload-keystore.jks`
   - بدون هذا الملف لن تتمكن من تحديث التطبيق على Google Play

2. **احفظ كلمات المرور**
   - Keystore Password: `gadohr2024`
   - Key Password: `gadohr2024`

3. **لا ترفع Keystore للـ repository**
   - الملف موجود في `.gitignore` ولن يتم رفعه

4. **تغيير كلمات المرور (موصى به)**
   - يمكنك تغيير كلمات المرور باستخدام:
   ```bash
   keytool -storepasswd -keystore upload-keystore.jks
   ```

### 📝 ملاحظات:

- **Application ID**: `com.gadohr.app`
- **Package Name**: `com.gadohr.app`
- **Keystore**: جاهز للاستخدام

### 🔄 عند الحاجة لتغيير كلمات المرور:

1. قم بتغيير كلمات المرور في Keystore
2. قم بتحديث `android/key.properties` بنفس القيم الجديدة

---

**⚠️ حفظ آمن**: احفظ نسخة احتياطية من Keystore في مكان آمن (مثل Google Drive مشفر أو USB)


