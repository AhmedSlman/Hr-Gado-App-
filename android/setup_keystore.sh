#!/bin/bash

# Script to generate Android Keystore for Release
# This script will create the keystore and key.properties file

echo "🔐 إعداد Android Keystore للرفع على Google Play"
echo "=============================================="
echo ""

# Check if keystore already exists
if [ -f "app/upload-keystore.jks" ]; then
    echo "⚠️  ملف upload-keystore.jks موجود بالفعل!"
    read -p "هل تريد إنشاء واحد جديد؟ (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "تم الإلغاء."
        exit 1
    fi
    rm -f app/upload-keystore.jks
fi

# Get keystore password
echo "أدخل كلمة مرور Keystore (سيتم إخفاؤها):"
read -s KEYSTORE_PASSWORD
echo ""

# Confirm password
echo "أكد كلمة مرور Keystore:"
read -s KEYSTORE_PASSWORD_CONFIRM
echo ""

if [ "$KEYSTORE_PASSWORD" != "$KEYSTORE_PASSWORD_CONFIRM" ]; then
    echo "❌ كلمات المرور غير متطابقة!"
    exit 1
fi

# Get key password
echo "أدخل كلمة مرور Key (يمكن أن تكون نفس كلمة مرور Keystore):"
read -s KEY_PASSWORD
echo ""

# Confirm key password
echo "أكد كلمة مرور Key:"
read -s KEY_PASSWORD_CONFIRM
echo ""

if [ "$KEY_PASSWORD" != "$KEY_PASSWORD_CONFIRM" ]; then
    echo "❌ كلمات المرور غير متطابقة!"
    exit 1
fi

# Get key alias
KEY_ALIAS="upload"
read -p "أدخل Key Alias (افتراضي: upload): " INPUT_ALIAS
if [ ! -z "$INPUT_ALIAS" ]; then
    KEY_ALIAS=$INPUT_ALIAS
fi

# Get organization info
read -p "أدخل اسم المؤسسة (CN): " ORGANIZATION_NAME
read -p "أدخل اسم الوحدة التنظيمية (OU): " ORGANIZATIONAL_UNIT
read -p "أدخل اسم المؤسسة (O): " ORGANIZATION
read -p "أدخل المدينة (L): " CITY
read -p "أدخل الولاية (ST): " STATE
read -p "أدخل رمز البلد (C) - مثال: EG: " COUNTRY_CODE

# Generate keystore
echo ""
echo "🔄 جاري إنشاء Keystore..."
keytool -genkey -v \
    -keystore app/upload-keystore.jks \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -alias "$KEY_ALIAS" \
    -storepass "$KEYSTORE_PASSWORD" \
    -keypass "$KEY_PASSWORD" \
    -dname "CN=$ORGANIZATION_NAME, OU=$ORGANIZATIONAL_UNIT, O=$ORGANIZATION, L=$CITY, ST=$STATE, C=$COUNTRY_CODE"

if [ $? -eq 0 ]; then
    echo "✅ تم إنشاء Keystore بنجاح!"
    
    # Create key.properties file
    echo ""
    echo "🔄 جاري إنشاء ملف key.properties..."
    
    cat > key.properties << EOF
storePassword=$KEYSTORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=$KEY_ALIAS
storeFile=../app/upload-keystore.jks
EOF

    if [ $? -eq 0 ]; then
        echo "✅ تم إنشاء key.properties بنجاح!"
        echo ""
        echo "📋 ملخص المعلومات:"
        echo "==================="
        echo "Keystore File: app/upload-keystore.jks"
        echo "Key Alias: $KEY_ALIAS"
        echo "Validity: 10000 days (~27 years)"
        echo ""
        echo "⚠️  مهم جداً:"
        echo "============"
        echo "1. احفظ ملف upload-keystore.jks في مكان آمن"
        echo "2. احفظ كلمات المرور في مكان آمن"
        echo "3. بدون Keystore لن تتمكن من تحديث التطبيق!"
        echo "4. ملف key.properties موجود في .gitignore ولن يتم رفعه"
        echo ""
        echo "✅ تم إعداد كل شيء بنجاح!"
    else
        echo "❌ فشل في إنشاء key.properties"
        exit 1
    fi
else
    echo "❌ فشل في إنشاء Keystore"
    exit 1
fi


